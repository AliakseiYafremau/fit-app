import 'package:fit_app/application/dto/training.dart';
import 'package:fit_app/application/dto/workout_set.dart';
import 'package:fit_app/application/interactors/create_training.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTrainingSheet extends StatefulWidget {
  const CreateTrainingSheet({super.key});

  @override
  State<CreateTrainingSheet> createState() => _CreateTrainingSheetState();
}

class _SetFormData {
  Exercise? exercise;
  String reps;

  _SetFormData()
      : exercise = null,
        reps = '';
}

class _CreateTrainingSheetState extends State<CreateTrainingSheet> {
  final TextEditingController _nameController = TextEditingController();
  final List<_SetFormData> _sets = [_SetFormData()];
  late final CreateTraining _createTraining;
  late final ExerciseRepository _exerciseRepository;
  late final List<Exercise> _availableExercises;
  bool _dependenciesReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) return;
    _createTraining = context.read<CreateTraining>();
    _exerciseRepository = context.read<ExerciseRepository>();
    _availableExercises = _exerciseRepository.getAll();
    _dependenciesReady = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addSet() {
    setState(() => _sets.add(_SetFormData()));
  }

  void _removeSet(int index) {
    if (_sets.length == 1) return;
    setState(() => _sets.removeAt(index));
  }

  void _submit() {
    final trainingName = _nameController.text.trim();
    if (trainingName.isEmpty) {
      _showMessage('Enter training name');
      return;
    }

    final plannedSets = <NewPlannedSetDTO>[];
    for (final setData in _sets) {
      final exercise = setData.exercise;
      final reps = int.tryParse(setData.reps);
      if (exercise == null) {
        _showMessage('Select exercise for each set');
        return;
      }
      if (reps == null || reps <= 0) {
        _showMessage('Enter valid repetitions for each set');
        return;
      }
      plannedSets.add(
        NewPlannedSetDTO(
          reps: reps,
          exerciseId: exercise.id,
        ),
      );
    }

    if (plannedSets.isEmpty) {
      _showMessage('Add at least one set');
      return;
    }

    _createTraining.execute(
      NewTrainingDTO(
        name: trainingName,
        plannedSets: plannedSets,
      ),
    );
    Navigator.of(context).pop(true);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                'Create Training',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Training name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Sets',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...List.generate(_sets.length, (index) {
                final data = _sets[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          DropdownMenu<Exercise>(
                            initialSelection: data.exercise,
                            dropdownMenuEntries: _availableExercises
                                .map(
                                  (exercise) => DropdownMenuEntry<Exercise>(
                                    value: exercise,
                                    label: exercise.name,
                                  ),
                                )
                                .toList(),
                            onSelected: (value) {
                              setState(() => data.exercise = value);
                            },
                            label: const Text('Exercise'),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Repetitions',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => data.reps = value,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () => _removeSet(index),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              OutlinedButton.icon(
                onPressed:
                    _availableExercises.isEmpty ? null : _addSet,
                icon: const Icon(Icons.add),
                label: const Text('Add set'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
