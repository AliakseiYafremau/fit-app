import 'dart:io';

import 'package:fit_app/adapters/file/local_file_manager.dart';
import 'package:fit_app/adapters/repo/isar/isar_exercise_repository.dart';
import 'package:fit_app/adapters/repo/isar/isar_planned_set_repository.dart';
import 'package:fit_app/adapters/repo/isar/isar_session_repository.dart';
import 'package:fit_app/adapters/repo/isar/isar_workout_set_repository.dart';
import 'package:fit_app/adapters/repo/isar/isar_training_repository.dart';
import 'package:fit_app/adapters/uuid_generator.dart';
import 'package:fit_app/application/interactors/cancel_session.dart';
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
import 'package:fit_app/application/interfaces/file_manager.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Builds the registry of all application-level dependencies.
List<SingleChildWidget> buildAppProviders(Isar isar, Directory appDirectory) => [
      Provider<IdGenerator>(
        create: (_) => UuidGenerator(),
      ),
      Provider<FileManager>(
        create: (_) => LocalFileManager(rootDirectory: appDirectory),
      ),
      ProxyProvider<FileManager, ExerciseRepository>(
        update: (_, fileManager, previous) =>
            IsarExerciseRepository(isar, fileManager: fileManager),
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
      ProxyProvider3<ExerciseRepository, IdGenerator, FileManager, CreateExercise>(
        update: (_, exerciseRepository, idGenerator, fileManager, previous) =>
            CreateExercise(
          exerciseRepository: exerciseRepository,
          idGenerator: idGenerator,
          fileManager: fileManager,
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
      ProxyProvider2<ExerciseRepository, FileManager, UpdateExercise>(
        update: (_, exerciseRepository, fileManager, previous) => UpdateExercise(
          exerciseRepository: exerciseRepository,
          fileManager: fileManager,
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
      ProxyProvider4<TrainingRepository, PlannedSetRepository,
          SessionRepository, WorkoutSetRepository, DeleteTraining>(
        update: (_, trainingRepository, plannedSetRepository,
                sessionRepository, workoutSetRepository, previous) =>
            DeleteTraining(
          trainingRepository: trainingRepository,
          plannedSetRepository: plannedSetRepository,
          sessionRepository: sessionRepository,
          workoutSetRepository: workoutSetRepository,
        ),
      ),
      ProxyProvider6<ExerciseRepository, PlannedSetRepository,
          WorkoutSetRepository, TrainingRepository, SessionRepository, FileManager,
          DeleteExercise>(
        update: (_, exerciseRepository, plannedSetRepository,
                workoutSetRepository, trainingRepository, sessionRepository,
                fileManager, previous) =>
            DeleteExercise(
          exerciseRepository: exerciseRepository,
          plannedSetRepository: plannedSetRepository,
          workoutSetRepository: workoutSetRepository,
          trainingRepository: trainingRepository,
          sessionRepository: sessionRepository,
          fileManager: fileManager,
        ),
      ),
      ProxyProvider<SessionRepository, CancelSession>(
        update: (_, sessionRepository, previous) => CancelSession(
          sessionRepository: sessionRepository,
        ),
      ),
    ];
