class NewExerciseDTO {
  final String name;
  final String technique;
  final String notes;
  final bool usesWeights;
  final List<String> links;

  NewExerciseDTO({
    required this.name,
    required this.technique,
    this.notes = '',
    this.usesWeights = false,
    this.links = const [],
  });
}