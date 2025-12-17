import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/workout_set.dart';

abstract class PlannedSetRepository {
  void add(PlannedSet plannedSet);
  List<PlannedSet> getByExerciseId(Id exerciseId);
  void delete(Id plannedSetId);
}

abstract class WorkoutSetRepository {
  void add(WorkoutSet workoutSet);
  List<WorkoutSet> getByExerciseId(Id exerciseId);
  WorkoutSet? getById(Id workoutSetId);
  void update(WorkoutSet workoutSet);
  void delete(Id workoutSetId);
}
