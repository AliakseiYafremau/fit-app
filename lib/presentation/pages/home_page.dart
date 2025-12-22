import 'dart:typed_data';

import 'package:fit_app/application/interactors/cancel_session.dart';
import 'package:fit_app/application/interactors/complete_set.dart';
import 'package:fit_app/application/interactors/create_category.dart';
import 'package:fit_app/application/interactors/delete_category.dart';
import 'package:fit_app/application/interfaces/file_manager.dart';
import 'package:fit_app/application/interactors/delete_exercise.dart';
import 'package:fit_app/application/interactors/delete_training.dart';
import 'package:fit_app/application/interactors/finish_session.dart';
import 'package:fit_app/application/interactors/update_category.dart';
import 'package:fit_app/application/interactors/start_session.dart';
import 'package:fit_app/application/interactors/undo_complete_set.dart';
import 'package:fit_app/application/interfaces/repo/category.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/domain/entities/category.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/session.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:fit_app/l10n/app_localizations.dart';
import 'package:fit_app/presentation/providers/locale_controller.dart';
import 'package:fit_app/presentation/scaffold_messenger_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/categories_sheet.dart';
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
  late final PageController _pageController =
      PageController(initialPage: _selectedIndex);
  String _searchTerm = '';
  bool? _usesWeightsFilter;

  late final TrainingRepository _trainingRepository;
  late final ExerciseRepository _exerciseRepository;
  late final SessionRepository _sessionRepository;
  late final CategoryRepository _categoryRepository;
  late final DeleteExercise _deleteExercise;
  late final DeleteTraining _deleteTraining;
  late final StartSession _startSession;
  late final FinishSession _finishSession;
  late final CancelSession _cancelSession;
  late final CompleteSet _completeSet;
  late final UndoCompleteSet _undoCompleteSet;
  late final CreateCategory _createCategory;
  late final UpdateCategory _updateCategory;
  late final DeleteCategory _deleteCategory;

  List<Training> _trainings = const [];
  List<Exercise> _exercises = const [];
  Session? _activeSession;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) return;
    _trainingRepository = context.read<TrainingRepository>();
    _exerciseRepository = context.read<ExerciseRepository>();
    _sessionRepository = context.read<SessionRepository>();
    _categoryRepository = context.read<CategoryRepository>();
    _deleteExercise = context.read<DeleteExercise>();
    _deleteTraining = context.read<DeleteTraining>();
    _startSession = context.read<StartSession>();
    _finishSession = context.read<FinishSession>();
    _cancelSession = context.read<CancelSession>();
    _completeSet = context.read<CompleteSet>();
    _undoCompleteSet = context.read<UndoCompleteSet>();
    _createCategory = context.read<CreateCategory>();
    _updateCategory = context.read<UpdateCategory>();
    _deleteCategory = context.read<DeleteCategory>();
    _trainings = _trainingRepository.getAll();
    _exercises = _exerciseRepository.getAll();
    _activeSession = _sessionRepository.getActive();
    _dependenciesReady = true;
  }

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value.trim().toLowerCase();
    });
  }

  void _onPageChanged(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  void _refreshActiveSession() {
    setState(() {
      _activeSession = _sessionRepository.getActive();
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
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteExerciseTitle),
        content: Text(l10n.deleteExerciseMessage(exercise.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.buttonDelete),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    _deleteExercise.execute(exercise.id);
    _refreshExercises();
  }

  Future<void> _onDeleteTraining(Training training) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteWorkoutTitle),
        content: Text(l10n.deleteWorkoutMessage(training.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.buttonDelete),
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
      builder: (context) => _TrainingDetailsSheet(
        training: latest,
        canStartSession: _activeSession == null,
        onStartSession: () => _startTrainingSession(latest),
        onViewExercise: _showExerciseDetails,
        onEdit: _onEditTraining,
        onDelete: _onDeleteTraining,
      ),
    );
  }

  Future<void> _showExerciseDetails(Exercise exercise) async {
    final latest = _exerciseRepository.getById(exercise.id) ?? exercise;
    final categories = _categoryRepository.getAll();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ExerciseDetailsSheet(
        exercise: latest,
        categories: categories,
        onEdit: _onEditExercise,
        onDelete: _onDeleteExercise,
      ),
    );
  }

  Future<void> _startTrainingSession(Training training) async {
      _startSession.execute(training.id);
      _refreshActiveSession();
      if (!mounted) return;
      _openActiveSessionSheet();
  }

  Future<void> _openActiveSessionSheet() async {
    final session = _activeSession;
    if (session == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _SessionSheet(
        session: session,
        onFinish: _handleFinishSession,
        onCancel: _handleCancelSession,
        onCompleteSet: _handleCompleteSet,
        onUndoSet: _handleUndoSet,
        onViewExercise: _showExerciseDetails,
        onRefresh: _refreshAndGetActiveSession,
      ),
    );
    if (!mounted) return;
    _refreshActiveSession();
  }

  Future<void> _openHistorySheet() async {
    final completedSessions = _sessionRepository.getCompleted();
    if (!mounted) return;
    final selectedSession = await showModalBottomSheet<Session>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _HistorySheet(sessions: completedSessions),
    );
    if (!mounted || selectedSession == null) return;
    _showSessionHistoryDetails(selectedSession);
  }

  Future<void> _showSessionHistoryDetails(Session session) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _SessionHistoryDetailsSheet(
        session: session,
        onViewExercise: _showExerciseDetails,
      ),
    );
  }

  Future<void> _handleFinishSession() async {
    final session = _activeSession;
    if (session == null) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      _finishSession.execute(session.id);
      _refreshActiveSession();
    } catch (error) {
      _showError(l10n.errorFinishSession);
    }
  }

  Future<void> _handleCancelSession() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelSessionTitle),
        content: Text(l10n.cancelSessionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelSessionKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.cancelSessionConfirm),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    try {
      _cancelSession.execute();
      _refreshActiveSession();
    } catch (_) {
      _showError(l10n.errorCancelSession);
      rethrow;
    }
  }

  Future<void> _handleCompleteSet(
    WorkoutSet set,
    int repetitions,
    double? weight,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      _completeSet.execute(
        workoutSetId: set.id,
        repetitions: repetitions,
        weight: weight,
      );
      _refreshActiveSession();
    } catch (error) {
      _showError(l10n.errorCompleteSet);
    }
  }

  Future<void> _handleUndoSet(WorkoutSet set) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      _undoCompleteSet.execute(workoutSetId: set.id);
      _refreshActiveSession();
    } catch (error) {
      _showError(l10n.errorUndoSet);
    }
  }

  Future<Session?> _refreshAndGetActiveSession() async {
    final session = _sessionRepository.getActive();
    if (mounted) {
      setState(() {
        _activeSession = session;
      });
    }
    return session;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openCategoriesSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CategoriesSheet(
        categoryRepository: _categoryRepository,
        createCategory: _createCategory,
        updateCategory: _updateCategory,
        deleteCategory: _deleteCategory,
      ),
    );
  }

  void _openDashboard() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                l10n.dashboardTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: Text(l10n.dashboardCategories),
              onTap: () {
                Navigator.of(context).pop();
                _openCategoriesSheet();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeController = context.watch<LocaleController>();
    final currentLocaleCode = localeController.locale?.languageCode;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _openDashboard,
          icon: const Icon(Icons.menu),
          tooltip: l10n.dashboardTooltip,
        ),
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            tooltip: l10n.languageSelectorTooltip,
            icon: const Icon(Icons.language),
            onSelected: (code) {
              context.read<LocaleController>().setLocale(Locale(code));
            },
            itemBuilder: (context) => [
              _buildLocaleMenuItem(
                label: l10n.languageEnglish,
                value: 'en',
                currentCode: currentLocaleCode,
              ),
              _buildLocaleMenuItem(
                label: l10n.languageRussian,
                value: 'ru',
                currentCode: currentLocaleCode,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: PrimaryNavBar(
              tabs: [l10n.tabWorkouts, l10n.tabExercises],
              selectedIndex: _selectedIndex,
              onTabSelected: _onNavTap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: l10n.searchHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                if (_selectedIndex == 1) ...[
                  const SizedBox(width: 12),
                  ToggleButtons(
                    isSelected: [
                      _usesWeightsFilter == null,
                      _usesWeightsFilter == true,
                      _usesWeightsFilter == false,
                    ],
                    borderRadius: BorderRadius.circular(8),
                    onPressed: (index) {
                      setState(() {
                        if (index == 0) {
                          _usesWeightsFilter = null;
                        } else if (index == 1) {
                          _usesWeightsFilter =
                              _usesWeightsFilter == true ? null : true;
                        } else {
                          _usesWeightsFilter =
                              _usesWeightsFilter == false ? null : false;
                        }
                      });
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.remove_circle_outline),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.fitness_center),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.directions_run),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    _WorkoutsList(
                      trainings: _trainings,
                      searchTerm: _searchTerm,
                      onView: _showTrainingDetails,
                    ),
                    _ExercisesList(
                      exercises: _exercises,
                      searchTerm: _searchTerm,
                      usesWeightsFilter: _usesWeightsFilter,
                      onView: _showExerciseDetails,
                    ),
                  ],
                ),
                Positioned(
                  left: 16,
                  bottom: 24,
                  child: _HistoryBubbleButton(onTap: _openHistorySheet),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_activeSession != null) ...[
            FloatingActionButton(
              heroTag: 'active_session_fab',
              onPressed: _openActiveSessionSheet,
              tooltip: l10n.fabActiveSessionTooltip,
              child: const Icon(Icons.play_arrow),
            ),
            const SizedBox(width: 12),
          ],
          FloatingActionButton(
            heroTag: 'main_fab',
            onPressed: _onFabPressed,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _WorkoutsList extends StatelessWidget {
  const _WorkoutsList({
    required this.trainings,
    required this.searchTerm,
    required this.onView,
  });

  final List<Training> trainings;
  final String searchTerm;
  final ValueChanged<Training> onView;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filtered = searchTerm.isEmpty
        ? trainings
        : trainings
            .where((training) =>
                training.name.toLowerCase().contains(searchTerm))
            .toList();
    if (filtered.isEmpty) {
      return _EmptyState(message: l10n.noWorkouts);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final training = filtered[index];
        final setsCount = training.plannedSets.length;
        final subtitle = l10n.plannedSetsCount(setsCount);
        return Card(
          child: ListTile(
            title: Text(training.name),
            subtitle: Text(subtitle),
            onTap: () => onView(training),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
      separatorBuilder: (_, unused) => const SizedBox(height: 12),
      itemCount: filtered.length,
    );
  }
}

class _HistoryBubbleButton extends StatelessWidget {
  const _HistoryBubbleButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final borderRadius = BorderRadius.circular(26);
    return Material(
      elevation: 4,
      color: colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.historyButton,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExercisesList extends StatelessWidget {
  const _ExercisesList({
    required this.exercises,
    required this.searchTerm,
    required this.usesWeightsFilter,
    required this.onView,
  });

  final List<Exercise> exercises;
  final String searchTerm;
  final bool? usesWeightsFilter;
  final ValueChanged<Exercise> onView;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Iterable<Exercise> candidates = exercises;
    if (searchTerm.isNotEmpty) {
      candidates = candidates.where((exercise) =>
          exercise.name.toLowerCase().contains(searchTerm) ||
          (exercise.technique ?? '').toLowerCase().contains(searchTerm));
    }
    if (usesWeightsFilter != null) {
      candidates = candidates.where(
        (exercise) => exercise.usesWeights == usesWeightsFilter,
      );
    }
    final filtered = candidates.toList();
    if (filtered.isEmpty) {
      return _EmptyState(message: l10n.noExercises);
    }
    final fileManager = context.read<FileManager>();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final exercise = filtered[index];
        final photoId = exercise.photoId;
        return Card(
          child: ListTile(
            title: Text(exercise.name),
            onTap: () => onView(exercise),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (photoId != null && fileManager.exists(photoId))
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.memory(
                          fileManager.read(photoId),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                Icon(
                  exercise.usesWeights
                      ? Icons.fitness_center
                      : Icons.directions_run,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, separatorIndex) => const SizedBox(height: 12),
      itemCount: filtered.length,
    );
  }
}

class _TrainingDetailsSheet extends StatelessWidget {
  const _TrainingDetailsSheet({
    required this.training,
    required this.canStartSession,
    required this.onStartSession,
    required this.onViewExercise,
    required this.onEdit,
    required this.onDelete,
  });

  final Training training;
  final bool canStartSession;
  final VoidCallback onStartSession;
  final ValueChanged<Exercise> onViewExercise;
  final ValueChanged<Training> onEdit;
  final ValueChanged<Training> onDelete;

  @override
  Widget build(BuildContext context) {
    final sets = training.plannedSets;
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
                training.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.plannedSetsCount(sets.length),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (sets.isEmpty)
                Text(l10n.noPlannedSets)
              else
                ...sets.map(
                  (set) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () => onViewExercise(set.exercise),
                      title: Text(set.exercise.name),
                      subtitle: Text(
                        '${set.targetRepetitions} repetitions'
                        '${set.exercise.usesWeights ? ' with weights' : ''}',
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(l10n.buttonEditWorkout),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onEdit(training);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l10n.buttonDeleteWorkout),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onDelete(training);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                        onPressed: canStartSession
                          ? () {
                              Navigator.of(context).pop();
                              onStartSession();
                            }
                          : null,
                        child: Text(l10n.buttonStartSession),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.buttonClose),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseDetailsSheet extends StatelessWidget {
  const _ExerciseDetailsSheet({
    required this.exercise,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  final Exercise exercise;
  final List<Category> categories;
  final ValueChanged<Exercise> onEdit;
  final ValueChanged<Exercise> onDelete;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;
    final categoriesById = {
      for (final category in categories) category.id: category,
    };
    final selectedCategories = exercise.categoriesId
        .map((id) => categoriesById[id])
        .whereType<Category>()
        .toList();
    final techniqueText = exercise.technique?.trim() ?? '';
    final notesText = exercise.notes?.trim() ?? '';
    final hasTechnique = techniqueText.isNotEmpty;
    final hasNotes = notesText.isNotEmpty;
    final hasLinks = exercise.links.isNotEmpty;
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
              if (exercise.photoId != null) ...[
                Text(
                  l10n.sectionPhoto,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _ExercisePhotoViewer(photoId: exercise.photoId!),
                const SizedBox(height: 16),
              ],
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
                        ? l10n.exerciseUsesWeights
                        : l10n.exerciseBodyweight,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (selectedCategories.isNotEmpty) ...[
                Text(
                  l10n.exerciseFormCategoriesLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedCategories.map((category) {
                    final color = _colorFromHex(category.color);
                    return Chip(
                      backgroundColor: color.withValues(alpha: 0.15),
                      label: Text(category.name),
                      avatar: CircleAvatar(
                        backgroundColor: color,
                        radius: 14,
                        child: const SizedBox.shrink(),
                      ),
                    );
                  }).toList(),
                ),
              ],
              if (hasTechnique) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.sectionTechnique,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(techniqueText),
              ],
              if (hasNotes) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.sectionNotes,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(notesText),
              ],
              if (hasLinks) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.sectionLinks,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...exercise.links.map(
                  (link) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ExerciseLinkPreview(
                      link: link,
                      launcher: (uri) => _launchLink(context, uri),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(l10n.buttonEditExercise),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onEdit(exercise);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.buttonDeleteExercise),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onDelete(exercise);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.buttonClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchLink(BuildContext context, Uri uri) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!context.mounted) return;
      if (!opened) {
        _showTopSnackBar(context, l10n.errorUnableToOpenLink);
      }
    } catch (_) {
      if (!context.mounted) return;
      _showTopSnackBar(context, l10n.errorUnableToOpenLink);
    }
  }

  Color _colorFromHex(String value) {
    if (value.length == 7 && value.startsWith('#')) {
      final parsed = int.tryParse(value.substring(1), radix: 16);
      if (parsed != null) {
        return Color(0xFF000000 | parsed);
      }
    }
    return Colors.grey;
  }
}

class _ExerciseLinkPreview extends StatelessWidget {
  const _ExerciseLinkPreview({
    required this.link,
    required this.launcher,
  });

  final String link;
  final Future<void> Function(Uri uri) launcher;

  @override
  Widget build(BuildContext context) {
    final uri = _normalizeLinkUri(link);
    if (uri == null) {
      return Text(link);
    }
    final videoId = _extractYoutubeId(uri);
    if (videoId != null) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => launcher(uri),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://img.youtube.com/vi/$videoId/0.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(Icons.play_circle_outline),
                      ),
                    ),
                    Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.ondemand_video),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        uri.toString(),
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.open_in_new),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: ListTile(
        onTap: () => launcher(uri),
        leading: const Icon(Icons.link),
        title: Text(
          uri.toString(),
          style: const TextStyle(decoration: TextDecoration.underline),
        ),
        trailing: const Icon(Icons.open_in_new),
      ),
    );
  }
}

Uri? _normalizeLinkUri(String? raw) {
  final trimmed = raw?.trim() ?? '';
  if (trimmed.isEmpty) return null;
  Uri? uri = Uri.tryParse(trimmed);
  if (uri == null) return null;
  if (!uri.hasScheme) {
    uri = Uri.tryParse('https://$trimmed');
  }
  return uri;
}

String? _extractYoutubeId(Uri uri) {
  final host = uri.host.toLowerCase();
  if (host.contains('youtu.be')) {
    if (uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }
    return null;
  }
  if (host.contains('youtube.com')) {
    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.first == 'shorts' && uri.pathSegments.length >= 2) {
        return uri.pathSegments[1];
      }
      if (uri.pathSegments.first == 'embed' && uri.pathSegments.length >= 2) {
        return uri.pathSegments[1];
      }
    }
    final videoId = uri.queryParameters['v'];
    if (videoId != null && videoId.isNotEmpty) {
      return videoId;
    }
  }
  return null;
}

