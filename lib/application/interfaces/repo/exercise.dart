import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/id.dart';
abstract class ExerciseRepository {
  Exercise? getById(Id id);
  List<Exercise> getAll();
  void add(Exercise exercise);
}
