import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/logs.dart';

class InMemoryTrainingRepository implements TrainingRepository {
  InMemoryTrainingRepository._internal();
  static final InMemoryTrainingRepository _instance =
      InMemoryTrainingRepository._internal();

  factory InMemoryTrainingRepository() => _instance;

  final List<Training> _trainings = [];

  @override
  void add(Training training) {
    _trainings.add(training);
    logger.i('Training added: ${training.name}');
  }

  @override
  List<Training> getAll() => List.unmodifiable(_trainings);
}
