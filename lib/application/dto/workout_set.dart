import 'package:fit_app/domain/entities/id.dart';


class NewPlannedSetDTO {
  final int reps;
  final Id exerciseId;

  NewPlannedSetDTO({
    required this.reps,
    required this.exerciseId,
  });
}

class NewWorkoutSetDTO {
  final Id exerciseId;
  final int repetitions;
  final double? weight;

  NewWorkoutSetDTO({
    required this.exerciseId,
    required this.repetitions,
    this.weight,
  });
}
