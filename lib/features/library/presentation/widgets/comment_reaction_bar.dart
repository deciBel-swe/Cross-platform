import 'package:flutter/material.dart';

class CommentReactionBar extends StatefulWidget {
  const CommentReactionBar({super.key});

  @override
  State<CommentReactionBar> createState() => _CommentReactionBarState();
}

class _CommentReactionBarState extends State<CommentReactionBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Drop a commen...',
                      hintStyle: TextStyle(color: Colors.white38),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (!_isTyping) ...[
                  const Text('🔥', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  const Text('👏', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  const Text('🥺', style: TextStyle(fontSize: 20)),
                ],
              ],
            ),
          ),
        ),
        if (_isTyping) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.send_rounded,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ],
    );
  }
}
