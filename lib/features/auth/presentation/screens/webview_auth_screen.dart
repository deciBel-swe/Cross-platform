import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/webview_auth_config.dart';

class WebViewAuthScreen extends StatefulWidget {
  const WebViewAuthScreen({
    super.key,
    required this.mode,
    required this.onTokensReceived,
  });

  final AuthWebViewMode mode;
  final Future<void> Function({
    required String token,
    required String refreshToken,
  }) onTokensReceived;

  @override
  State<WebViewAuthScreen> createState() => _WebViewAuthScreenState();
}

class _WebViewAuthScreenState extends State<WebViewAuthScreen> {
  late final WebViewController _controller;

  bool _isInitialLoading = true;
  bool _hasLoadError = false;
  bool _isHandlingCallback = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _hasLoadError = false;
              _errorMessage = null;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() {
              _isInitialLoading = false;
            });
          },
          onWebResourceError: (error) {
            if (!mounted) return;

            final failingUrl = error.url ?? '';
            final isCallbackUrl =
                failingUrl.startsWith('${WebViewAuthConfig.callbackScheme}://');

            if (isCallbackUrl) return;

            setState(() {
              _isInitialLoading = false;
              _hasLoadError = true;
              _errorMessage = error.description;
            });
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);

            if (uri == null) {
              return NavigationDecision.navigate;
            }

            final isAuthCallback =
                uri.scheme == WebViewAuthConfig.callbackScheme &&
                uri.host == WebViewAuthConfig.callbackHost;

            if (isAuthCallback) {
              _handleAuthCallback(uri);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    if (WebViewAuthConfig.useMockAuthPage) {
      _controller.loadHtmlString(WebViewAuthConfig.getMockHtml(widget.mode));
    } else {
      _controller.loadRequest(
        Uri.parse(WebViewAuthConfig.getUrl(widget.mode)),
      );
    }
  }

  Future<void> _handleAuthCallback(Uri uri) async {
    if (_isHandlingCallback) return;

    final token = uri.queryParameters[WebViewAuthConfig.tokenParam];
    final refreshToken =
        uri.queryParameters[WebViewAuthConfig.refreshTokenParam];

    if (token == null ||
        token.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication succeeded, but token data was missing.'),
        ),
      );
      return;
    }

    setState(() {
      _isHandlingCallback = true;
    });

    try {
      await widget.onTokensReceived(
        token: token,
        refreshToken: refreshToken,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isHandlingCallback = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to store auth session: $e'),
        ),
      );
    }
  }

  Future<void> _retry() async {
    setState(() {
      _hasLoadError = false;
      _errorMessage = null;
      _isInitialLoading = true;
    });

    if (WebViewAuthConfig.useMockAuthPage) {
      await _controller.loadHtmlString(
        WebViewAuthConfig.getMockHtml(widget.mode),
      );
    } else {
      await _controller.loadRequest(
        Uri.parse(WebViewAuthConfig.getUrl(widget.mode)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasLoadError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(WebViewAuthConfig.getTitle(widget.mode)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 56),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load the authentication page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _retry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(WebViewAuthConfig.getTitle(widget.mode)),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isInitialLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (_isHandlingCallback)
              Container(
                color: Colors.black.withOpacity(0.15),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}