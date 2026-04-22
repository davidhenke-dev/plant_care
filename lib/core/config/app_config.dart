class AppConfig {
  // Keys come from secrets.json via --dart-define-from-file=secrets.json
  // Copy secrets.example.json → secrets.json and fill in your keys.
  // The file is gitignored and never committed.

  static const perenualApiKey = String.fromEnvironment('PERENUAL_API_KEY');
  static const anthropicApiKey = String.fromEnvironment('ANTHROPIC_API_KEY');

  static bool get isConfigured => perenualApiKey.isNotEmpty;
}
