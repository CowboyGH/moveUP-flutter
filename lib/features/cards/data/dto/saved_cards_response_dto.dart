import 'package:json_annotation/json_annotation.dart';

import 'saved_card_dto.dart';

part 'saved_cards_response_dto.g.dart';

/// DTO for saved cards response envelope.
@JsonSerializable(createToJson: false)
class SavedCardsResponseDto {
  /// Cards payload.
  final List<SavedCardDto> data;

  /// Creates an instance of [SavedCardsResponseDto].
  SavedCardsResponseDto({required this.data});

  /// Creates a [SavedCardsResponseDto] from JSON.
  factory SavedCardsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SavedCardsResponseDtoFromJson(json);
}
