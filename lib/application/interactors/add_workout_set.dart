import 'package:fit_app/application/dto/workout_set.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/workout_set.dart';

class AddWorkoutSet {
  AddWorkoutSet({
    required this.workoutSetRepository,
    required this.exerciseRepository,
    required this.idGenerator,
  });

  final WorkoutSetRepository workoutSetRepository;
  final ExerciseRepository exerciseRepository;
  final IdGenerator idGenerator;

  WorkoutSet execute(NewWorkoutSetDTO data) {
    final exercise = exerciseRepository.getById(data.exerciseId);
    if (exercise == null) {
      throw ArgumentError('Exercise with id ${data.exerciseId} not found');
    }
    final workoutSet = WorkoutSet(
      id: idGenerator.generate(),
      exercise: exercise,
      repetitions: data.repetitions,
      weight: data.weight,
    );
    workoutSetRepository.add(workoutSet);
    return workoutSet;
  }
}
