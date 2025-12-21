import 'package:fit_app/application/interfaces/file_manager.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/session.dart';
import 'package:fit_app/domain/entities/training.dart';

class DeleteExercise {
  final ExerciseRepository exerciseRepository;
  final PlannedSetRepository plannedSetRepository;
  final WorkoutSetRepository workoutSetRepository;
  final TrainingRepository trainingRepository;
  final SessionRepository sessionRepository;
  final FileManager? fileManager;

  DeleteExercise({
    required this.exerciseRepository,
    required this.plannedSetRepository,
    required this.workoutSetRepository,
    required this.trainingRepository,
    required this.sessionRepository,
    this.fileManager,
  });

  void execute(Id exerciseId) {
    final exercise = exerciseRepository.getById(exerciseId);
    if (exercise == null) {
      throw ArgumentError('Exercise with id $exerciseId not found');
    }

    final plannedSets = plannedSetRepository.getByExerciseId(exerciseId);
    final workoutSets = workoutSetRepository.getByExerciseId(exerciseId);
    final plannedSetIds = plannedSets.map((set) => set.id).toSet();
    final workoutSetIds = workoutSets.map((set) => set.id).toSet();

    final trainingsById = <Id, Training>{};
    for (final set in plannedSets) {
      final training = trainingRepository.getByPlannedSetId(set.id);
      trainingsById[training.id] = training;
    }

    final sessionsById = <Id, Session>{};
    for (final training in trainingsById.values) {
      for (final session in sessionRepository.getByTrainingId(training.id)) {
        sessionsById[session.id] = session;
      }
    }
    for (final workoutSet in workoutSets) {
      final session = sessionRepository.getByWorkoutId(workoutSet.id);
      sessionsById[session.id] = session;
    }

    for (final training in trainingsById.values) {
      final updatedPlannedSets = training.plannedSets
          .where((set) => !plannedSetIds.contains(set.id))
          .toList(growable: false);
      if (updatedPlannedSets.length == training.plannedSets.length) {
        continue;
      }
      final updatedTraining = Training(
        id: training.id,
        name: training.name,
        plannedSets: updatedPlannedSets,
      );
      trainingRepository.update(updatedTraining);
      trainingsById[training.id] = updatedTraining;
    }

    for (final session in sessionsById.values) {
      final filteredWorkoutSets = session.workoutSets
          .where((set) => !workoutSetIds.contains(set.id))
          .toList(growable: false);
      if (filteredWorkoutSets.length == session.workoutSets.length) {
        continue;
      }
      final training = session.training;
      final sessionTraining =
          training == null ? null : (trainingsById[training.id] ?? training);
      final updatedSession = Session(
        id: session.id,
        training: sessionTraining,
        workoutSets: filteredWorkoutSets,
        active: session.active,
        startedAt: session.startedAt,
        finishedAt: session.finishedAt,
      );
      sessionRepository.add(updatedSession);
    }

    for (final plannedSet in plannedSets) {
      plannedSetRepository.delete(plannedSet.id);
    }
    for (final workoutSet in workoutSets) {
      workoutSetRepository.delete(workoutSet.id);
    }

    exerciseRepository.delete(exerciseId);
    final photoId = exercise.photoId ?? '${exerciseId}_photo';
    if (fileManager?.exists(photoId) == true) {
      fileManager?.delete(photoId);
    }
  }
}
