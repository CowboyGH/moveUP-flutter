import 'package:dio/dio.dart';
import 'package:moveup_flutter/core/network/api_paths.dart';
import 'package:moveup_flutter/features/subscriptions/data/dto/subscription_catalog_item_dto.dart';
import 'package:moveup_flutter/features/subscriptions/data/dto/subscriptions_response_dto.dart';
import 'package:moveup_flutter/features/subscriptions/domain/entities/subscription_catalog_item.dart';
import 'package:moveup_flutter/features/subscriptions/domain/entities/subscription_payment_payload.dart';

/// Test fixture for subscriptions response DTO.
SubscriptionsResponseDto createSubscriptionsResponseDto({bool includeInactive = false}) {
  final data = [
    SubscriptionCatalogItemDto(
      id: 1,
      name: '1 месяц',
      description: 'Полный доступ к тренировкам на один месяц',
      image: '/subscriptions/subscription.png',
      price: '550.00',
      durationDays: 30,
      isActive: true,
    ),
    SubscriptionCatalogItemDto(
      id: 2,
      name: '3 месяца',
      description: 'Полный доступ к тренировкам на три месяца',
      image: 'http://localhost:8000/storage/subscriptions/subscription-3.png',
      price: '1400.00',
      durationDays: 90,
      isActive: true,
    ),
  ];

  if (includeInactive) {
    data.add(
      SubscriptionCatalogItemDto(
        id: 3,
        name: '6 месяцев',
        description: 'Архивный тариф',
        image: '/subscriptions/subscription-archived.png',
        price: '2500.00',
        durationDays: 180,
        isActive: false,
      ),
    );
  }

  return SubscriptionsResponseDto(data: data);
}

/// Test fixture for subscriptions domain entities.
List<SubscriptionCatalogItem> createSubscriptionCatalogItems() => [
  SubscriptionCatalogItem(
    id: 1,
    name: '1 месяц',
    description: 'Полный доступ к тренировкам на один месяц',
    price: '550.00',
    imageUrl: Uri.parse(ApiPaths.baseUrl).resolve('storage/subscriptions/subscription.png').toString(),
  ),
  const SubscriptionCatalogItem(
    id: 2,
    name: '3 месяца',
    description: 'Полный доступ к тренировкам на три месяца',
    price: '1400.00',
    imageUrl: 'http://localhost:8000/storage/subscriptions/subscription-3.png',
  ),
];

/// Creates a bad-response [DioException] for subscriptions API tests.
DioException createSubscriptionsDioBadResponseException({
  required String path,
  required int statusCode,
  String code = 'server_error',
}) {
  final requestOptions = RequestOptions(path: path);
  return DioException(
    requestOptions: requestOptions,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: {
        'success': false,
        'message': 'error',
        'code': code,
      },
    ),
    type: DioExceptionType.badResponse,
  );
}

/// Test fixture for a subscription payment payload.
const testSubscriptionPaymentPayload = SubscriptionPaymentPayload(
  subscriptionId: 2,
  saveCard: true,
  cardNumber: '4111111111111111',
  cardHolder: 'IVAN IVANOV',
  expiryMonth: '12',
  expiryYear: '2028',
  cvv: '123',
);
