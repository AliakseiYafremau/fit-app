import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/adapters/repo/isar/mappers.dart';
import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/domain/entities/id.dart' as domain_id;
import 'package:fit_app/domain/entities/session.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:isar/isar.dart';

class IsarSessionRepository implements SessionRepository {
  IsarSessionRepository(this._isar);

  final Isar _isar;

  IsarCollection<SessionModel> get _sessions =>
      _isar.collection<SessionModel>();

  IsarCollection<WorkoutSetModel> get _workoutSets =>
      _isar.collection<WorkoutSetModel>();
  IsarCollection<TrainingModel> get _trainings =>
      _isar.collection<TrainingModel>();
  IsarCollection<PlannedSetModel> get _plannedSets =>
      _isar.collection<PlannedSetModel>();
  IsarCollection<ExerciseModel> get _exercises =>
      _isar.collection<ExerciseModel>();

  @override
  void add(Session session) {
    _isar.writeTxnSync(() {
      final workoutSetIds = <String>[];

      for (final workoutSet in session.workoutSets) {
        final existingSet = _workoutSets
            .where()
            .entityIdEqualTo(workoutSet.id)
            .findFirstSync();

        final setModel = mapWorkoutSetToModel(
          workoutSet,
          existing: existingSet,
        );
        setModel.isarId = existingSet?.isarId;
        _workoutSets.putSync(setModel);
        workoutSetIds.add(setModel.entityId);
      }

      final existingSession =
          _sessions.where().entityIdEqualTo(session.id).findFirstSync();
      final sessionModel = mapSessionToModel(
        session,
        workoutSetIds,
        existing: existingSession,
      );
      sessionModel.isarId = existingSession?.isarId;
      _sessions.putSync(sessionModel);
    });
  }

  @override
  List<Session> getByTrainingId(domain_id.Id trainingId) {
    final models = _sessions
        .filter()
        .trainingIdEqualTo(trainingId)
        .findAllSync();
    return models
        .map(_mapSessionFromModel)
        .where((session) => session != null)
        .cast<Session>()
        .toList(growable: false);
  }

  @override
  Session getByWorkoutId(domain_id.Id workoutId) {
    final model = _sessions
        .filter()
        .workoutSetIdsElementEqualTo(workoutId)
        .findFirstSync();
    final session = _mapSessionFromModel(model);
    if (session == null) {
      throw StateError('Session with workout set $workoutId not found');
    }
    return session;
  }

  @override
  void delete(domain_id.Id sessionId) {
    _isar.writeTxnSync(() {
      final model =
          _sessions.where().entityIdEqualTo(sessionId).findFirstSync();
      if (model == null) {
        return;
      }
      for (final workoutSetId in model.workoutSetIds) {
        final workoutSetModel = _workoutSets
            .where()
            .entityIdEqualTo(workoutSetId)
            .findFirstSync();
        if (workoutSetModel?.isarId != null) {
          _workoutSets.deleteSync(workoutSetModel!.isarId!);
        }
      }
      if (model.isarId != null) {
        _sessions.deleteSync(model.isarId!);
      }
    });
  }

  Session? _mapSessionFromModel(SessionModel? model) {
    if (model == null) {
      return null;
    }
    final training = _mapTrainingById(model.trainingId);
    if (training == null) {
      return null;
    }
    final workoutSets = <WorkoutSet>[];
    for (final workoutSetId in model.workoutSetIds) {
      final set = _mapWorkoutSetById(workoutSetId);
      if (set != null) {
        workoutSets.add(set);
      }
    }
    return Session(
      id: model.entityId,
      training: training,
      workoutSets: workoutSets,
    );
  }

  Training? _mapTrainingById(String trainingId) {
    final model =
        _trainings.where().entityIdEqualTo(trainingId).findFirstSync();
    if (model == null) {
      return null;
    }
    final plannedSets = <PlannedSet>[];
    for (final plannedSetId in model.plannedSetIds) {
      final plannedSetModel = _plannedSets
          .where()
          .entityIdEqualTo(plannedSetId)
          .findFirstSync();
      if (plannedSetModel == null) {
        continue;
      }
      final exerciseModel = _exercises
          .where()
          .entityIdEqualTo(plannedSetModel.exerciseId)
          .findFirstSync();
      if (exerciseModel == null) {
        continue;
      }
      plannedSets.add(
        mapPlannedSetFromModel(
          plannedSetModel,
          mapExerciseFromModel(exerciseModel),
        ),
      );
    }
    return Training(
      id: model.entityId,
      name: model.name,
      plannedSets: plannedSets,
    );
  }

  WorkoutSet? _mapWorkoutSetById(String workoutSetId) {
    final model =
        _workoutSets.where().entityIdEqualTo(workoutSetId).findFirstSync();
    if (model == null) {
      return null;
    }
    final exerciseModel = _exercises
        .where()
        .entityIdEqualTo(model.exerciseId)
        .findFirstSync();
    if (exerciseModel == null) {
      return null;
    }
    return mapWorkoutSetFromModel(
      model,
      mapExerciseFromModel(exerciseModel),
    );
  }
}
