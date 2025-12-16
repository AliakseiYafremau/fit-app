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

  List<Training> _trainings = const [];
  List<Exercise> _exercises = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) return;
    _trainingRepository = context.read<TrainingRepository>();
    _exerciseRepository = context.read<ExerciseRepository>();
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
                ? _WorkoutsList(trainings: _trainings)
                : _ExercisesList(exercises: _exercises),
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
  const _WorkoutsList({required this.trainings});

  final List<Training> trainings;

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
          ),
        );
      },
      separatorBuilder: (_, separatorIndex) => const SizedBox(height: 12),
      itemCount: trainings.length,
    );
  }
}

class _ExercisesList extends StatelessWidget {
  const _ExercisesList({required this.exercises});

  final List<Exercise> exercises;

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
            trailing: Icon(
              exercise.usesWeights
                  ? Icons.fitness_center
                  : Icons.directions_run,
            ),
          ),
        );
      },
      separatorBuilder: (_, separatorIndex) => const SizedBox(height: 12),
      itemCount: exercises.length,
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
