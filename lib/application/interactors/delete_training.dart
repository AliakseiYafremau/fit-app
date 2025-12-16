import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';

class DeleteTraining {
  final TrainingRepository trainingRepository;
  final PlannedSetRepository plannedSetRepository;

  DeleteTraining({
    required this.trainingRepository,
    required this.plannedSetRepository,
  });

  void execute(Id trainingId) {
    final training = trainingRepository.getById(trainingId);
    if (training == null) {
      throw ArgumentError('Training with id $trainingId not found');
    }

    for (var plannedSet in training.plannedSets) {
      plannedSetRepository.delete(plannedSet.id);
    }

    trainingRepository.delete(trainingId);
  }
}