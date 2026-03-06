import 'package:json_annotation/json_annotation.dart';

part 'register_request_dto.g.dart';

/// DTO for the register request.
@JsonSerializable(createFactory: false)
class RegisterRequestDto {
  /// User name.
  final String name;

  /// User email.
  final String email;

  /// User password.
  final String password;

  /// Creates an instance of [RegisterRequestDto].
  RegisterRequestDto({
    required this.name,
    required this.email,
    required this.password,
  });

  /// Converts [RegisterRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}
