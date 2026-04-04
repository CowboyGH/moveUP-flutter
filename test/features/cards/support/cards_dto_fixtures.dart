import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/cards/data/dto/saved_card_dto.dart';
import 'package:moveup_flutter/features/cards/data/dto/saved_cards_response_dto.dart';
import 'package:moveup_flutter/features/cards/domain/entities/save_card_payload.dart';
import 'package:moveup_flutter/features/cards/domain/entities/saved_card.dart';

/// Test fixture for cards response DTO.
SavedCardsResponseDto createSavedCardsResponseDto() => SavedCardsResponseDto(
  data: [
    SavedCardDto(
      id: 1,
      cardHolder: 'IVAN IVANOV',
      cardLastFour: '4585',
      expiryMonth: '01',
      expiryYear: '2054',
      isDefault: true,
    ),
    SavedCardDto(
      id: 2,
      cardHolder: 'IVAN IVANOV',
      cardLastFour: '7585',
      expiryMonth: '01',
      expiryYear: '2044',
      isDefault: false,
    ),
  ],
);

/// Test fixture for cards domain entities.
List<SavedCard> createSavedCards() => const [
  SavedCard(
    id: 1,
    holderName: 'IVAN IVANOV',
    lastFour: '4585',
    expiryMonth: '01',
    expiryYear: '2054',
    isDefault: true,
  ),
  SavedCard(
    id: 2,
    holderName: 'IVAN IVANOV',
    lastFour: '7585',
    expiryMonth: '01',
    expiryYear: '2044',
    isDefault: false,
  ),
];

/// Test fixture for saving a new card.
const testSaveCardPayload = SaveCardPayload(
  cardNumber: '4111111111111111',
  cardHolder: 'IVAN IVANOV',
  expiryMonth: '12',
  expiryYear: '2029',
);

/// Creates a bad-response [DioException] for cards API tests.
DioException createCardsDioBadResponseException({
  required String path,
  required int statusCode,
  String code = 'server_error',
  String message = 'error',
  Map<String, List<String>>? errors,
}) {
  final requestOptions = RequestOptions(path: path);
  return DioException(
    requestOptions: requestOptions,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: {
        'success': false,
        'message': message,
        'code': code,
        'errors': ?errors,
      },
    ),
    type: DioExceptionType.badResponse,
  );
}
