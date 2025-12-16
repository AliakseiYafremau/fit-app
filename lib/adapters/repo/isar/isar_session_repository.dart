import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/adapters/repo/isar/mappers.dart';
import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/domain/entities/session.dart';
import 'package:isar/isar.dart';

class IsarSessionRepository implements SessionRepository {
  IsarSessionRepository(this._isar);

  final Isar _isar;

  IsarCollection<SessionModel> get _sessions =>
      _isar.collection<SessionModel>();

  IsarCollection<WorkoutSetModel> get _workoutSets =>
      _isar.collection<WorkoutSetModel>();

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
}
