/// The state of a button.
enum ButtonState {
  /// The button is enabled and can be interacted with.
  enabled,

  /// The button is in a loading state,
  /// typically showing a spinner or progress indicator.
  loading,

  /// The button is disabled and cannot be interacted with.
  disabled,
}
