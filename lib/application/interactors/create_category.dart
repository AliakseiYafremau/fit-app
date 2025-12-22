import 'package:fit_app/application/dto/category.dart';
import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/category.dart';
import 'package:fit_app/domain/entities/category.dart';

class CreateCategory {
  final CategoryRepository categoryRepository;
  final IdGenerator idGenerator;

  CreateCategory({
    required this.categoryRepository,
    required this.idGenerator,
  });

  void execute(NewCategoryDTO data) {
    final category = Category(
      id: idGenerator.generate(),
      name: data.name,
      color: data.color,
    );
    categoryRepository.add(category);
  }
}
