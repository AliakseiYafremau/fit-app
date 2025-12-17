import 'package:fit_app/adapters/repo/isar/isar_exercise_repository.dart';
import 'package:fit_app/adapters/repo/isar/isar_planned_set_repository.dart';
import 'package:fit_app/adapters/repo/isar/isar_session_repository.dart';
import 'package:fit_app/adapters/repo/isar/isar_workout_set_repository.dart';
import 'package:fit_app/adapters/repo/isar/isar_training_repository.dart';
import 'package:fit_app/adapters/uuid_generator.dart';
import 'package:fit_app/application/interactors/complete_set.dart';
import 'package:fit_app/application/interactors/create_exercise.dart';
import 'package:fit_app/application/interactors/create_training.dart';
import 'package:fit_app/application/interactors/delete_exercise.dart';
import 'package:fit_app/application/interactors/delete_training.dart';
import 'package:fit_app/application/interactors/start_session.dart';
import 'package:fit_app/application/interactors/finish_session.dart';
import 'package:fit_app/application/interactors/update_exercise.dart';
import 'package:fit_app/application/interactors/update_training.dart';
import 'package:fit_app/application/interactors/undo_complete_set.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Builds the registry of all application-level dependencies.
List<SingleChildWidget> buildAppProviders(Isar isar) => [
      Provider<IdGenerator>(
        create: (_) => UuidGenerator(),
      ),
      Provider<ExerciseRepository>(
        create: (_) => IsarExerciseRepository(isar),
      ),
      Provider<TrainingRepository>(
        create: (_) => IsarTrainingRepository(isar),
      ),
      Provider<PlannedSetRepository>(
        create: (_) => IsarPlannedSetRepository(isar),
      ),
      Provider<WorkoutSetRepository>(
        create: (_) => IsarWorkoutSetRepository(isar),
      ),
      Provider<SessionRepository>(
        create: (_) => IsarSessionRepository(isar),
      ),
      ProxyProvider2<ExerciseRepository, IdGenerator, CreateExercise>(
        update: (_, exerciseRepository, idGenerator, previous) => CreateExercise(
          exerciseRepository: exerciseRepository,
          idGenerator: idGenerator,
        ),
      ),
      ProxyProvider4<TrainingRepository, ExerciseRepository,
          PlannedSetRepository, IdGenerator, CreateTraining>(
        update: (_, trainingRepository, exerciseRepository,
                plannedSetRepository, idGenerator, previous) =>
            CreateTraining(
          trainingRepository: trainingRepository,
          exerciseRepository: exerciseRepository,
          plannedSetRepository: plannedSetRepository,
          idGenerator: idGenerator,
        ),
      ),
      ProxyProvider<ExerciseRepository, UpdateExercise>(
        update: (_, exerciseRepository, previous) => UpdateExercise(
          exerciseRepository: exerciseRepository,
        ),
      ),
      ProxyProvider4<TrainingRepository, ExerciseRepository,
          PlannedSetRepository, IdGenerator, UpdateTraining>(
        update: (_, trainingRepository, exerciseRepository,
                plannedSetRepository, idGenerator, previous) =>
            UpdateTraining(
          trainingRepository: trainingRepository,
          exerciseRepository: exerciseRepository,
          plannedSetRepository: plannedSetRepository,
          idGenerator: idGenerator,
        ),
      ),
      ProxyProvider4<TrainingRepository, SessionRepository,
          WorkoutSetRepository, IdGenerator, StartSession>(
        update: (_, trainingRepository, sessionRepository,
                workoutSetRepository, idGenerator, previous) =>
            StartSession(
          trainingRepository: trainingRepository,
          sessionRepository: sessionRepository,
          workoutSetRepository: workoutSetRepository,
          idGenerator: idGenerator,
        ),
      ),
      ProxyProvider<SessionRepository, FinishSession>(
        update: (_, sessionRepository, previous) => FinishSession(
          sessionRepository: sessionRepository,
        ),
      ),
      ProxyProvider<WorkoutSetRepository, CompleteSet>(
        update: (_, workoutSetRepository, previous) => CompleteSet(
          workoutSetRepository: workoutSetRepository,
        ),
      ),
      ProxyProvider<WorkoutSetRepository, UndoCompleteSet>(
        update: (_, workoutSetRepository, previous) => UndoCompleteSet(
          workoutSetRepository: workoutSetRepository,
        ),
      ),
      ProxyProvider2<TrainingRepository, PlannedSetRepository, DeleteTraining>(
        update: (_, trainingRepository, plannedSetRepository, previous) =>
            DeleteTraining(
          trainingRepository: trainingRepository,
          plannedSetRepository: plannedSetRepository,
        ),
      ),
      ProxyProvider5<ExerciseRepository, PlannedSetRepository,
          WorkoutSetRepository, TrainingRepository, SessionRepository,
          DeleteExercise>(
        update: (_, exerciseRepository, plannedSetRepository,
                workoutSetRepository, trainingRepository, sessionRepository,
                previous) =>
            DeleteExercise(
          exerciseRepository: exerciseRepository,
          plannedSetRepository: plannedSetRepository,
          workoutSetRepository: workoutSetRepository,
          trainingRepository: trainingRepository,
          sessionRepository: sessionRepository,
        ),
      ),
    ];
