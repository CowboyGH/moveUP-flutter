import 'package:cookie_jar/cookie_jar.dart';

import 'guest_session_storage.dart';

/// CookieJar-backed implementation of [GuestSessionStorage].
final class CookieJarGuestSessionStorage implements GuestSessionStorage {
  final CookieJar _cookieJar;
  final Uri _baseUri;

  /// Creates an instance of [CookieJarGuestSessionStorage].
  CookieJarGuestSessionStorage(this._cookieJar, this._baseUri);

  @override
  Future<void> clear() async {
    await _cookieJar.delete(_baseUri, true);
  }
}
