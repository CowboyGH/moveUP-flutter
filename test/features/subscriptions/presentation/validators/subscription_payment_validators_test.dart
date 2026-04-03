import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/features/subscriptions/presentation/validators/subscription_payment_validators.dart';

void main() {
  group('SubscriptionPaymentValidators.cardNumber', () {
    const requiredMessage = 'Введите номер карты';
    const invalidMessage = 'Номер карты должен состоять из 16 цифр';

    test('returns required error when value is empty', () {
      expect(SubscriptionPaymentValidators.cardNumber(null), requiredMessage);
      expect(SubscriptionPaymentValidators.cardNumber(''), requiredMessage);
      expect(SubscriptionPaymentValidators.cardNumber('   '), requiredMessage);
    });

    test('returns invalid error when card number length is not 16 digits', () {
      expect(SubscriptionPaymentValidators.cardNumber('1234'), invalidMessage);
      expect(SubscriptionPaymentValidators.cardNumber('1234 5678 9012 345'), invalidMessage);
      expect(
        SubscriptionPaymentValidators.cardNumber('1234 5678 9012 34567'),
        invalidMessage,
      );
    });

    test('returns null when card number contains exactly 16 digits', () {
      expect(
        SubscriptionPaymentValidators.cardNumber('1234 5678 9012 3456'),
        isNull,
      );
    });
  });

  group('SubscriptionPaymentValidators.cardHolder', () {
    const requiredMessage = 'Введите имя держателя карты';
    const invalidMessage =
        'Имя держателя карты должно содержать только заглавные латинские буквы и пробелы';

    test('returns required error when value is empty', () {
      expect(SubscriptionPaymentValidators.cardHolder(null), requiredMessage);
      expect(SubscriptionPaymentValidators.cardHolder(''), requiredMessage);
      expect(SubscriptionPaymentValidators.cardHolder('   '), requiredMessage);
    });

    test('returns invalid error when value contains non-uppercase latin symbols', () {
      expect(SubscriptionPaymentValidators.cardHolder('Ivan Ivanov'), invalidMessage);
      expect(SubscriptionPaymentValidators.cardHolder('ИВАН ИВАНОВ'), invalidMessage);
      expect(SubscriptionPaymentValidators.cardHolder('IVAN1 IVANOV'), invalidMessage);
      expect(SubscriptionPaymentValidators.cardHolder('IVAN- IVANOV'), invalidMessage);
    });

    test('returns null when value is valid', () {
      expect(SubscriptionPaymentValidators.cardHolder('IVAN IVANOV'), isNull);
      expect(SubscriptionPaymentValidators.cardHolder('  IVAN IVANOV  '), isNull);
      expect(SubscriptionPaymentValidators.cardHolder('IVAN'), isNull);
    });
  });

  group('SubscriptionPaymentValidators.expiryMonth', () {
    const invalidMessage = 'Месяц';
    final fixedNow = DateTime(2026, 4, 2);

    test('returns invalid error when value is empty', () {
      expect(SubscriptionPaymentValidators.expiryMonth(null), invalidMessage);
      expect(SubscriptionPaymentValidators.expiryMonth(''), invalidMessage);
      expect(SubscriptionPaymentValidators.expiryMonth('   '), invalidMessage);
    });

    test('returns invalid error when month is out of range', () {
      expect(SubscriptionPaymentValidators.expiryMonth('0'), invalidMessage);
      expect(SubscriptionPaymentValidators.expiryMonth('13'), invalidMessage);
      expect(SubscriptionPaymentValidators.expiryMonth('99'), invalidMessage);
    });

    test('returns null when month is in range', () {
      expect(SubscriptionPaymentValidators.expiryMonth('1'), isNull);
      expect(SubscriptionPaymentValidators.expiryMonth('12'), isNull);
    });

    test('returns expired error when month is earlier than current month in current year', () {
      expect(
        SubscriptionPaymentValidators.expiryMonth(
          '3',
          yearValue: '2026',
          now: fixedNow,
        ),
        isNotNull,
      );
    });

    test('returns null when month is current or future in current year', () {
      expect(
        SubscriptionPaymentValidators.expiryMonth(
          '4',
          yearValue: '2026',
          now: fixedNow,
        ),
        isNull,
      );
      expect(
        SubscriptionPaymentValidators.expiryMonth(
          '5',
          yearValue: '2026',
          now: fixedNow,
        ),
        isNull,
      );
    });

    test('returns invalid when year is unrealistically far in the future', () {
      expect(
        SubscriptionPaymentValidators.expiryMonth(
          '5',
          yearValue: '9999',
          now: fixedNow,
        ),
        isNotNull,
      );
    });
  });

  group('SubscriptionPaymentValidators.expiryYear', () {
    const invalidMessage = 'Год';
    final fixedNow = DateTime(2026, 4, 2);

    test('returns invalid error when value is empty', () {
      expect(SubscriptionPaymentValidators.expiryYear(null), invalidMessage);
      expect(SubscriptionPaymentValidators.expiryYear(''), invalidMessage);
      expect(SubscriptionPaymentValidators.expiryYear('   '), invalidMessage);
    });

    test('returns invalid error when year length is not 4', () {
      expect(SubscriptionPaymentValidators.expiryYear('24'), invalidMessage);
      expect(SubscriptionPaymentValidators.expiryYear('202'), invalidMessage);
      expect(SubscriptionPaymentValidators.expiryYear('20245'), invalidMessage);
    });

    test('returns null when year length is 4', () {
      expect(SubscriptionPaymentValidators.expiryYear('2026'), isNull);
      expect(SubscriptionPaymentValidators.expiryYear(' 2026 '), isNull);
    });

    test('returns expired error when year is before current year', () {
      expect(
        SubscriptionPaymentValidators.expiryYear(
          '2025',
          now: fixedNow,
        ),
        isNotNull,
      );
    });

    test('returns expired error when month is already in the past for current year', () {
      expect(
        SubscriptionPaymentValidators.expiryYear(
          '2026',
          monthValue: '3',
          now: fixedNow,
        ),
        isNotNull,
      );
    });

    test('returns null when current year is paired with current or future month', () {
      expect(
        SubscriptionPaymentValidators.expiryYear(
          '2026',
          monthValue: '4',
          now: fixedNow,
        ),
        isNull,
      );
      expect(
        SubscriptionPaymentValidators.expiryYear(
          '2026',
          monthValue: '12',
          now: fixedNow,
        ),
        isNull,
      );
    });

    test('returns invalid when year is unrealistically far in the future', () {
      expect(
        SubscriptionPaymentValidators.expiryYear(
          '9999',
          now: fixedNow,
        ),
        isNotNull,
      );
    });
  });

  group('SubscriptionPaymentValidators.cvv', () {
    const invalidMessage = '***';

    test('returns invalid error when value is empty', () {
      expect(SubscriptionPaymentValidators.cvv(null), invalidMessage);
      expect(SubscriptionPaymentValidators.cvv(''), invalidMessage);
      expect(SubscriptionPaymentValidators.cvv('   '), invalidMessage);
    });

    test('returns invalid error when cvv length is not 3', () {
      expect(SubscriptionPaymentValidators.cvv('1'), invalidMessage);
      expect(SubscriptionPaymentValidators.cvv('12'), invalidMessage);
      expect(SubscriptionPaymentValidators.cvv('1234'), invalidMessage);
    });

    test('returns invalid error when cvv contains non-digit characters', () {
      expect(SubscriptionPaymentValidators.cvv('abc'), invalidMessage);
      expect(SubscriptionPaymentValidators.cvv('12a'), invalidMessage);
    });

    test('returns null when cvv length is 3', () {
      expect(SubscriptionPaymentValidators.cvv('123'), isNull);
      expect(SubscriptionPaymentValidators.cvv(' 123 '), isNull);
    });
  });
}
