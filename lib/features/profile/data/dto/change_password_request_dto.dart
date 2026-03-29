import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_dto.g.dart';

/// DTO for changing the authenticated user password.
@JsonSerializable(createFactory: false)
class ChangePasswordRequestDto {
  /// Current password.
  @JsonKey(name: 'old_password')
  final String oldPassword;

  /// New password.
  @JsonKey(name: 'new_password')
  final String newPassword;

  /// New password confirmation.
  @JsonKey(name: 'new_password_confirmation')
  final String newPasswordConfirmation;

  /// Creates an instance of [ChangePasswordRequestDto].
  ChangePasswordRequestDto({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  /// Converts [ChangePasswordRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$ChangePasswordRequestDtoToJson(this);
}
