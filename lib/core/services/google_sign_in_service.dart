import 'dart:io' show Platform;

import 'package:google_sign_in/google_sign_in.dart';

import '../config/google_sign_in_config.dart';

/// Thin wrapper around [GoogleSignIn] so the plugin is initialized exactly
/// once per process — `initialize()` must not be called twice, and the
/// Continue-with-Google button exists on both the sign-in and sign-up screens.
class GoogleSignInService {
  GoogleSignInService._();

  static Future<void>? _initFuture;

  static Future<void> _ensureInitialized() {
    if (!GoogleSignInConfig.isConfigured) {
      // Credential Manager fails with an opaque framework error when handed a
      // client id that doesn't exist, so fail loudly here instead.
      throw StateError(
        'Google sign-in is not configured — the client ids in '
        'lib/core/config/google_sign_in_config.dart are still placeholders.',
      );
    }
    return _initFuture ??= GoogleSignIn.instance.initialize(
      // iOS needs its own client id; on Android the client is resolved from
      // the package name + signing certificate registered in Google Cloud.
      clientId: (Platform.isIOS || Platform.isMacOS)
          ? GoogleSignInConfig.iosClientId
          : null,
      // Audience of the returned ID token on Android, and the client the
      // backend verifies against.
      serverClientId: GoogleSignInConfig.serverClientId,
    );
  }

  /// Runs the native account picker and returns the signed-in account.
  ///
  /// Throws [GoogleSignInException] (code `canceled` when the user backs out).
  static Future<GoogleSignInAccount> authenticate() async {
    await _ensureInitialized();
    return GoogleSignIn.instance.authenticate(
      scopeHint: const <String>['email', 'profile'],
    );
  }

  /// Clears the cached account so the next tap shows the picker again.
  static Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Signing out is best-effort — never block the caller on it.
    }
  }
}
