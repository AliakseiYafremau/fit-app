import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/logs.dart';

class InMemoryExerciseRepository implements ExerciseRepository {
  InMemoryExerciseRepository._internal();
  static final InMemoryExerciseRepository _instance =
      InMemoryExerciseRepository._internal();

  factory InMemoryExerciseRepository() => _instance;

  final List<Exercise> _exercises = [
    Exercise(id: 'ex-1', name: 'Bench Press', usesWeights: true),
    Exercise(id: 'ex-2', name: 'Deadlift', usesWeights: true),
    Exercise(id: 'ex-3', name: 'Squat', usesWeights: true),
    Exercise(id: 'ex-4', name: 'Pull-ups', usesWeights: false),
  ];

  @override
  Exercise? getById(Id id) {
    try {
      return _exercises.firstWhere((exercise) => exercise.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Exercise> getAll() {
    return List.unmodifiable(_exercises);
  }

  @override
  void add(Exercise exercise) {
    _exercises.add(exercise);
    logger.i('Exercise added: ${exercise.name} (${exercise.id})');
  }
}
