import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:fit_app/domain/logs.dart';

class InMemoryPlannedSetRepository implements PlannedSetRepository {
  InMemoryPlannedSetRepository._internal();
  static final InMemoryPlannedSetRepository _instance =
      InMemoryPlannedSetRepository._internal();

  factory InMemoryPlannedSetRepository() => _instance;

  final List<PlannedSet> _plannedSets = [];

  @override
  void add(PlannedSet plannedSet) {
    _plannedSets.add(plannedSet);
    logger.i('Planned set added: ${plannedSet.id}');
  }

  List<PlannedSet> getAll() => List.unmodifiable(_plannedSets);
}
