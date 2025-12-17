import 'dart:typed_data';

class NewExerciseDTO {
  final String name;
  final String? technique;
  final String? notes;
  final bool usesWeights;
  final List<String> links;
  final Uint8List? photoBytes;

  NewExerciseDTO({
    required this.name,
    this.technique,
    this.notes,
    this.usesWeights = false,
    this.links = const [],
    this.photoBytes,
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

  UpdateExerciseDTO({
    required this.exerciseId,
    required this.name,
    this.technique,
    this.notes,
    this.links = const [],
    this.photoBytes,
    this.removePhoto = false,
  });
}
