class NotificationSettings {
  const NotificationSettings({
    required this.notifyOnFollow,
    required this.notifyOnLike,
    required this.notifyOnRepost,
    required this.notifyOnComment,
    required this.notifyOnDM,
  });

  final bool notifyOnFollow;
  final bool notifyOnLike;
  final bool notifyOnRepost;
  final bool notifyOnComment;
  final bool notifyOnDM;

  NotificationSettings copyWith({
    bool? notifyOnFollow,
    bool? notifyOnLike,
    bool? notifyOnRepost,
    bool? notifyOnComment,
    bool? notifyOnDM,
  }) {
    return NotificationSettings(
      notifyOnFollow: notifyOnFollow ?? this.notifyOnFollow,
      notifyOnLike: notifyOnLike ?? this.notifyOnLike,
      notifyOnRepost: notifyOnRepost ?? this.notifyOnRepost,
      notifyOnComment: notifyOnComment ?? this.notifyOnComment,
      notifyOnDM: notifyOnDM ?? this.notifyOnDM,
    );
  }
}
