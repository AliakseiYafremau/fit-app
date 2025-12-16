import 'package:fit_app/domain/entities/session.dart';

abstract class SessionRepository {
  void add(Session session);
}
