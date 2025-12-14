import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/workout_set.dart';


/// Training entity.
///
/// Contains the list of suggested exercises.
class Training {
  final Id id;
  final String name;
  final List<PlannedSet> plannedSets;

  Training({
    required this.id,
    required this.name,
    List<PlannedSet>? plannedSets,
  }) : plannedSets = plannedSets ?? [] {
    if (name.trim().isEmpty) {
      throw ArgumentError('Training name cannot be empty');
    }
  }
} 
