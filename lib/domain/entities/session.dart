import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';

/// Training session entity.
///
/// Stores the workout sets that compose the session run.
class Session {
  final Id id;
  final List<WorkoutSet> workoutSets;
  final bool active;
  final DateTime startedAt;
  final DateTime? finishedAt;

  Session({
    required this.id,
    List<WorkoutSet>? workoutSets,
    this.active = true,
    required this.startedAt,
    this.finishedAt,
  }) : workoutSets = workoutSets ?? [];
}
