import 'package:fit_app/application/interfaces/repo/category.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/id.dart';

class DeleteCategory {
  const DeleteCategory({
    required this.categoryRepository,
    required this.exerciseRepository,
  });

  final CategoryRepository categoryRepository;
  final ExerciseRepository exerciseRepository;

  void execute(Id categoryId) {
    final existing = categoryRepository.getById(categoryId);
    if (existing == null) {
      throw ArgumentError('Category with id $categoryId not found');
    }
    categoryRepository.delete(categoryId);
    final exercises = exerciseRepository.getAll();
    for (final exercise in exercises) {
      if (!exercise.categoriesId.contains(categoryId)) continue;
      final updatedCategories =
          exercise.categoriesId.where((id) => id != categoryId).toList();
      final updated = Exercise(
        id: exercise.id,
        name: exercise.name,
        photoId: exercise.photoId,
        technique: exercise.technique,
        notes: exercise.notes,
        usesWeights: exercise.usesWeights,
        links: exercise.links,
        categoriesId: updatedCategories,
      );
      exerciseRepository.update(updated);
    }
  }
}
