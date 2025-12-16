import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/training.dart';
abstract class TrainingRepository {
  void add(Training training);
  Training? getById(Id trainingId);
  Training getByPlannedSetId(Id plannedSetId);
  List<Training> getAll();
  void delete(Id trainingId);
}
