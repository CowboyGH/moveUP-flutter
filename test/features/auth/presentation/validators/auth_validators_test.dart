import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/features/auth/presentation/validators/auth_validators.dart';

void main() {
  group('AuthValidators.name', () {
    const nameEmptyMessage = 'Введите имя';
    const nameMaxLengthMessage = 'Длина имени должна быть не более 20 символов';
    const nameMinLengthMessage = 'Длина имени должна быть не менее 2 символов';

    test('returns required error when value is empty', () {
      expect(AuthValidators.name(null), nameEmptyMessage);
      expect(AuthValidators.name(''), nameEmptyMessage);
      expect(AuthValidators.name('   '), nameEmptyMessage);
    });

    test('returns min length error when value is too short', () {
      const tooShortName = 'a';
      expect(AuthValidators.name(tooShortName), nameMinLengthMessage);
    });

    test('returns max length error when value is too long', () {
      final tooLongName = 'a' * 21;
      expect(AuthValidators.name(tooLongName), nameMaxLengthMessage);
    });

    test('returns null when value is valid', () {
      expect(AuthValidators.name('Имя'), isNull);
      expect(AuthValidators.name('  Имя Имя  '), isNull);
    });
  });

  group('AuthValidators.email', () {
    const emailEmptyMessage = 'Введите email';
    const wrongFormatMessage = 'Неверный формат email';

    test('returns required error when value is empty', () {
      expect(AuthValidators.email(null), emailEmptyMessage);
      expect(AuthValidators.email(''), emailEmptyMessage);
      expect(AuthValidators.email('   '), emailEmptyMessage);
    });

    test('returns format error when value is invalid', () {
      expect(AuthValidators.email('invalid_email'), wrongFormatMessage);
      expect(AuthValidators.email('name@domain'), wrongFormatMessage);
      expect(AuthValidators.email('.user@example.com'), wrongFormatMessage);
      expect(AuthValidators.email('{}user@example.com'), wrongFormatMessage);
      expect(AuthValidators.email('user@example.a'), wrongFormatMessage);
      expect(AuthValidators.email('user@example.{}'), wrongFormatMessage);
    });

    test('returns null when value is valid', () {
      expect(AuthValidators.email('user@example.com'), isNull);
      expect(AuthValidators.email('name+alias@example.com'), isNull);
    });
  });

  group('AuthValidators.password', () {
    const requiredPasswordMessage = 'Введите пароль';
    const minLengthMessage = 'Пароль должен содержать минимум 8 символов';
    const maxLengthMessage = 'Пароль должен быть не длиннее 64 символов';
    const allowedCharsMessage = 'Пароль должен содержать только латинские буквы и цифры';
    const groupMissingMessage = 'Пароль должен содержать буквы и цифры';

    test('returns required error when value is empty', () {
      expect(AuthValidators.password(null), requiredPasswordMessage);
      expect(AuthValidators.password(''), requiredPasswordMessage);
    });

    test('returns min length error when value is too short', () {
      expect(
        AuthValidators.password('Abc123'),
        minLengthMessage,
      );
    });

    test('returns max length error when value is too long', () {
      final tooLongPassword = 'A' * 65;
      expect(
        AuthValidators.password(tooLongPassword),
        maxLengthMessage,
      );
    });

    test('returns allowed chars error when password contains symbols', () {
      expect(
        AuthValidators.password('Abc12345!'),
        allowedCharsMessage,
      );
    });

    test('returns letters and digits error when missing one group', () {
      expect(AuthValidators.password('abcdefgh'), groupMissingMessage);
      expect(AuthValidators.password('12345678'), groupMissingMessage);
    });

    test('returns null when password is valid', () {
      expect(AuthValidators.password('abc12345'), isNull);
      expect(AuthValidators.password('ABC12345'), isNull);
    });
  });

  group('AuthValidators.otpCode', () {
    const requiredCodeMessage = 'Введите код';
    const invalidCodeMessage = 'Код должен состоять из 6 цифр';

    test('returns required error when value is empty', () {
      expect(AuthValidators.otpCode(null), requiredCodeMessage);
      expect(AuthValidators.otpCode(''), requiredCodeMessage);
      expect(AuthValidators.otpCode('   '), requiredCodeMessage);
    });

    test('returns invalid error when value is non-digit or wrong length', () {
      expect(AuthValidators.otpCode('abc123'), invalidCodeMessage);
      expect(AuthValidators.otpCode('12345'), invalidCodeMessage);
      expect(AuthValidators.otpCode('1234567'), invalidCodeMessage);
    });

    test('returns null when value is valid', () {
      expect(AuthValidators.otpCode('123456'), isNull);
      expect(AuthValidators.otpCode(' 123456 '), isNull);
    });
  });
}
