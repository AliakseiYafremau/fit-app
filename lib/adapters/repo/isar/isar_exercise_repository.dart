import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/adapters/repo/isar/mappers.dart';
import 'package:fit_app/application/interfaces/file_manager.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/id.dart' as domain_id;
import 'package:isar/isar.dart';

class IsarExerciseRepository implements ExerciseRepository {
  IsarExerciseRepository(this._isar, {required FileManager fileManager})
      : _fileManager = fileManager;

  final Isar _isar;
  final FileManager _fileManager;

  IsarCollection<ExerciseModel> get _collection =>
      _isar.collection<ExerciseModel>();

  @override
  Exercise? getById(domain_id.Id id) {
    final model = _collection.where().entityIdEqualTo(id).findFirstSync();
    if (model == null) {
      return null;
    }
    return _attachPhoto(mapExerciseFromModel(model));
  }

  @override
  List<Exercise> getAll() {
    final models = _collection.where().findAllSync();
    return models
        .map(mapExerciseFromModel)
        .map(_attachPhoto)
        .toList(growable: false);
  }

  @override
  void add(Exercise exercise) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(exercise.id).findFirstSync();
      final model =
          mapExerciseToModel(exercise, existing: existing);
      model.isarId = existing?.isarId;
      _collection.putSync(model);
    });
  }

  @override
  void update(Exercise exercise) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(exercise.id).findFirstSync();
      if (existing == null) {
        throw StateError('Exercise with id ${exercise.id} not found');
      }
      final model =
          mapExerciseToModel(exercise, existing: existing);
      model.isarId = existing.isarId;
      _collection.putSync(model);
    });
  }

  @override
  void delete(domain_id.Id exerciseId) {
    _isar.writeTxnSync(() {
      final model =
          _collection.where().entityIdEqualTo(exerciseId).findFirstSync();
      if (model?.isarId != null) {
        _collection.deleteSync(model!.isarId!);
      }
    });
  }
  Exercise _attachPhoto(Exercise exercise) {
    final candidatePhotoId = exercise.photoId ?? '${exercise.id}_photo';
    final hasPhoto = _fileManager.exists(candidatePhotoId);
    if (hasPhoto == (exercise.photoId != null)) {
      if (!hasPhoto || exercise.photoId == candidatePhotoId) {
        return exercise;
      }
    }
    return Exercise(
      id: exercise.id,
      name: exercise.name,
      photoId: hasPhoto ? candidatePhotoId : null,
      technique: exercise.technique,
      notes: exercise.notes,
      usesWeights: exercise.usesWeights,
      links: exercise.links,
      categoriesId: exercise.categoriesId,
    );
  }
}
