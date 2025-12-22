import 'package:fit_app/application/dto/exercise.dart';
import 'package:fit_app/application/interfaces/file_manager.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/id.dart';

class UpdateExercise {
  final ExerciseRepository exerciseRepository;
  final FileManager? fileManager;

  UpdateExercise({
    required this.exerciseRepository,
    this.fileManager,
  });

  void execute(UpdateExerciseDTO data) {
    final existing = exerciseRepository.getById(data.exerciseId);
    if (existing == null) {
      throw ArgumentError('Exercise with id ${data.exerciseId} not found');
    }

    final bytes = data.photoBytes;
    Id? photoId = existing.photoId;
    final targetPhotoId = '${existing.id}_photo';

    if (bytes != null) {
      if (photoId == null) {
        fileManager?.store(
          bytes: bytes,
          fileName: targetPhotoId,
        );
      } else {
        fileManager?.update(
          fileId: photoId,
          bytes: bytes,
        );
      }
      photoId = targetPhotoId;
    } else if (data.removePhoto) {
      fileManager?.delete(targetPhotoId);
      photoId = null;
    }

    final updated = Exercise(
      id: existing.id,
      name: data.name,
      photoId: photoId,
      technique: data.technique,
      usesWeights: existing.usesWeights,
      notes: data.notes,
      links: data.links,
      categoriesId: data.categoryIds,
    );

    exerciseRepository.update(updated);
  }
}
