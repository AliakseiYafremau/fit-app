import 'package:fit_app/domain/entities/id.dart';

/// Exercise entity.
///
/// Holds all the core information and metadata for an exercise.
class Exercise {
  final Id id;
  final String name;
  final String? technique;
  final String? notes;
  final bool usesWeights;
  final List<String> links;

  Exercise({
    required this.id,
    required this.name,
    this.technique,
    this.notes,
    required this.usesWeights,
    this.links = const [],
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Exercise name cannot be empty');
    }
  }
}
