class SocialSettings {
  SocialSettings({required this.isPrivate, required this.showHistory});

  factory SocialSettings.fromJson(Map<String, dynamic> json) {
    return SocialSettings(
      isPrivate: json['isPrivate'] is bool ? json['isPrivate'] as bool : false,
      showHistory: json['showHistory'] is bool
          ? json['showHistory'] as bool
          : true,
    );
  }
  final bool isPrivate;
  final bool showHistory;

  Map<String, dynamic> toJson() => {
    'isPrivate': isPrivate,
    'showHistory': showHistory,
  };

  SocialSettings copyWith({bool? isPrivate, bool? showHistory}) {
    return SocialSettings(
      isPrivate: isPrivate ?? this.isPrivate,
      showHistory: showHistory ?? this.showHistory,
    );
  }
}
