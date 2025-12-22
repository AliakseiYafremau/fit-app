import 'package:fit_app/domain/entities/category.dart';
import 'package:fit_app/domain/entities/id.dart';

abstract class CategoryRepository {
  void add(Category category);
  Category? getById(Id categoryId);
  List<Category> getAll();
  void update(Category category);
  void delete(Id categoryId);
}
