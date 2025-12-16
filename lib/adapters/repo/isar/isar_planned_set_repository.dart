import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/adapters/repo/isar/mappers.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:isar/isar.dart';

class IsarPlannedSetRepository implements PlannedSetRepository {
  IsarPlannedSetRepository(this._isar);

  final Isar _isar;

  IsarCollection<PlannedSetModel> get _collection =>
      _isar.collection<PlannedSetModel>();

  @override
  void add(PlannedSet plannedSet) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(plannedSet.id).findFirstSync();
      final model = mapPlannedSetToModel(
        plannedSet,
        existing: existing,
      );
      model.isarId = existing?.isarId;
      _collection.putSync(model);
    });
  }
}
