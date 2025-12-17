import 'package:fit_app/application/interfaces/id_generator.dart';
import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/session.dart';
import 'package:fit_app/domain/entities/workout_set.dart';

class StartSession {
  final TrainingRepository trainingRepository;
  final SessionRepository sessionRepository;
  final WorkoutSetRepository workoutSetRepository;
  final IdGenerator idGenerator;

  StartSession({
    required this.trainingRepository,
    required this.sessionRepository,
    required this.workoutSetRepository,
    required this.idGenerator,
  });

  void execute(Id trainingId) {
    final activeSession = sessionRepository.getActive();
    if (activeSession != null) {
      throw StateError('Another session is already active');
    }
    final training = trainingRepository.getById(trainingId);
    if (training == null) {
      throw ArgumentError('Training with id $trainingId not found');
    }

    final workoutSets = training.plannedSets.map((plannedSet) {
      final workoutSet = WorkoutSet(
        id: idGenerator.generate(),
        exercise: plannedSet.exercise,
        repetitions: plannedSet.targetRepetitions,
      );
      workoutSetRepository.add(workoutSet);
      return workoutSet;
    }).toList(growable: false);

    final session = Session(
      id: idGenerator.generate(),
      training: training,
      workoutSets: workoutSets,
      active: true,
    );

    sessionRepository.add(session);
  }
}
