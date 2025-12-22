class NewCategoryDTO {
  final String name;
  final String color;

  NewCategoryDTO({
    required this.name,
    required this.color,
  });
}

class UpdateCategoryDTO {
  final String categoryId;
  final String name;
  final String color;

  UpdateCategoryDTO({
    required this.categoryId,
    required this.name,
    required this.color,
  });
}
