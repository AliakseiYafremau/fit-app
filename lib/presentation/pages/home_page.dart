import 'package:fit_app/application/interactors/cancel_session.dart';
import 'package:fit_app/application/interactors/complete_set.dart';
import 'package:fit_app/application/interactors/undo_complete_set.dart';
import 'package:fit_app/application/interactors/delete_exercise.dart';
import 'package:fit_app/application/interactors/delete_training.dart';
import 'package:fit_app/application/interactors/finish_session.dart';
import 'package:fit_app/application/interactors/start_session.dart';
import 'package:fit_app/application/interfaces/repo/exercise.dart';
import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/session.dart';
import 'package:fit_app/domain/entities/training.dart';
import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  late final TrainingRepository _trainingRepository;
  late final ExerciseRepository _exerciseRepository;
  late final SessionRepository _sessionRepository;
  late final DeleteExercise _deleteExercise;
  late final DeleteTraining _deleteTraining;
  late final StartSession _startSession;
  late final FinishSession _finishSession;
  late final CancelSession _cancelSession;
  late final CompleteSet _completeSet;
  late final UndoCompleteSet _undoCompleteSet;

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
    _deleteExercise = context.read<DeleteExercise>();
    _deleteTraining = context.read<DeleteTraining>();
    _startSession = context.read<StartSession>();
    _finishSession = context.read<FinishSession>();
    _cancelSession = context.read<CancelSession>();
    _completeSet = context.read<CompleteSet>();
    _undoCompleteSet = context.read<UndoCompleteSet>();
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
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ExerciseDetailsSheet(
        exercise: latest,
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
    try {
      _finishSession.execute(session.id);
      _refreshActiveSession();
    } catch (error) {
      _showError('Unable to finish session');
    }
  }

  Future<void> _handleCancelSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel session'),
        content: const Text(
          'Are you sure you want to cancel this session? Progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep session'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel session'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    try {
      _cancelSession.execute();
      _refreshActiveSession();
    } catch (_) {
      _showError('Unable to cancel session');
      rethrow;
    }
  }

  Future<void> _handleCompleteSet(
    WorkoutSet set,
    int repetitions,
    double? weight,
  ) async {
    try {
      _completeSet.execute(
        workoutSetId: set.id,
        repetitions: repetitions,
        weight: weight,
      );
      _refreshActiveSession();
    } catch (error) {
      _showError('Unable to complete set');
    }
  }

  Future<void> _handleUndoSet(WorkoutSet set) async {
    try {
      _undoCompleteSet.execute(workoutSetId: set.id);
      _refreshActiveSession();
    } catch (error) {
      _showError('Unable to undo set');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fit App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: PrimaryNavBar(
              tabs: const ['Workouts', 'Exercises'],
              selectedIndex: _selectedIndex,
              onTabSelected: _onNavTap,
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
                      onView: _showTrainingDetails,
                    ),
                    _ExercisesList(
                      exercises: _exercises,
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
              tooltip: 'View active session',
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
    required this.onView,
  });

  final List<Training> trainings;
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
        final subtitle =
            setsCount == 1 ? '1 planned set' : '$setsCount planned sets';
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
      itemCount: trainings.length,
    );
  }
}

class _HistoryBubbleButton extends StatelessWidget {
  const _HistoryBubbleButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                'History',
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
    required this.onView,
  });

  final List<Exercise> exercises;
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
              (exercise.technique ?? '').isEmpty
                  ? 'No technique description'
                  : exercise.technique!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => onView(exercise),
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
                      label: const Text('Edit workout'),
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
                      label: const Text('Delete workout'),
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
                      child: const Text('Start session'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
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
    required this.onEdit,
    required this.onDelete,
  });

  final Exercise exercise;
  final ValueChanged<Exercise> onEdit;
  final ValueChanged<Exercise> onDelete;

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
                (exercise.technique ?? '').isEmpty
                    ? 'No technique description'
                    : exercise.technique!,
              ),
              const SizedBox(height: 16),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                (exercise.notes ?? '').isEmpty
                    ? 'No notes'
                    : exercise.notes!,
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
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ExerciseLinkPreview(
                      link: link,
                      launcher: (uri) => _launchLink(context, uri),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit exercise'),
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
                      label: const Text('Delete exercise'),
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
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchLink(BuildContext context, Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Unable to open link')),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Unable to open link')),
      );
    }
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

class _HistorySheet extends StatelessWidget {
  const _HistorySheet({required this.sessions});

  final List<Session> sessions;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final listHeight = (MediaQuery.of(context).size.height * 0.5)
        .clamp(240.0, 520.0)
        .toDouble();
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
              'Session history',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            if (sessions.isEmpty)
              const Text('No completed sessions yet')
            else
              SizedBox(
                height: listHeight,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final completedSets =
                        session.workoutSets.where((set) => set.done).length;
                    return Card(
                      child: ListTile(
                        title: Text(session.training.name),
                        subtitle: Text(
                          '$completedSets completed set${completedSets == 1 ? '' : 's'}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).pop(session),
                      ),
                    );
                  },
                  separatorBuilder: (_, unused) => const SizedBox(height: 8),
                  itemCount: sessions.length,
                ),
              ),
            const SizedBox(height: 16),
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
                session.training.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Completed session summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (sets.isEmpty)
                const Text('No sets were tracked in this session')
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
                        '${set.repetitions} reps'
                        '${set.exercise.usesWeights && set.weight != null ? ' @ ${set.weight}' : ''}',
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
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
    final repsController =
        TextEditingController(text: set.repetitions.toString());
    final usesWeights = set.exercise.usesWeights;
    final weightController = usesWeights
        ? TextEditingController(text: set.weight?.toString() ?? '')
        : null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete set'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Repetitions',
              ),
            ),
            const SizedBox(height: 12),
            if (usesWeights)
              TextField(
                controller: weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  helperText: 'Required for weighted exercises',
                ),
              )
            else
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'This exercise is bodyweight only',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid repetitions')),
      );
      return;
    }
    double? weight;
    if (usesWeights) {
      final weightText = weightController!.text.trim();
      if (weightText.isNotEmpty) {
        weight = double.tryParse(weightText);
        if (weight == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter valid weight')),
          );
          return;
        }
      } else if (set.weight == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Weight required for this exercise')),
        );
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
                'Session: ${_session.training.name}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              if (sets.isEmpty)
                const Text('No sets in this session')
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
                        '${set.repetitions} reps'
                        '${set.exercise.usesWeights && set.weight != null ? ' @ ${set.weight}' : ''}',
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          if (set.done)
                            TextButton(
                              onPressed: () => _undoSet(set),
                              child: const Text('Undo'),
                            ),
                          TextButton(
                            onPressed: () => _completeSet(set),
                            child: Text(set.done ? 'Update' : 'Complete'),
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
                      child: const Text('Finish session'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelSession,
                      child: const Text('Cancel session'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
