import 'package:fit_app/application/dto/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';

class NewTrainingDTO {
  final String name;
  final List<NewPlannedSetDTO> plannedSets;

  NewTrainingDTO({
    required this.name,
    List<NewPlannedSetDTO>? plannedSets,
  }) : plannedSets = plannedSets ?? [];
}

class UpdateTrainingDTO {
  final Id trainingId;
  final String name;
  final List<NewPlannedSetDTO> setsToAdd;
  final List<Id> removePlannedSetIds;

  UpdateTrainingDTO({
    required this.trainingId,
    required this.name,
    List<NewPlannedSetDTO>? setsToAdd,
    List<Id>? removePlannedSetIds,
  })  : setsToAdd = setsToAdd ?? const [],
        removePlannedSetIds = removePlannedSetIds ?? const [];
}
