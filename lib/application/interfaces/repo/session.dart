import 'package:fit_app/domain/entities/session.dart';
import 'package:fit_app/domain/entities/id.dart';

abstract class SessionRepository {
  void add(Session session);
  Session? getById(Id sessionId);
  List<Session> getByTrainingId(Id trainingId);
  Session getByWorkoutId(Id workoutId);
  Session? getActive();
  List<Session> getCompleted();
  void update(Session session);
  void delete(Id sessionId);
}
