/// Google OAuth client IDs used by the native Sign in with Google flow.
///
/// These come from the Google Cloud console (APIs & Services → Credentials)
/// for the same project the backend verifies ID tokens against.
///
/// Values can be overridden at build time without touching this file:
///   flutter build apk --dart-define=GOOGLE_SERVER_CLIENT_ID=...
class GoogleSignInConfig {
  GoogleSignInConfig._();

  /// OAuth client of type **Web application**.
  ///
  /// Required on Android — Credential Manager mints the ID token with this
  /// client as the audience, and it is what the backend verifies against.
  static const String serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: 'TODO_WEB_CLIENT_ID.apps.googleusercontent.com',
  );

  /// OAuth client of type **iOS** (bundle id com.holepackage.app).
  ///
  /// Required on iOS. Must match the `GIDClientID` / reversed-client-id URL
  /// scheme in ios/Runner/Info.plist.
  static const String iosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: 'TODO_IOS_CLIENT_ID.apps.googleusercontent.com',
  );

  static bool get isConfigured =>
      !serverClientId.startsWith('TODO_') && !iosClientId.startsWith('TODO_');
}
