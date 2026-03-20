import 'package:cookie_jar/cookie_jar.dart';

import 'guest_session_storage.dart';

/// CookieJar-backed implementation of [GuestSessionStorage].
final class CookieJarGuestSessionStorage implements GuestSessionStorage {
  final CookieJar _cookieJar;

  /// Creates an instance of [CookieJarGuestSessionStorage].
  CookieJarGuestSessionStorage(this._cookieJar);

  @override
  Future<void> clear() async {
    await _cookieJar.deleteAll();
  }
}
