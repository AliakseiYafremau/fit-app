import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/adapters/repo/isar/mappers.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:isar/isar.dart';

class IsarTrainingRepository implements TrainingRepository {
  IsarTrainingRepository(this._isar);

  final Isar _isar;

  IsarCollection<TrainingModel> get _collection =>
      _isar.collection<TrainingModel>();
  IsarCollection<PlannedSetModel> get _plannedSetCollection =>
      _isar.collection<PlannedSetModel>();
  IsarCollection<ExerciseModel> get _exerciseCollection =>
      _isar.collection<ExerciseModel>();

  @override
  void add(Training training) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(training.id).findFirstSync();
      final model = mapTrainingToModel(
        training,
        existing: existing,
      );
      model.isarId = existing?.isarId;
      _collection.putSync(model);
    });
  }

  @override
  List<Training> getAll() {
    final models = _collection.where().findAllSync();
    return models.map(_mapTrainingFromModel).toList(growable: false);
  }

  Training _mapTrainingFromModel(TrainingModel model) {
    final plannedSets = <PlannedSet>[];

    for (final plannedSetId in model.plannedSetIds) {
      final plannedSetModel = _plannedSetCollection
          .where()
          .entityIdEqualTo(plannedSetId)
          .findFirstSync();
      if (plannedSetModel == null) {
        continue;
      }

      final exerciseModel = _exerciseCollection
          .where()
          .entityIdEqualTo(plannedSetModel.exerciseId)
          .findFirstSync();
      if (exerciseModel == null) {
        continue;
      }

      plannedSets.add(
        PlannedSet(
          id: plannedSetModel.entityId,
          exercise: mapExerciseFromModel(exerciseModel),
          targetRepetitions: plannedSetModel.targetRepetitions,
        ),
      );
    }

    return Training(
      id: model.entityId,
      name: model.name,
      plannedSets: plannedSets,
    );
  }
}
