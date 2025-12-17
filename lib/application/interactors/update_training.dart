import 'package:fit_app/application/dto/training.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/entities/workout_set.dart';

class UpdateTraining {
  final TrainingRepository trainingRepository;
  final ExerciseRepository exerciseRepository;
  final PlannedSetRepository plannedSetRepository;
  final IdGenerator idGenerator;

  UpdateTraining({
    required this.trainingRepository,
    required this.exerciseRepository,
    required this.plannedSetRepository,
    required this.idGenerator,
  });

  void execute(UpdateTrainingDTO data) {
    final training = trainingRepository.getById(data.trainingId);
    if (training == null) {
      throw ArgumentError('Training with id ${data.trainingId} not found');
    }

    final remainingSets = training.plannedSets
        .where((set) => !data.removePlannedSetIds.contains(set.id))
        .toList();

    for (final removedId in data.removePlannedSetIds) {
      plannedSetRepository.delete(removedId);
    }

    final addedSets = data.setsToAdd.map((setDto) {
      final exercise = exerciseRepository.getById(setDto.exerciseId);
      if (exercise == null) {
        throw ArgumentError('Exercise with id ${setDto.exerciseId} not found');
      }
      final plannedSet = PlannedSet(
        id: idGenerator.generate(),
        exercise: exercise,
        targetRepetitions: setDto.reps,
      );
      plannedSetRepository.add(plannedSet);
      return plannedSet;
    }).toList();

    final updatedTraining = Training(
      id: training.id,
      name: data.name,
      plannedSets: [
        ...remainingSets,
        ...addedSets,
      ],
    );

    trainingRepository.update(updatedTraining);
  }
}
