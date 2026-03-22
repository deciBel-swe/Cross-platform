enum AuthWebViewMode {
  login,
  register,
}

class WebViewAuthConfig {
  static const bool useMockAuthPage = true;

  static const String callbackScheme = 'decibel';
  static const String callbackHost = 'callback';

  static const String tokenParam = 'accessToken';
  static const String refreshTokenParam = 'refreshToken';

  // Replace later with real frontend URLs
  static const String loginUrl =
      'http://10.0.2.2:3000/login?redirect_uri=decibel://callback';

  static const String registerUrl =
      'http://10.0.2.2:3000/register?redirect_uri=decibel://callback';

  static String getUrl(AuthWebViewMode mode) {
    switch (mode) {
      case AuthWebViewMode.login:
        return loginUrl;
      case AuthWebViewMode.register:
        return registerUrl;
    }
  }

  static const String mockLoginHtml = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mock Login</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 24px;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      box-sizing: border-box;
      background: #121212;
      color: white;
    }
    .card {
      width: 100%;
      max-width: 420px;
      padding: 24px;
      border-radius: 16px;
      background: #1e1e1e;
      box-shadow: 0 8px 30px rgba(0,0,0,0.25);
    }
    h2 {
      margin-top: 0;
      margin-bottom: 12px;
    }
    p {
      color: #cccccc;
      line-height: 1.5;
      margin-bottom: 16px;
    }
    button {
      width: 100%;
      margin-top: 12px;
      padding: 14px;
      border: none;
      border-radius: 10px;
      background: #ff7a00;
      color: white;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="card">
    <h2>Mock Login Flow</h2>
    <p>This simulates the login web flow.</p>
    <button onclick="window.location.href='decibel://callback?accessToken=mock_login_access_token&refreshToken=mock_login_refresh_token'">
      Simulate Login Success
    </button>
  </div>
</body>
</html>
''';

  static const String mockRegisterHtml = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mock Register</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 24px;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      box-sizing: border-box;
      background: #121212;
      color: white;
    }
    .card {
      width: 100%;
      max-width: 420px;
      padding: 24px;
      border-radius: 16px;
      background: #1e1e1e;
      box-shadow: 0 8px 30px rgba(0,0,0,0.25);
    }
    h2 {
      margin-top: 0;
      margin-bottom: 12px;
    }
    p {
      color: #cccccc;
      line-height: 1.5;
      margin-bottom: 16px;
    }
    button {
      width: 100%;
      margin-top: 12px;
      padding: 14px;
      border: none;
      border-radius: 10px;
      background: #ff7a00;
      color: white;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="card">
    <h2>Mock Create Account Flow</h2>
    <p>This simulates the registration web flow.</p>
    <button onclick="window.location.href='decibel://callback?accessToken=mock_register_access_token&refreshToken=mock_register_refresh_token'">
      Simulate Registration Success
    </button>
  </div>
</body>
</html>
''';

  static String getMockHtml(AuthWebViewMode mode) {
    switch (mode) {
      case AuthWebViewMode.login:
        return mockLoginHtml;
      case AuthWebViewMode.register:
        return mockRegisterHtml;
    }
  }

  static String getTitle(AuthWebViewMode mode) {
    switch (mode) {
      case AuthWebViewMode.login:
        return 'Log In';
      case AuthWebViewMode.register:
        return 'Create Account';
    }
  }
}