String _formatDateTime(DateTime dateTime) {
  return '${dateTime.year.toString().padLeft(4, '0')}-'
      '${dateTime.month.toString().padLeft(2, '0')}-'
      '${dateTime.day.toString().padLeft(2, '0')} '
      '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';
}

String _formatDate(DateTime dateTime) {
  return '${dateTime.year.toString().padLeft(4, '0')}-'
      '${dateTime.month.toString().padLeft(2, '0')}-'
      '${dateTime.day.toString().padLeft(2, '0')}';
}

String _formatTime(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';
}

String _formatTimeRange(Session session) {
  final start = _formatTime(session.startedAt);
  final end = session.finishedAt != null ? _formatTime(session.finishedAt!) : null;
  return end == null ? start : '$start – $end';
}

DateTime _startOfDay(DateTime dateTime) =>
    DateTime(dateTime.year, dateTime.month, dateTime.day);

PopupMenuEntry<String> _buildLocaleMenuItem({
  required String label,
  required String value,
  required String? currentCode,
}) {
  final selected = currentCode == value;
  return PopupMenuItem<String>(
    value: value,
    child: Row(
      children: [
        selected
            ? const Icon(Icons.check, size: 18)
            : const SizedBox(width: 18),
        const SizedBox(width: 8),
        Text(label),
      ],
    ),
  );
}

