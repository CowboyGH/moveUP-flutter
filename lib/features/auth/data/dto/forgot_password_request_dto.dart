import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_dto.g.dart';

/// DTO for the forgot password request.
@JsonSerializable(createFactory: false)
class ForgotPasswordRequestDto {
  /// User email.
  final String email;

  /// Creates an instance of [ForgotPasswordRequestDto].
  ForgotPasswordRequestDto({required this.email});

  /// Converts [ForgotPasswordRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestDtoToJson(this);
}
