import 'package:fit_app/domain/entities/session.dart';
import 'package:fit_app/domain/entities/id.dart';

abstract class SessionRepository {
  void add(Session session);
  List<Session> getByTrainingId(Id trainingId);
  Session getByWorkoutId(Id workoutId);
  void delete(Id sessionId);
}
