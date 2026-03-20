import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ExpandableBio extends StatefulWidget {
  const ExpandableBio({required this.bio});

  final String bio;

  @override
  State<ExpandableBio> createState() => _ExpandableBioState();
}

class _ExpandableBioState extends State<ExpandableBio> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: AppColors.onPrimary);

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.bio, style: textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: 3,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);
        final isOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bio,
              style: textStyle,
              maxLines: _expanded ? null : 3,
              overflow: _expanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            if (isOverflow)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? 'Show less' : 'Show more',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.google),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}