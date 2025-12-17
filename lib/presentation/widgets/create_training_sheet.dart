import 'package:fit_app/application/dto/training.dart';
import 'package:fit_app/application/dto/workout_set.dart';
import 'package:fit_app/application/interactors/create_training.dart';
import 'package:fit_app/application/interactors/update_training.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:fit_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTrainingSheet extends StatefulWidget {
  const CreateTrainingSheet({super.key, this.training});

  final Training? training;

  @override
  State<CreateTrainingSheet> createState() => _CreateTrainingSheetState();
}

class _SetFormData {
  Exercise? exercise;
  String reps;
  _SetFormData() : reps = '';
}

class _ExistingSetData {
  _ExistingSetData(this.set);

  final PlannedSet set;
  bool remove = false;
}

class _CreateTrainingSheetState extends State<CreateTrainingSheet> {
  final TextEditingController _nameController = TextEditingController();
  final List<_SetFormData> _newSets = [];
  final List<_ExistingSetData> _existingSets = [];
  late final CreateTraining _createTraining;
  late final UpdateTraining _updateTraining;
  late final ExerciseRepository _exerciseRepository;
  late final List<Exercise> _availableExercises;
  bool _dependenciesReady = false;
  bool get _isEditing => widget.training != null;

  @override
  void initState() {
    super.initState();
    final training = widget.training;
    if (training != null) {
      _nameController.text = training.name;
      for (final plannedSet in training.plannedSets) {
        _existingSets.add(_ExistingSetData(plannedSet));
      }
    } else {
      _newSets.add(_SetFormData());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) return;
    _createTraining = context.read<CreateTraining>();
    _updateTraining = context.read<UpdateTraining>();
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
    setState(() => _newSets.add(_SetFormData()));
  }

  void _removeSet(int index) {
    if (!_isEditing && _newSets.length == 1) return;
    setState(() => _newSets.removeAt(index));
  }

  void _toggleExistingRemoval(int index) {
    setState(() {
      _existingSets[index].remove = !_existingSets[index].remove;
    });
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final trainingName = _nameController.text.trim();
    if (trainingName.isEmpty) {
      _showMessage(l10n.errorEnterTrainingName);
      return;
    }

    final newPlannedSets = <NewPlannedSetDTO>[];
    for (final setData in _newSets) {
      final exercise = setData.exercise;
      final reps = int.tryParse(setData.reps);
      if (exercise == null || reps == null || reps <= 0) {
        _showMessage(l10n.errorFillSets);
        return;
      }
      newPlannedSets.add(
        NewPlannedSetDTO(
          reps: reps,
          exerciseId: exercise.id,
        ),
      );
    }

    if (_isEditing) {
      final remainingExisting =
          _existingSets.where((set) => !set.remove).length;
      if (remainingExisting + newPlannedSets.length == 0) {
        _showMessage(l10n.errorTrainingNeedsSet);
        return;
      }
      final dto = UpdateTrainingDTO(
        trainingId: widget.training!.id,
        name: trainingName,
        setsToAdd: newPlannedSets,
        removePlannedSetIds: _existingSets
            .where((set) => set.remove)
            .map((set) => set.set.id)
            .toList(),
      );
      _updateTraining.execute(dto);
    } else {
      if (newPlannedSets.isEmpty) {
        _showMessage(l10n.errorAddAtLeastOneSet);
        return;
      }
      _createTraining.execute(
        NewTrainingDTO(
          name: trainingName,
          plannedSets: newPlannedSets,
        ),
      );
    }
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
    final l10n = AppLocalizations.of(context)!;

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
                _isEditing
                    ? l10n.editTrainingTitle
                    : l10n.createTrainingTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.labelTrainingName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (_existingSets.isNotEmpty) ...[
              Text(
                l10n.existingSetsLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
                const SizedBox(height: 12),
                ...List.generate(_existingSets.length, (index) {
                  final data = _existingSets[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        title: Text(data.set.exercise.name),
                        subtitle: Text(
                          l10n.repetitionsWithUnit(
                            data.set.targetRepetitions,
                          ),
                        ),
                        trailing: TextButton(
                          onPressed: () => _toggleExistingRemoval(index),
                          child: Text(data.remove
                              ? l10n.actionKeep
                              : l10n.actionRemove),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
              Text(
                _isEditing ? l10n.newSetsLabel : l10n.setsLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...List.generate(_newSets.length, (index) {
                final data = _newSets[index];
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
                            label: Text(l10n.labelExercise),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l10n.labelRepetitions,
                              border: const OutlineInputBorder(),
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
                label: Text(
                  _isEditing ? l10n.buttonAddNewSet : l10n.buttonAddSet,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _isEditing
                        ? l10n.buttonSaveChanges
                        : l10n.buttonAddTraining,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
