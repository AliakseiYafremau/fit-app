import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/adapters/repo/isar/mappers.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:isar/isar.dart';

class IsarTrainingRepository implements TrainingRepository {
  IsarTrainingRepository(this._isar);

  final Isar _isar;

  IsarCollection<TrainingModel> get _collection =>
      _isar.collection<TrainingModel>();

  @override
  void add(Training training) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(training.id).findFirstSync();
      final model = mapTrainingToModel(
        training,
        existing: existing,
      );
      model.isarId = existing?.isarId;
      _collection.putSync(model);
    });
  }
}
