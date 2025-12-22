// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fit App';

  @override
  String get tabWorkouts => 'Workouts';

  @override
  String get tabExercises => 'Exercises';

  @override
  String get searchHint => 'Search';

  @override
  String get historyButton => 'History';

  @override
  String get calendarButton => 'Calendar';

  @override
  String get dashboardTooltip => 'Open dashboard';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardCategories => 'Categories';

  @override
  String get historyViewList => 'List';

  @override
  String get historyViewCalendar => 'Calendar';

  @override
  String get noWorkouts => 'No workouts yet';

  @override
  String get noExercises => 'No exercises yet';

  @override
  String get sessionHistoryTitle => 'Session history';

  @override
  String get sessionHistoryEmpty => 'No completed sessions yet';

  @override
  String get sessionCalendarTitle => 'Session calendar';

  @override
  String get sessionCalendarEmpty => 'No completed sessions yet';

  @override
  String sessionsOnDay(String date) {
    return 'Sessions on $date';
  }

  @override
  String get sessionDayEmpty => 'No sessions on this day';

  @override
  String get noTechniqueDescription => 'No technique description';

  @override
  String get noNotes => 'No notes';

  @override
  String startedLabel(String date) {
    return 'Started $date';
  }

  @override
  String finishedLabel(String date) {
    return 'Finished $date';
  }

  @override
  String get languageSelectorTooltip => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Russian';

  @override
  String get fabActiveSessionTooltip => 'View active session';

  @override
  String get deleteExerciseTitle => 'Delete exercise';

  @override
  String deleteExerciseMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get deleteWorkoutTitle => 'Delete workout';

  @override
  String deleteWorkoutMessage(String name) {
    return 'Delete workout \"$name\"?';
  }

  @override
  String get cancelSessionTitle => 'Cancel session';

  @override
  String get cancelSessionMessage =>
      'Are you sure you want to cancel this session? Progress will be lost.';

  @override
  String get cancelSessionKeep => 'Keep session';

  @override
  String get cancelSessionConfirm => 'Cancel session';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonDelete => 'Delete';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonClose => 'Close';

  @override
  String get buttonStartSession => 'Start session';

  @override
  String get buttonEditWorkout => 'Edit workout';

  @override
  String get buttonDeleteWorkout => 'Delete workout';

  @override
  String get buttonEditExercise => 'Edit exercise';

  @override
  String get buttonDeleteExercise => 'Delete exercise';

  @override
  String get buttonUndo => 'Undo';

  @override
  String get buttonFinishSession => 'Finish session';

  @override
  String get buttonCancelSession => 'Cancel session';

  @override
  String get noPlannedSets => 'No planned sets for this training';

  @override
  String get noLinksAttached => 'No links attached';

  @override
  String get errorUnableToOpenLink => 'Unable to open link';

  @override
  String get errorUnableToLoadPhoto => 'Unable to load photo';

  @override
  String get sessionSummaryEmpty => 'No sets were tracked in this session';

  @override
  String get sessionSummaryTitle => 'Completed session summary';

  @override
  String get completeSetTitle => 'Complete set';

  @override
  String get errorEnterValidRepetitions => 'Enter valid repetitions';

  @override
  String get errorEnterValidWeight => 'Enter valid weight';

  @override
  String get errorWeightRequired => 'Weight required for this exercise';

  @override
  String get emptySessionSets => 'No sets in this session';

  @override
  String get errorFinishSession => 'Unable to finish session';

  @override
  String get errorCancelSession => 'Unable to cancel session';

  @override
  String get errorCompleteSet => 'Unable to complete set';

  @override
  String get errorUndoSet => 'Unable to undo set';

  @override
  String get labelRepetitions => 'Repetitions';

  @override
  String get labelWeight => 'Weight';

  @override
  String get helperWeightedExercise => 'Required for weighted exercises';

  @override
  String get bodyweightOnly => 'This exercise is bodyweight only';

  @override
  String sessionSheetTitle(String name) {
    return 'Session: $name';
  }

  @override
  String get deletedTrainingName => 'Deleted training';

  @override
  String get categoriesSheetTitle => 'Categories';

  @override
  String get categoriesEmpty => 'No categories yet';

  @override
  String get categoryFormTitle => 'Create category';

  @override
  String get categoryNameLabel => 'Category name';

  @override
  String get categoryColorLabel => 'Color';

  @override
  String get categoryCreateButton => 'Create category';

  @override
  String get categoryPickColorButton => 'Choose color';

  @override
  String get categoryColorPickerTitle => 'Pick a color';

  @override
  String get messageCategoryCreated => 'Category created';

  @override
  String get categoryEditDialogTitle => 'Edit category';

  @override
  String get categoryActionEdit => 'Edit';

  @override
  String get categoryDeleteDialogTitle => 'Delete category';

  @override
  String categoryDeleteConfirmation(String name) {
    return 'Delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get messageCategoryUpdated => 'Category updated';

  @override
  String get messageCategoryDeleted => 'Category deleted';

  @override
  String get errorCategoryNameRequired => 'Enter category name';

  @override
  String get errorCreateCategory => 'Unable to create category';

  @override
  String get errorUpdateCategory => 'Unable to update category';

  @override
  String get errorDeleteCategory => 'Unable to delete category';

  @override
  String get sectionPhoto => 'Photo';

  @override
  String get sectionTechnique => 'Technique';

  @override
  String get sectionNotes => 'Notes';

  @override
  String get sectionLinks => 'Links';

  @override
  String get exerciseUsesWeights => 'Uses weights';

  @override
  String get exerciseBodyweight => 'Bodyweight / no weights';

  @override
  String plannedSetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planned sets',
      one: '$count planned set',
    );
    return '$_temp0';
  }

  @override
  String completedSetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count completed sets',
      one: '$count completed set',
    );
    return '$_temp0';
  }

  @override
  String get buttonUpdate => 'Update';

  @override
  String get buttonComplete => 'Complete';

  @override
  String repetitionsWithUnit(int count) {
    return '$count reps';
  }

  @override
  String weightDisplay(String weight) {
    return '@ $weight';
  }

  @override
  String get errorEnterTrainingName => 'Enter training name';

  @override
  String get errorFillSets =>
      'Fill all new sets with valid exercises and repetitions';

  @override
  String get errorTrainingNeedsSet =>
      'Training must have at least one planned set';

  @override
  String get errorAddAtLeastOneSet => 'Add at least one set';

  @override
  String get editTrainingTitle => 'Edit Training';

  @override
  String get createTrainingTitle => 'Create Training';

  @override
  String get labelTrainingName => 'Training name';

  @override
  String get existingSetsLabel => 'Existing sets';

  @override
  String get newSetsLabel => 'New sets';

  @override
  String get setsLabel => 'Sets';

  @override
  String get labelExercise => 'Exercise';

  @override
  String get actionKeep => 'Keep';

  @override
  String get actionRemove => 'Remove';

  @override
  String get buttonAddSet => 'Add set';

  @override
  String get buttonAddNewSet => 'Add new set';

  @override
  String get buttonSaveChanges => 'Save changes';

  @override
  String get buttonAddTraining => 'Add';
}
