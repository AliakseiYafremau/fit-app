import 'package:isar/isar.dart';

part 'models.g.dart';

@collection
class ExerciseModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String name;
  String technique = '';
  String notes = '';
  late bool usesWeights;
  List<String> links = [];
}

@collection
class SessionModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String trainingId;
  List<String> workoutSetIds = [];
}

@collection
class TrainingModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String name;
  List<String> plannedSetIds = [];
}

@collection
class WorkoutSetModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String exerciseId;
  late int repetitions;
  double? weight;
}

@collection
class PlannedSetModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String exerciseId;
  late int targetRepetitions;
}
