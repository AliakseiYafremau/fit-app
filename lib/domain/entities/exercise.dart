import 'id.dart';


/// Упражнение.
/// 
/// Содержит информацию о самом упражнении и его характеристиках.
class Exercise {
  final Id id;
  final String name;
  final String technique;
  final String notes;
  final bool usesWeights;
  final List<String> links;

  Exercise({
    required this.id,
    required this.name,
    this.technique = '',
    this.notes = '',
    required this.usesWeights,
    this.links = const [],
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Exercise name cannot be empty');
    }
  }
}