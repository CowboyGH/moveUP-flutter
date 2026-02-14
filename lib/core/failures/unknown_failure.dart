import 'app_failure.dart';

/// Unknown application error.
final class UnknownFailure extends AppFailure {
  /// Creates an instance of [UnknownFailure].
  const UnknownFailure({super.parentException, super.stackTrace}) : super('');
}
