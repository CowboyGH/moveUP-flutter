import 'package:equatable/equatable.dart';

/// Exercise inside a test attempt.
final class TestingExercise extends Equatable {
  /// Exercise identifier.
  final int id;

  /// Exercise description.
  final String description;

  /// Normalized exercise image URL.
  final String imageUrl;

  /// Exercise order number inside the testing.
  final int orderNumber;

  /// Creates an instance of [TestingExercise].
  const TestingExercise({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.orderNumber,
  });

  @override
  List<Object?> get props => [id, description, imageUrl, orderNumber];
}
