import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/adapters/repo/isar/mappers.dart';
import 'package:fit_app/application/interfaces/repo/category.dart';
import 'package:fit_app/domain/entities/category.dart';
import 'package:fit_app/domain/entities/id.dart' as domain_id;
import 'package:isar/isar.dart';

class IsarCategoryRepository implements CategoryRepository {
  IsarCategoryRepository(this._isar);

  final Isar _isar;

  IsarCollection<CategoryModel> get _collection =>
      _isar.collection<CategoryModel>();

  @override
  void add(Category category) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(category.id).findFirstSync();
      final model = mapCategoryToModel(
        category,
        existing: existing,
      );
      model.isarId = existing?.isarId;
      if (existing == null) {
        _collection.putByEntityIdSync(model);
      } else {
        _collection.putSync(model);
      }
    });
  }

  @override
  void delete(domain_id.Id categoryId) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(categoryId).findFirstSync();
      if (existing?.isarId != null) {
        _collection.deleteSync(existing!.isarId!);
      }
    });
  }

  @override
  List<Category> getAll() {
    return _collection
        .where()
        .findAllSync()
        .map(mapCategoryFromModel)
        .toList(growable: false);
  }

  @override
  Category? getById(domain_id.Id categoryId) {
    final model =
        _collection.where().entityIdEqualTo(categoryId).findFirstSync();
    if (model == null) {
      return null;
    }
    return mapCategoryFromModel(model);
  }

  @override
  void update(Category category) {
    _isar.writeTxnSync(() {
      final existing =
          _collection.where().entityIdEqualTo(category.id).findFirstSync();
      if (existing == null) {
        throw StateError('Category with id ${category.id} not found');
      }
      final model = mapCategoryToModel(
        category,
        existing: existing,
      );
      model.isarId = existing.isarId;
      _collection.putSync(model);
    });
  }
}
