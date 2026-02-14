/// A sealed abstraction representing either a [Success] or a [Failure] result.
sealed class Result<T, E extends Object> {
  /// Creates a new [Result] instance.
  const Result();

  /// Creates a successful result containing the given [data].
  const factory Result.success(T data) = Success<T, E>;

  /// Creates a failed result containing the given [error] and optional [stackTrace].
  const factory Result.failure(E error, [StackTrace? stackTrace]) = Failure<T, E>;

  /// Whether this result represents a [Success].
  bool get isSuccess => this is Success<T, E>;

  /// Whether this result represents a [Failure].
  bool get isFailure => this is Failure<T, E>;

  /// Returns the success value if this is [Success], otherwise `null`.
  T? get success => isSuccess ? (this as Success<T, E>).data : null;

  /// Returns the failure value if this is [Failure], otherwise `null`.
  E? get failure => isFailure ? (this as Failure<T, E>).error : null;
}

/// A successful result containing a value of type [T].
final class Success<T, E extends Object> extends Result<T, E> {
  /// The value returned in a successful result.
  final T data;

  /// Creates a new [Success] containing the provided [data].
  const Success(this.data);
}

/// A failed result containing an error of type [E] and optional stack trace.
final class Failure<T, E extends Object> extends Result<T, E> {
  /// The error value describing the failure.
  final E error;

  /// The associated stack trace for debugging, if available.
  final StackTrace? stackTrace;

  /// Creates a new [Failure] with the given [error] and optional [stackTrace].
  const Failure(this.error, [this.stackTrace]);
}
