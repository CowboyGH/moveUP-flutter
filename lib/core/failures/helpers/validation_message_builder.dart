/// Builds a user-facing validation message from backend field errors.
String buildValidationMessage(
  Map<String, List<String>> rawFieldErrors, {
  required String fallbackMessage,
}) {
  final normalizedMessages = rawFieldErrors.values
      .expand((fieldMessages) => fieldMessages)
      .map((message) => message.trim())
      .where((message) => message.isNotEmpty);

  final messages = normalizedMessages.toSet().toList(growable: false);

  if (messages.isEmpty) {
    return fallbackMessage;
  }

  return messages.join('\n');
}
