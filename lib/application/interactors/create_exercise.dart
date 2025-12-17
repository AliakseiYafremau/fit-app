import 'package:fit_app/application/dto/exercise.dart';
import 'package:fit_app/application/interfaces/file_manager.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';

class CreateExercise {
  final ExerciseRepository exerciseRepository;
  final IdGenerator idGenerator;
  final FileManager? fileManager;

  CreateExercise({
    required this.exerciseRepository,
    required this.idGenerator,
    this.fileManager,
  });

  void execute(NewExerciseDTO data) {
    final exerciseId = idGenerator.generate();
    final bytes = data.photoBytes;
    String? photoId;
    if (bytes != null) {
      final targetId = '${exerciseId}_photo';
      fileManager?.store(
        bytes: bytes,
        fileName: targetId,
      );
      photoId = targetId;
    }

    final exercise = Exercise(
      id: exerciseId,
      name: data.name,
      photoId: photoId,
      technique: data.technique,
      usesWeights: data.usesWeights,
      notes: data.notes,
      links: data.links,
    );
    exerciseRepository.add(exercise);
  }
}
