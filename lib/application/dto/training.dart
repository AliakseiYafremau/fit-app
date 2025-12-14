
import 'package:fit_app/application/dto/workout_set.dart';

class NewTrainingDTO {
  final String name;
  final List<NewPlannedSetDTO> plannedSets;

  NewTrainingDTO({
    required this.name,
    List<NewPlannedSetDTO>? plannedSets,
  }) : plannedSets = plannedSets ?? [];
}
