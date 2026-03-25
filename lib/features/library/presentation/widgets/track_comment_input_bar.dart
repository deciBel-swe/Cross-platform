import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TrackCommentInputBar extends StatefulWidget {
  const TrackCommentInputBar({super.key});

  @override
  State<TrackCommentInputBar> createState() => _TrackCommentInputBarState();
}

class _TrackCommentInputBarState extends State<TrackCommentInputBar> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: TextEditingController(text: text),
              style: const TextStyle(color: AppColors.onBackground),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Drop a comment...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
