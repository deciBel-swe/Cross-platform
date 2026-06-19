String formatInboxTimeAgo(DateTime date) {
  final now = DateTime.now();
  final safeDate = date.isAfter(now) ? now : date;
  final difference = now.difference(safeDate);

  if (difference.inDays > 0) return '${difference.inDays}d';
  if (difference.inHours > 0) return '${difference.inHours}h';
  if (difference.inMinutes > 0) return '${difference.inMinutes}m';
  return 'Now';
}
