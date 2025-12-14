import 'package:fit_app/adapters/repo/in_memory_exercise_repository.dart';
import 'package:fit_app/adapters/repo/in_memory_planned_set_repository.dart';
import 'package:fit_app/adapters/repo/in_memory_training_repository.dart';
import 'package:fit_app/adapters/uuid_generator.dart';
import 'package:fit_app/application/interactors/create_exercise.dart';
import 'package:fit_app/application/interactors/create_training.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Registry of all application-level dependencies.
final List<SingleChildWidget> appProviders = [
  Provider<IdGenerator>(
    create: (_) => UuidGenerator(),
  ),
  Provider<ExerciseRepository>(
    create: (_) => InMemoryExerciseRepository(),
  ),
  Provider<TrainingRepository>(
    create: (_) => InMemoryTrainingRepository(),
  ),
  Provider<PlannedSetRepository>(
    create: (_) => InMemoryPlannedSetRepository(),
  ),
  ProxyProvider2<ExerciseRepository, IdGenerator, CreateExercise>(
    update: (_, exerciseRepository, idGenerator, __) => CreateExercise(
      exerciseRepository: exerciseRepository,
      idGenerator: idGenerator,
    ),
  ),
  ProxyProvider4<TrainingRepository, ExerciseRepository,
      PlannedSetRepository, IdGenerator, CreateTraining>(
    update: (_, trainingRepository, exerciseRepository,
            plannedSetRepository, idGenerator, __) =>
        CreateTraining(
      trainingRepository: trainingRepository,
      exerciseRepository: exerciseRepository,
      plannedSetRepository: plannedSetRepository,
      idGenerator: idGenerator,
    ),
  ),
];
