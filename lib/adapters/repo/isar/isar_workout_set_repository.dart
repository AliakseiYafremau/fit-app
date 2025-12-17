import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/adapters/repo/isar/mappers.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart' as domain_id;
import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:isar/isar.dart';

class IsarWorkoutSetRepository implements WorkoutSetRepository {
  IsarWorkoutSetRepository(this._isar);

  final Isar _isar;

  IsarCollection<WorkoutSetModel> get _collection =>
      _isar.collection<WorkoutSetModel>();
  IsarCollection<ExerciseModel> get _exerciseCollection =>
      _isar.collection<ExerciseModel>();

  @override
  void add(WorkoutSet workoutSet) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(workoutSet.id).findFirstSync();
      final model = mapWorkoutSetToModel(
        workoutSet,
        existing: existing,
      );
      model.isarId = existing?.isarId;
      if (existing == null) {
        _collection.putByEntityIdSync(model);
      } else {
        _collection.putSync(model);
      }
    });
  }

  @override
  List<WorkoutSet> getByExerciseId(domain_id.Id exerciseId) {
    final exerciseModel = _exerciseCollection
        .where()
        .entityIdEqualTo(exerciseId)
        .findFirstSync();
    if (exerciseModel == null) {
      return const <WorkoutSet>[];
    }
    final exercise = mapExerciseFromModel(exerciseModel);
    final models = _collection
        .filter()
        .exerciseIdEqualTo(exerciseId)
        .findAllSync();
    return models
        .map((model) => mapWorkoutSetFromModel(model, exercise))
        .toList(growable: false);
  }

  @override
  WorkoutSet? getById(domain_id.Id workoutSetId) {
    final model =
        _collection.where().entityIdEqualTo(workoutSetId).findFirstSync();
    if (model == null) {
      return null;
    }
    return _mapWorkoutSetFromModel(model);
  }

  @override
  void update(WorkoutSet workoutSet) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(workoutSet.id).findFirstSync();
      if (existing == null) {
        throw StateError('WorkoutSet with id ${workoutSet.id} not found');
      }
      final model = mapWorkoutSetToModel(
        workoutSet,
        existing: existing,
      );
      model.isarId = existing.isarId;
      _collection.putSync(model);
    });
  }

  @override
  void delete(domain_id.Id workoutSetId) {
    _isar.writeTxnSync(() {
      final model =
          _collection.where().entityIdEqualTo(workoutSetId).findFirstSync();
      if (model?.isarId != null) {
        _collection.deleteSync(model!.isarId!);
      }
    });
  }

  WorkoutSet? _mapWorkoutSetFromModel(WorkoutSetModel model) {
    final exerciseModel = _exerciseCollection
        .where()
        .entityIdEqualTo(model.exerciseId)
        .findFirstSync();
    if (exerciseModel == null) {
      return null;
    }
    final exercise = mapExerciseFromModel(exerciseModel);
    return mapWorkoutSetFromModel(model, exercise);
  }
}
