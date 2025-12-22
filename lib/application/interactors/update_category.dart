import 'package:fit_app/application/dto/category.dart';
import 'package:fit_app/application/interfaces/repo/category.dart';
import 'package:fit_app/domain/entities/category.dart';

class UpdateCategory {
  const UpdateCategory({
    required this.categoryRepository,
  });

  final CategoryRepository categoryRepository;

  void execute(UpdateCategoryDTO data) {
    final existing = categoryRepository.getById(data.categoryId);
    if (existing == null) {
      throw ArgumentError('Category with id ${data.categoryId} not found');
    }
    final updated = Category(
      id: existing.id,
      name: data.name,
      color: data.color,
    );
    categoryRepository.update(updated);
  }
}
