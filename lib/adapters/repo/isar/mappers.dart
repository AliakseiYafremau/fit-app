import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/domain/entities/category.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/session.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/entities/workout_set.dart';

CategoryModel mapCategoryToModel(
  Category category, {
  CategoryModel? existing,
}) {
  final model = existing ?? CategoryModel();
  model.entityId = category.id;
  model.name = category.name;
  model.color = category.color;
  return model;
}

Category mapCategoryFromModel(CategoryModel model) {
  return Category(
    id: model.entityId,
    name: model.name,
    color: model.color,
  );
}

ExerciseModel mapExerciseToModel(
  Exercise exercise, {
  ExerciseModel? existing,
}) {
  final model = existing ?? ExerciseModel();
  model.entityId = exercise.id;
  model.name = exercise.name;
  model.technique = exercise.technique ?? '';
  model.notes = exercise.notes ?? '';
  model.usesWeights = exercise.usesWeights;
  model.links = List<String>.from(exercise.links);
  return model;
}

Exercise mapExerciseFromModel(ExerciseModel model) {
  return Exercise(
    id: model.entityId,
    name: model.name,
    technique: model.technique.isEmpty ? null : model.technique,
    notes: model.notes.isEmpty ? null : model.notes,
    usesWeights: model.usesWeights,
    links: List<String>.from(model.links),
  );
}

TrainingModel mapTrainingToModel(
  Training training, {
  TrainingModel? existing,
}) {
  final model = existing ?? TrainingModel();
  model.entityId = training.id;
  model.name = training.name;
  model.plannedSetIds =
      training.plannedSets.map((set) => set.id).toList(growable: false);
  return model;
}

PlannedSetModel mapPlannedSetToModel(
  PlannedSet plannedSet, {
  PlannedSetModel? existing,
}) {
  final model = existing ?? PlannedSetModel();
  model.entityId = plannedSet.id;
  model.exerciseId = plannedSet.exercise.id;
  model.targetRepetitions = plannedSet.targetRepetitions;
  return model;
}

WorkoutSetModel mapWorkoutSetToModel(
  WorkoutSet workoutSet, {
  WorkoutSetModel? existing,
}) {
  final model = existing ?? WorkoutSetModel();
  model.entityId = workoutSet.id;
  model.exerciseId = workoutSet.exercise.id;
  model.repetitions = workoutSet.repetitions;
  model.weight = workoutSet.weight;
  model.done = workoutSet.done;
  return model;
}

SessionModel mapSessionToModel(
  Session session,
  List<String> workoutSetIds, {
  SessionModel? existing,
}) {
  final model = existing ?? SessionModel();
  model.entityId = session.id;
  model.trainingId = session.training?.id ?? '';
  model.workoutSetIds = List<String>.from(workoutSetIds);
  model.active = session.active;
  model.startedAt = session.startedAt;
  model.finishedAt = session.finishedAt;
  return model;
}

Session mapSessionFromModel(
  SessionModel model,
  Training? training,
  List<WorkoutSet> workoutSets,
) {
  return Session(
    id: model.entityId,
    training: training,
    workoutSets: workoutSets,
    active: model.active,
    startedAt: model.startedAt,
    finishedAt: model.finishedAt,
  );
}

PlannedSet mapPlannedSetFromModel(
  PlannedSetModel model,
  Exercise exercise,
) {
  return PlannedSet(
    id: model.entityId,
    exercise: exercise,
    targetRepetitions: model.targetRepetitions,
  );
}

WorkoutSet mapWorkoutSetFromModel(
  WorkoutSetModel model,
  Exercise exercise,
) {
  return WorkoutSet(
    id: model.entityId,
    exercise: exercise,
    repetitions: model.repetitions,
    weight: model.weight,
    done: model.done,
  );
}
