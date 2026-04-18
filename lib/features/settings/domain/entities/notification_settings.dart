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

  Map<String, dynamic> toJson() {
    return {
      'notifyOnFollow': notifyOnFollow,
      'notifyOnLike': notifyOnLike,
      'notifyOnRepost': notifyOnRepost,
      'notifyOnComment': notifyOnComment,
      'notifyOnDM': notifyOnDM,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      notifyOnFollow: json['notifyOnFollow'] as bool? ?? true,
      notifyOnLike: json['notifyOnLike'] as bool? ?? true,
      notifyOnRepost: json['notifyOnRepost'] as bool? ?? true,
      notifyOnComment: json['notifyOnComment'] as bool? ?? true,
      notifyOnDM: json['notifyOnDM'] as bool? ?? true,
    );
  }
}