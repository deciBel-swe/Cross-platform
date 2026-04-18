class DeviceTokenRequest {
  const DeviceTokenRequest({
    required this.token,
    required this.deviceType,
  });

  final String token;
  final String deviceType;

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'deviceType': deviceType,
    };
  }
}