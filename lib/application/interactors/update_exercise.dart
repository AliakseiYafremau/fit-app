import 'package:fit_app/application/dto/exercise.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';

class UpdateExercise {
  final ExerciseRepository exerciseRepository;

  UpdateExercise({required this.exerciseRepository});

  void execute(UpdateExerciseDTO data) {
    final existing = exerciseRepository.getById(data.exerciseId);
    if (existing == null) {
      throw ArgumentError('Exercise with id ${data.exerciseId} not found');
    }

    final updated = Exercise(
      id: existing.id,
      name: data.name,
      technique: data.technique,
      usesWeights: existing.usesWeights,
      notes: data.notes,
      links: data.links,
    );

    exerciseRepository.update(updated);
  }
}
