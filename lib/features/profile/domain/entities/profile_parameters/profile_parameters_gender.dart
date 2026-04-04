/// Supported gender values for the profile parameters section.
enum ProfileParametersGender {
  /// Male gender.
  male('male'),

  /// Female gender.
  female('female')
  ;

  /// Backend request value.
  final String requestValue;

  const ProfileParametersGender(this.requestValue);

  /// Maps backend value to [ProfileParametersGender].
  static ProfileParametersGender fromRawValue(String rawValue) {
    return ProfileParametersGender.values.firstWhere(
      (item) => item.requestValue == rawValue,
      orElse: () => ProfileParametersGender.male,
    );
  }
}
