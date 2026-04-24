import 'package:flutter/material.dart';

class MentionTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (!text.startsWith('@')) {
      return TextSpan(text: text, style: style);
    }

    final int firstSpaceIndex = text.indexOf(' ');

    if (firstSpaceIndex == -1) {
      return TextSpan(
        text: text,
        style: style?.copyWith(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final String mention = text.substring(0, firstSpaceIndex);
    final String rest = text.substring(firstSpaceIndex);

    return TextSpan(
      style: style,
      children: [
        TextSpan(
          text: mention,
          style: style?.copyWith(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(text: rest, style: style),
      ],
    );
  }
}
