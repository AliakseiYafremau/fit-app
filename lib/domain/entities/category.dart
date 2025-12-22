import 'package:fit_app/domain/entities/id.dart';


class Category {
  static final _hexColorPattern = RegExp(r'^#[0-9a-fA-F]{6}$');

  final Id id;
  final String name;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Category name cannot be empty');
    }
    if (!_hexColorPattern.hasMatch(color)) {
      throw ArgumentError('Category color must be a 6-digit HEX value');
    }
  }
}