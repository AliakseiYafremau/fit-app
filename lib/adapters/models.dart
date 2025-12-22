import 'package:isar/isar.dart';

part 'models.g.dart';

@collection
class ExerciseModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String name;
  String? photoId;
  String technique = '';
  String notes = '';
  late bool usesWeights;
  List<String> links = [];
  List<String> categoryIds = [];
}

@collection
class CategoryModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String name;
  late String color;
}

@collection
class SessionModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String trainingId;
  List<String> workoutSetIds = [];
  bool active = true;
  DateTime startedAt = DateTime.now();
  DateTime? finishedAt;
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
  bool done = false;
}

@collection
class PlannedSetModel {
  Id? isarId;

  @Index(unique: true)
  late String entityId;

  late String exerciseId;
  late int targetRepetitions;
}
