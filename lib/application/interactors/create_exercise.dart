import 'package:fit_app/application/dto/exercise.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';

class CreateExercise {
  final ExerciseRepository exerciseRepository;
  final IdGenerator idGenerator;

  CreateExercise({
    required this.exerciseRepository,
    required this.idGenerator,
  });

  void execute(NewExerciseDTO data) {
    final exerciseId = idGenerator.generate();

    final exercise = Exercise(
      id: exerciseId,
      name: data.name,
      technique: data.technique,
      usesWeights: data.usesWeights,
      notes: data.notes,
      links: data.links,
    );
    exerciseRepository.add(exercise);
  }
}