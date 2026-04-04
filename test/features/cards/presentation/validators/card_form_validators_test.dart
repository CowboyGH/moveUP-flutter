import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/features/cards/presentation/validators/card_form_validators.dart';

void main() {
  group('CardFormValidators.cardNumber', () {
    const requiredMessage = 'Введите номер карты';
    const invalidMessage = 'Номер карты должен состоять из 16 цифр';

    test('returns required error when value is empty', () {
      expect(CardFormValidators.cardNumber(null), requiredMessage);
      expect(CardFormValidators.cardNumber(''), requiredMessage);
      expect(CardFormValidators.cardNumber('   '), requiredMessage);
    });

    test('returns invalid error when card number length is not 16 digits', () {
      expect(CardFormValidators.cardNumber('1234'), invalidMessage);
      expect(CardFormValidators.cardNumber('1234 5678 9012 345'), invalidMessage);
      expect(CardFormValidators.cardNumber('1234 5678 9012 34567'), invalidMessage);
    });

    test('returns null when card number contains exactly 16 digits', () {
      expect(CardFormValidators.cardNumber('1234 5678 9012 3456'), isNull);
    });
  });

  group('CardFormValidators.cardHolder', () {
    const requiredMessage = 'Введите имя держателя карты';
    const invalidMessage =
        'Имя держателя карты должно содержать только заглавные латинские буквы и пробелы';

    test('returns required error when value is empty', () {
      expect(CardFormValidators.cardHolder(null), requiredMessage);
      expect(CardFormValidators.cardHolder(''), requiredMessage);
      expect(CardFormValidators.cardHolder('   '), requiredMessage);
    });

    test('returns invalid error when value contains non-latin or non-letter symbols', () {
      expect(CardFormValidators.cardHolder('ИВАН ИВАНОВ'), invalidMessage);
      expect(CardFormValidators.cardHolder('IVAN1 IVANOV'), invalidMessage);
      expect(CardFormValidators.cardHolder('IVAN- IVANOV'), invalidMessage);
    });

    test('returns null when value is valid', () {
      expect(CardFormValidators.cardHolder('IVAN IVANOV'), isNull);
      expect(CardFormValidators.cardHolder('Ivan Ivanov'), isNull);
      expect(CardFormValidators.cardHolder('  IVAN IVANOV  '), isNull);
      expect(CardFormValidators.cardHolder('IVAN'), isNull);
    });
  });

  group('CardFormValidators.expiryMonth', () {
    const invalidMessage = 'Месяц';
    final fixedNow = DateTime(2026, 4, 2);

    test('returns invalid error when value is empty', () {
      expect(CardFormValidators.expiryMonth(null), invalidMessage);
      expect(CardFormValidators.expiryMonth(''), invalidMessage);
      expect(CardFormValidators.expiryMonth('   '), invalidMessage);
    });

    test('returns invalid error when month is out of range', () {
      expect(CardFormValidators.expiryMonth('0'), invalidMessage);
      expect(CardFormValidators.expiryMonth('13'), invalidMessage);
      expect(CardFormValidators.expiryMonth('99'), invalidMessage);
    });

    test('returns null when month is in range', () {
      expect(CardFormValidators.expiryMonth('1'), isNull);
      expect(CardFormValidators.expiryMonth('12'), isNull);
    });

    test('returns hidden error when month is earlier than current month in current year', () {
      expect(
        CardFormValidators.expiryMonth(
          '3',
          yearValue: '2026',
          now: fixedNow,
        ),
        isNotNull,
      );
    });

    test('returns null when month is current or future in current year', () {
      expect(
        CardFormValidators.expiryMonth(
          '4',
          yearValue: '2026',
          now: fixedNow,
        ),
        isNull,
      );
      expect(
        CardFormValidators.expiryMonth(
          '5',
          yearValue: '2026',
          now: fixedNow,
        ),
        isNull,
      );
    });

    test('returns hidden error when year is unrealistically far in the future', () {
      expect(
        CardFormValidators.expiryMonth(
          '5',
          yearValue: '9999',
          now: fixedNow,
        ),
        isNotNull,
      );
    });
  });

  group('CardFormValidators.expiryYear', () {
    const invalidMessage = 'Год';
    final fixedNow = DateTime(2026, 4, 2);

    test('returns invalid error when value is empty', () {
      expect(CardFormValidators.expiryYear(null), invalidMessage);
      expect(CardFormValidators.expiryYear(''), invalidMessage);
      expect(CardFormValidators.expiryYear('   '), invalidMessage);
    });

    test('returns invalid error when year length is not 4', () {
      expect(CardFormValidators.expiryYear('24'), invalidMessage);
      expect(CardFormValidators.expiryYear('202'), invalidMessage);
      expect(CardFormValidators.expiryYear('20245'), invalidMessage);
    });

    test('returns null when year length is 4', () {
      expect(CardFormValidators.expiryYear('2026'), isNull);
      expect(CardFormValidators.expiryYear(' 2026 '), isNull);
    });

    test('returns hidden error when year is before current year', () {
      expect(
        CardFormValidators.expiryYear(
          '2025',
          now: fixedNow,
        ),
        isNotNull,
      );
    });

    test('returns hidden error when month is already in the past for current year', () {
      expect(
        CardFormValidators.expiryYear(
          '2026',
          monthValue: '3',
          now: fixedNow,
        ),
        isNotNull,
      );
    });

    test('returns null when current year is paired with current or future month', () {
      expect(
        CardFormValidators.expiryYear(
          '2026',
          monthValue: '4',
          now: fixedNow,
        ),
        isNull,
      );
      expect(
        CardFormValidators.expiryYear(
          '2026',
          monthValue: '12',
          now: fixedNow,
        ),
        isNull,
      );
    });

    test('returns hidden error when year is unrealistically far in the future', () {
      expect(
        CardFormValidators.expiryYear(
          '9999',
          now: fixedNow,
        ),
        isNotNull,
      );
    });
  });

  group('CardFormValidators.cvv', () {
    const invalidMessage = '***';

    test('returns invalid error when value is empty', () {
      expect(CardFormValidators.cvv(null), invalidMessage);
      expect(CardFormValidators.cvv(''), invalidMessage);
      expect(CardFormValidators.cvv('   '), invalidMessage);
    });

    test('returns invalid error when cvv length is not 3', () {
      expect(CardFormValidators.cvv('1'), invalidMessage);
      expect(CardFormValidators.cvv('12'), invalidMessage);
      expect(CardFormValidators.cvv('1234'), invalidMessage);
    });

    test('returns invalid error when cvv contains non-digit characters', () {
      expect(CardFormValidators.cvv('abc'), invalidMessage);
      expect(CardFormValidators.cvv('12a'), invalidMessage);
    });

    test('returns null when cvv length is 3', () {
      expect(CardFormValidators.cvv('123'), isNull);
      expect(CardFormValidators.cvv(' 123 '), isNull);
    });
  });
}
