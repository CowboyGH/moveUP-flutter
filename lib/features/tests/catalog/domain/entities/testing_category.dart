import 'package:equatable/equatable.dart';

/// Category assigned to a testing catalog item.
final class TestingCategory extends Equatable {
  /// Category identifier.
  final int id;

  /// Category display name.
  final String name;

  /// Creates an instance of [TestingCategory].
  const TestingCategory({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
