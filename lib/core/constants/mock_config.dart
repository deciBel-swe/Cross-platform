class MockConfig {
  MockConfig._();

  /// Global flag to determine if the app should use mock data or real backend services.
  static bool useMockData = const bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: true,
  );
}