void _showTopSnackBar(BuildContext context, String message) {
  final messenger =
      rootScaffoldMessengerKey.currentState ?? ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  final paddingContext =
      rootScaffoldMessengerKey.currentContext ?? context;
  final mediaQuery = MediaQuery.maybeOf(paddingContext);
  final topPadding = (mediaQuery?.padding.top ?? 0) + kToolbarHeight + 16;
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.fromLTRB(16, topPadding, 16, 0),
    ),
  );
}

class _ExercisePhotoViewer extends StatelessWidget {
  const _ExercisePhotoViewer({required this.photoId});

  final String photoId;

  @override
  Widget build(BuildContext context) {
    final fileManager = context.read<FileManager>();
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<Uint8List>(
      future: Future<Uint8List>(() => fileManager.read(photoId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            alignment: Alignment.center,
            child: Text(l10n.errorUnableToLoadPhoto),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            snapshot.data!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

class _HistorySheet extends StatefulWidget {
  const _HistorySheet({required this.sessions});

  final List<Session> sessions;

  @override
  State<_HistorySheet> createState() => _HistorySheetState();
}

class _HistorySheetState extends State<_HistorySheet> {
  bool _showCalendar = false;
  late final Map<DateTime, List<Session>> _sessionsByDay;
  late final DateTime _firstDate;
  late final DateTime _lastDate;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final sorted = List<Session>.from(widget.sessions)
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
    _sessionsByDay = {};
    for (final session in sorted) {
      final key = _startOfDay(session.startedAt);
      _sessionsByDay.putIfAbsent(key, () => []).add(session);
    }
    if (sorted.isNotEmpty) {
      _firstDate = _startOfDay(sorted.first.startedAt);
      _lastDate = _startOfDay(sorted.last.startedAt);
      _selectedDay = _lastDate;
    } else {
      final today = _startOfDay(DateTime.now());
      _firstDate = today.subtract(const Duration(days: 365));
      _lastDate = today;
      _selectedDay = today;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final listHeight = (MediaQuery.of(context).size.height * 0.5)
        .clamp(240.0, 520.0)
        .toDouble();
    final l10n = AppLocalizations.of(context)!;
    final sessions = widget.sessions;
    final selectedSessions = _sessionsByDay[_selectedDay] ?? const <Session>[];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: bottomPadding + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sessionHistoryTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            if (sessions.isEmpty)
              Text(l10n.sessionHistoryEmpty)
            else ...[
              ToggleButtons(
                isSelected: [!_showCalendar, _showCalendar],
                onPressed: (index) {
                  setState(() => _showCalendar = index == 1);
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(l10n.historyViewList),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(l10n.historyViewCalendar),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (!_showCalendar)
                SizedBox(
                  height: listHeight,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final completedSets =
                          session.workoutSets.where((set) => set.done).length;
                      return Card(
                        child: ListTile(
                          title: Text(
                            l10n.startedLabel(
                              _formatDateTime(session.startedAt),
                            ),
                          ),
                          subtitle:
                              Text(l10n.completedSetsCount(completedSets)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).pop(session),
                        ),
                      );
                    },
                    separatorBuilder: (_, unused) => const SizedBox(height: 8),
                    itemCount: sessions.length,
                  ),
                )
              else ...[
                Text(
                  l10n.sessionCalendarTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                CalendarDatePicker(
                  initialDate: _selectedDay,
                  firstDate: _firstDate,
                  lastDate: DateTime.now().isAfter(_lastDate)
                      ? DateTime.now()
                      : _lastDate,
                  currentDate: DateTime.now(),
                  onDateChanged: (date) {
                    setState(() => _selectedDay = _startOfDay(date));
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.sessionsOnDay(_formatDate(_selectedDay)),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (selectedSessions.isEmpty)
                  Text(l10n.sessionDayEmpty)
                else
                  ...selectedSessions.map(
                    (session) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.startedLabel(
                          _formatDateTime(session.startedAt),
                        ),
                      ),
                      subtitle: Text(_formatTimeRange(session)),
                      onTap: () => Navigator.of(context).pop(session),
                    ),
                  ),
              ],
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.buttonClose),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionHistoryDetailsSheet extends StatelessWidget {
  const _SessionHistoryDetailsSheet({
    required this.session,
    required this.onViewExercise,
  });

  final Session session;
  final ValueChanged<Exercise> onViewExercise;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final sets = session.workoutSets;
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
                l10n.sessionSheetTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.startedLabel(_formatDateTime(session.startedAt)),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!
                    .startedLabel(_formatDateTime(session.startedAt)),
              ),
              if (session.finishedAt != null) ...[
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!
                      .finishedLabel(_formatDateTime(session.finishedAt!)),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.sessionSummaryTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (sets.isEmpty)
                Text(AppLocalizations.of(context)!.sessionSummaryEmpty)
              else
                ...sets.map(
                  (set) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onTap: () => onViewExercise(set.exercise),
                      leading: Icon(
                        set.done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
                      title: Text(set.exercise.name),
                      subtitle: Text(
                        l10n.repetitionsWithUnit(set.repetitions) +
                            (set.exercise.usesWeights && set.weight != null
                                ? ' ${l10n.weightDisplay(set.weight!.toString())}'
                                : ''),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.buttonClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionSheet extends StatefulWidget {
  const _SessionSheet({
    required this.session,
    required this.onCompleteSet,
    required this.onUndoSet,
    required this.onFinish,
    required this.onCancel,
    required this.onViewExercise,
    required this.onRefresh,
  });

  final Session session;
  final Future<void> Function(WorkoutSet set, int repetitions, double? weight)
      onCompleteSet;
  final Future<void> Function(WorkoutSet set) onUndoSet;
  final Future<void> Function() onFinish;
  final Future<void> Function() onCancel;
  final ValueChanged<Exercise> onViewExercise;
  final Future<Session?> Function() onRefresh;

  @override
  State<_SessionSheet> createState() => _SessionSheetState();
}

class _SessionSheetState extends State<_SessionSheet> {
  late Session _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  Future<void> _completeSet(WorkoutSet set) async {
    final l10n = AppLocalizations.of(context)!;
    final repsController =
        TextEditingController(text: set.repetitions.toString());
    final usesWeights = set.exercise.usesWeights;
    final weightController = usesWeights
        ? TextEditingController(text: set.weight?.toString() ?? '')
        : null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.completeSetTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.labelRepetitions,
              ),
            ),
            const SizedBox(height: 12),
            if (usesWeights)
              TextField(
                controller: weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.labelWeight,
                  helperText: l10n.helperWeightedExercise,
                ),
              )
            else
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.bodyweightOnly,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.buttonSave),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    final repetitions = int.tryParse(repsController.text.trim() == ''
        ? set.repetitions.toString()
        : repsController.text.trim());
    if (repetitions == null || repetitions <= 0) {
      _showTopSnackBar(context, l10n.errorEnterValidRepetitions);
      return;
    }
    double? weight;
    if (usesWeights) {
      final weightText = weightController!.text.trim();
      if (weightText.isNotEmpty) {
        weight = double.tryParse(weightText);
        if (weight == null) {
          _showTopSnackBar(context, l10n.errorEnterValidWeight);
          return;
        }
      } else if (set.weight == null) {
        _showTopSnackBar(context, l10n.errorWeightRequired);
        return;
      }
    }

    await widget.onCompleteSet(set, repetitions, weight);
    await _refreshSession();
  }

  Future<void> _undoSet(WorkoutSet set) async {
    await widget.onUndoSet(set);
    await _refreshSession();
  }

  Future<void> _finishSession() async {
    await widget.onFinish();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _cancelSession() async {
    try {
      await widget.onCancel();
    } catch (_) {
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _refreshSession() async {
    final refreshed = await widget.onRefresh();
    if (!mounted) return;
    if (refreshed == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _session = refreshed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;
    final sets = _session.workoutSets;
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
                l10n.sessionSheetTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!
                    .startedLabel(_formatDateTime(_session.startedAt)),
              ),
              const SizedBox(height: 16),
              if (sets.isEmpty)
                Text(l10n.emptySessionSets)
              else
                ...sets.map(
                  (set) => Card(
                    child: ListTile(
                      onTap: () => widget.onViewExercise(set.exercise),
                      leading: Icon(
                        set.done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
                      title: Text(set.exercise.name),
                      subtitle: Text(
                        l10n.repetitionsWithUnit(set.repetitions) +
                            (set.exercise.usesWeights && set.weight != null
                                ? ' ${l10n.weightDisplay(set.weight!.toString())}'
                                : ''),
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          if (set.done)
                            TextButton(
                              onPressed: () => _undoSet(set),
                              child: Text(l10n.buttonUndo),
                            ),
                          TextButton(
                            onPressed: () => _completeSet(set),
                            child: Text(
                              set.done
                                  ? l10n.buttonUpdate
                                  : l10n.buttonComplete,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _finishSession,
                      child: Text(l10n.buttonFinishSession),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelSession,
                      child: Text(l10n.buttonCancelSession),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.buttonClose),
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
