/// Frequency periods supported by the backend.
enum FrequencyPeriod {
  /// One week period.
  week('week'),

  /// One month period.
  month('month'),

  /// Three months period.
  threeMonths('3months'),

  /// Six months period.
  sixMonths('6months'),

  /// One year period.
  year('year')
  ;

  /// Request value expected by the backend.
  final String requestValue;

  const FrequencyPeriod(this.requestValue);

  /// Maps backend value to [FrequencyPeriod].
  static FrequencyPeriod fromRequestValue(String rawValue) {
    return FrequencyPeriod.values.firstWhere(
      (item) => item.requestValue == rawValue,
      orElse: () => FrequencyPeriod.month,
    );
  }
}
