import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';

import '../../../../core/theme/app_colors.dart';

/// Horizontal scrollable row for sharing options.
class ShareOptionsRow extends StatelessWidget {
  const ShareOptionsRow({super.key, required this.onCopyLinkTap});

  final Future<Either<Failure, String>> Function() onCopyLinkTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'SHARE',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _ShareIcon(icon: Icons.send, label: 'Message', onTap: () {}),
              _ShareIcon(
                icon: Icons.copy,
                label: 'Copy Link',
                onTap: () async {
                  // Fetch the link via the callback
                  final result = await onCopyLinkTap();

                  result.fold(
                    (failure) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(failure.message),
                            backgroundColor: AppColors.errors,
                          ),
                        );
                      }
                    },

                    (secretLink) async {
                      // Copy to clipboard
                      await Clipboard.setData(ClipboardData(text: secretLink));

                      // Show visual feedback to the user
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Link copied to clipboard!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              _ShareIcon(
                icon: Icons.chat,
                label: 'WhatsApp',
                color: AppColors.success,
                onTap: () {},
              ),
              _ShareIcon(
                icon: Icons.camera_alt,
                label: 'Stories',
                color: AppColors.instagram,
                onTap: () {},
              ),
              _ShareIcon(icon: Icons.sms, label: 'SMS', onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShareIcon extends StatelessWidget {
  const _ShareIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textPrimary,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderDark, width: 1),
                  // ignore: deprecated_member_use
                  color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
