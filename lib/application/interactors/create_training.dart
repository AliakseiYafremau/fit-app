import 'package:fit_app/application/dto/training.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/entities/workout_set.dart';

class CreateTraining {
  final TrainingRepository trainingRepository;
  final ExerciseRepository exerciseRepository;
  final PlannedSetRepository plannedSetRepository;
  final IdGenerator idGenerator;

  CreateTraining({
    required this.trainingRepository,
    required this.exerciseRepository,
    required this.plannedSetRepository,
    required this.idGenerator,
  });

  void execute(NewTrainingDTO data) {
    final trainingId = idGenerator.generate();

    final plannedSets = data.plannedSets.map((setDto) {
      final exercise = exerciseRepository.getById(setDto.exerciseId);
      if (exercise == null) {
        throw ArgumentError('Exercise with id ${setDto.exerciseId} not found');
      }

      return PlannedSet(
        id: idGenerator.generate(),
        exercise: exercise,
        targetRepetitions: setDto.reps,
      );
    }).toList();

    final training = Training(
      id: trainingId,
      name: data.name,
      plannedSets: plannedSets,
    );

    trainingRepository.add(training);
    for (var plannedSet in plannedSets) {
      plannedSetRepository.add(plannedSet);
    }
  }
}