import 'package:flutter/material.dart';

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

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openCreateTraining() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateTrainingSheet(),
    );
  }

  void _openCreateExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateExerciseSheet(),
    );
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
    final content =
        _selectedIndex == 0 ? 'Workout Plan' : 'Exercises Library';

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
            child: Center(
              child: Text(
                content,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
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
