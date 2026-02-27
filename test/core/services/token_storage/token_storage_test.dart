import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/services/token_storage/secure_token_storage.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';

import 'token_storage_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
void main() {
  late FlutterSecureStorage secureStorage;
  late TokenStorage tokenStorage;
  const accessTokenKey = 'access_token';
  const testToken = 'test_token';

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    tokenStorage = SecureTokenStorage(secureStorage);
  });

  group('SecureTokenStorage', () {
    test('getAccessToken returns token when it exists', () async {
      // Arrange
      when(
        secureStorage.read(key: accessTokenKey),
      ).thenAnswer((_) async => testToken);

      // Act
      final token = await tokenStorage.getAccessToken();

      // Assert
      expect(token, testToken);
      verify(secureStorage.read(key: accessTokenKey)).called(1);
      verifyNoMoreInteractions(secureStorage);
    });

    test('getAccessToken returns null when token does not exist', () async {
      // Arrange
      when(
        secureStorage.read(key: accessTokenKey),
      ).thenAnswer((_) async => null);

      // Act
      final token = await tokenStorage.getAccessToken();

      // Assert
      expect(token, isNull);
      verify(secureStorage.read(key: accessTokenKey)).called(1);
      verifyNoMoreInteractions(secureStorage);
    });

    test('saveAccessToken writes token to secure storage', () async {
      // Arrange
      when(
        secureStorage.write(key: accessTokenKey, value: testToken),
      ).thenAnswer((_) async {});

      // Act
      await tokenStorage.saveAccessToken(testToken);

      // Assert
      verify(
        secureStorage.write(key: accessTokenKey, value: testToken),
      ).called(1);
      verifyNoMoreInteractions(secureStorage);
    });

    test('deleteAccessToken removes token from secure storage', () async {
      // Arrange
      when(
        secureStorage.delete(key: accessTokenKey),
      ).thenAnswer((_) async {});

      // Act
      await tokenStorage.deleteAccessToken();

      // Assert
      verify(secureStorage.delete(key: accessTokenKey)).called(1);
      verifyNoMoreInteractions(secureStorage);
    });

    test('hasAccessToken returns true when token exists', () async {
      // Arrange
      when(
        secureStorage.containsKey(key: accessTokenKey),
      ).thenAnswer((_) async => true);

      // Act
      final hasAccessToken = await tokenStorage.hasAccessToken();

      // Assert
      expect(hasAccessToken, true);
      verify(secureStorage.containsKey(key: accessTokenKey)).called(1);
      verifyNoMoreInteractions(secureStorage);
    });

    test('hasAccessToken returns false when token does not exist', () async {
      // Arrange
      when(
        secureStorage.containsKey(key: accessTokenKey),
      ).thenAnswer((_) async => false);

      // Act
      final hasAccessToken = await tokenStorage.hasAccessToken();

      // Assert
      expect(hasAccessToken, false);
      verify(secureStorage.containsKey(key: accessTokenKey)).called(1);
      verifyNoMoreInteractions(secureStorage);
    });
  });
}
