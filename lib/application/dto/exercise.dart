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

class UpdateExerciseDTO {
  final String exerciseId;
  final String name;
  final String technique;
  final String notes;
  final List<String> links;

  UpdateExerciseDTO({
    required this.exerciseId,
    required this.name,
    required this.technique,
    this.notes = '',
    this.links = const [],
  });
}
