import 'package:fit_app/application/interactors/delete_exercise.dart';
import 'package:fit_app/application/interactors/delete_training.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/create_exercise_sheet.dart';
import '../widgets/create_training_sheet.dart';
import '../widgets/primary_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _dependenciesReady = false;

  late final TrainingRepository _trainingRepository;
  late final ExerciseRepository _exerciseRepository;
  late final DeleteExercise _deleteExercise;
  late final DeleteTraining _deleteTraining;

  List<Training> _trainings = const [];
  List<Exercise> _exercises = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) return;
    _trainingRepository = context.read<TrainingRepository>();
    _exerciseRepository = context.read<ExerciseRepository>();
    _deleteExercise = context.read<DeleteExercise>();
    _deleteTraining = context.read<DeleteTraining>();
    _trainings = _trainingRepository.getAll();
    _exercises = _exerciseRepository.getAll();
    _dependenciesReady = true;
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _openCreateTraining() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateTrainingSheet(),
    );
    if (!mounted || created != true) return;
    _refreshTrainings();
  }

  Future<void> _openCreateExercise() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateExerciseSheet(),
    );
    if (!mounted || created != true) return;
    _refreshExercises();
  }

  void _refreshTrainings() {
    setState(() {
      _trainings = _trainingRepository.getAll();
    });
  }

  void _refreshExercises() {
    setState(() {
      _exercises = _exerciseRepository.getAll();
    });
  }

  void _onFabPressed() {
    if (_selectedIndex == 0) {
      _openCreateTraining();
    } else {
      _openCreateExercise();
    }
  }

  Future<void> _onEditExercise(Exercise exercise) async {
    final latest = _exerciseRepository.getById(exercise.id) ?? exercise;
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateExerciseSheet(exercise: latest),
    );
    if (!mounted || updated != true) return;
    _refreshExercises();
  }

  Future<void> _onEditTraining(Training training) async {
    final latest = _trainingRepository.getById(training.id) ?? training;
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateTrainingSheet(training: latest),
    );
    if (!mounted || updated != true) return;
    _refreshTrainings();
  }

  Future<void> _onDeleteExercise(Exercise exercise) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete exercise'),
        content: Text('Are you sure you want to delete "${exercise.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    _deleteExercise.execute(exercise.id);
    _refreshExercises();
  }

  Future<void> _onDeleteTraining(Training training) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete workout'),
        content: Text('Delete workout "${training.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    _deleteTraining.execute(training.id);
    _refreshTrainings();
  }

  Future<void> _showTrainingDetails(Training training) async {
    final latest = _trainingRepository.getById(training.id) ?? training;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TrainingDetailsSheet(training: latest),
    );
  }

  Future<void> _showExerciseDetails(Exercise exercise) async {
    final latest = _exerciseRepository.getById(exercise.id) ?? exercise;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ExerciseDetailsSheet(exercise: latest),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fit App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          PrimaryNavBar(
            tabs: const ['Workouts', 'Exercises'],
            selectedIndex: _selectedIndex,
            onTabSelected: _onNavTap,
          ),
          Expanded(
            child: _selectedIndex == 0
                ? _WorkoutsList(
                    trainings: _trainings,
                    onDelete: _onDeleteTraining,
                    onEdit: _onEditTraining,
                    onView: _showTrainingDetails,
                  )
                : _ExercisesList(
                    exercises: _exercises,
                    onDelete: _onDeleteExercise,
                    onEdit: _onEditExercise,
                    onView: _showExerciseDetails,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _WorkoutsList extends StatelessWidget {
  const _WorkoutsList({
    required this.trainings,
    required this.onDelete,
    required this.onEdit,
    required this.onView,
  });

  final List<Training> trainings;
  final ValueChanged<Training> onDelete;
  final ValueChanged<Training> onEdit;
  final ValueChanged<Training> onView;

  @override
  Widget build(BuildContext context) {
    if (trainings.isEmpty) {
      return const _EmptyState(message: 'No workouts yet');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final training = trainings[index];
        final setsCount = training.plannedSets.length;
        final subtitle = setsCount == 1
            ? '1 planned set'
            : '$setsCount planned sets';
        return Card(
          child: ListTile(
            title: Text(training.name),
            subtitle: Text(subtitle),
            onTap: () => onView(training),
            trailing: Wrap(
              spacing: 4,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit workout',
                  onPressed: () => onEdit(training),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete workout',
                  onPressed: () => onDelete(training),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, separatorIndex) => const SizedBox(height: 12),
      itemCount: trainings.length,
    );
  }
}

class _ExercisesList extends StatelessWidget {
  const _ExercisesList({
    required this.exercises,
    required this.onDelete,
    required this.onEdit,
    required this.onView,
  });

  final List<Exercise> exercises;
  final ValueChanged<Exercise> onDelete;
  final ValueChanged<Exercise> onEdit;
  final ValueChanged<Exercise> onView;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const _EmptyState(message: 'No exercises yet');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          child: ListTile(
            title: Text(exercise.name),
            subtitle: Text(
              exercise.technique.isEmpty
                  ? 'No technique description'
                  : exercise.technique,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => onView(exercise),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  exercise.usesWeights
                      ? Icons.fitness_center
                      : Icons.directions_run,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit exercise',
                  onPressed: () => onEdit(exercise),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete exercise',
                  onPressed: () => onDelete(exercise),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, separatorIndex) => const SizedBox(height: 12),
      itemCount: exercises.length,
    );
  }
}

class _TrainingDetailsSheet extends StatelessWidget {
  const _TrainingDetailsSheet({required this.training});

  final Training training;

  @override
  Widget build(BuildContext context) {
    final sets = training.plannedSets;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: bottomPadding + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                training.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                '${sets.length} planned set${sets.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (sets.isEmpty)
                const Text('No planned sets for this training')
              else
                ...sets.map(
                  (set) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(set.exercise.name),
                      subtitle: Text(
                        '${set.targetRepetitions} repetitions'
                        '${set.exercise.usesWeights ? ' with weights' : ''}',
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseDetailsSheet extends StatelessWidget {
  const _ExerciseDetailsSheet({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: bottomPadding + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                exercise.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    exercise.usesWeights
                        ? Icons.fitness_center
                        : Icons.directions_run,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    exercise.usesWeights
                        ? 'Uses weights'
                        : 'Bodyweight / no weights',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Technique',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                exercise.technique.isEmpty
                    ? 'No technique description'
                    : exercise.technique,
              ),
              const SizedBox(height: 16),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                exercise.notes.isEmpty ? 'No notes' : exercise.notes,
              ),
              const SizedBox(height: 16),
              Text(
                'Links',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (exercise.links.isEmpty)
                const Text('No links attached')
              else
                ...exercise.links.map(
                  (link) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(link),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
