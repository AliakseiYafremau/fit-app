import 'dart:typed_data';

class NewExerciseDTO {
  final String name;
  final String? technique;
  final String? notes;
  final bool usesWeights;
  final List<String> links;
  final Uint8List? photoBytes;
  final List<String> categoryIds;

  NewExerciseDTO({
    required this.name,
    this.technique,
    this.notes,
    this.usesWeights = false,
    this.links = const [],
    this.photoBytes,
    this.categoryIds = const [],
  });
}

class UpdateExerciseDTO {
  final String exerciseId;
  final String name;
  final String? technique;
  final String? notes;
  final List<String> links;
  final Uint8List? photoBytes;
  final bool removePhoto;
  final List<String> categoryIds;

  UpdateExerciseDTO({
    required this.exerciseId,
    required this.name,
    this.technique,
    this.notes,
    this.links = const [],
    this.photoBytes,
    this.removePhoto = false,
    this.categoryIds = const [],
  });
}
