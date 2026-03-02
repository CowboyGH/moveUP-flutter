import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

/// DTO for the login request.
@JsonSerializable()
class LoginRequestDto {
  /// User email.
  final String email;

  /// User password.
  final String password;

  /// Creates an instance of [LoginRequestDto].
  LoginRequestDto({required this.email, required this.password});

  /// Creates a [LoginRequestDto] from JSON.
  factory LoginRequestDto.fromJson(Map<String, dynamic> json) => _$LoginRequestDtoFromJson(json);

  /// Converts [LoginRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}
