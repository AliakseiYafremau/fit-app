import 'package:fit_app/domain/entities/id.dart';


class NewPlannedSetDTO {
  final int reps;
  final Id exerciseId;

  NewPlannedSetDTO({
    required this.reps,
    required this.exerciseId,
  });
}