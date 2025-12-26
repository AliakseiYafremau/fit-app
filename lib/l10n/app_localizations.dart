import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fit App'**
  String get appTitle;

  /// No description provided for @tabWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get tabWorkouts;

  /// No description provided for @tabExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get tabExercises;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @historyButton.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyButton;

  /// No description provided for @calendarButton.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarButton;

  /// No description provided for @dashboardTooltip.
  ///
  /// In en, this message translates to:
  /// **''**
  String get dashboardTooltip;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get dashboardTitle;

  /// No description provided for @dashboardCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get dashboardCategories;

  /// No description provided for @dashboardMuscles.
  ///
  /// In en, this message translates to:
  /// **'Muscles'**
  String get dashboardMuscles;

  /// No description provided for @historyViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get historyViewList;

  /// No description provided for @historyViewCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get historyViewCalendar;

  /// No description provided for @noWorkouts.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get noWorkouts;

  /// No description provided for @noExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises yet'**
  String get noExercises;

  /// No description provided for @sessionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session history'**
  String get sessionHistoryTitle;

  /// No description provided for @sessionHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No completed sessions yet'**
  String get sessionHistoryEmpty;

  /// No description provided for @sessionCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Session calendar'**
  String get sessionCalendarTitle;

  /// No description provided for @sessionCalendarEmpty.
  ///
  /// In en, this message translates to:
  /// **'No completed sessions yet'**
  String get sessionCalendarEmpty;

  /// No description provided for @sessionsOnDay.
  ///
  /// In en, this message translates to:
  /// **'Sessions on {date}'**
  String sessionsOnDay(String date);

  /// No description provided for @sessionDayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions on this day'**
  String get sessionDayEmpty;

  /// No description provided for @startedLabel.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String startedLabel(String date);

  /// No description provided for @finishedLabel.
  ///
  /// In en, this message translates to:
  /// **'Finished {date}'**
  String finishedLabel(String date);

  /// No description provided for @languageSelectorTooltip.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectorTooltip;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @fabActiveSessionTooltip.
  ///
  /// In en, this message translates to:
  /// **'View active session'**
  String get fabActiveSessionTooltip;

  /// No description provided for @deleteExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get deleteExerciseTitle;

  /// No description provided for @deleteExerciseMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteExerciseMessage(String name);

  /// No description provided for @deleteWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete workout'**
  String get deleteWorkoutTitle;

  /// No description provided for @deleteWorkoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete workout \"{name}\"?'**
  String deleteWorkoutMessage(String name);

  /// No description provided for @cancelSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel session'**
  String get cancelSessionTitle;

  /// No description provided for @cancelSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this session? Progress will be lost.'**
  String get cancelSessionMessage;

  /// No description provided for @cancelSessionKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep session'**
  String get cancelSessionKeep;

  /// No description provided for @cancelSessionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel session'**
  String get cancelSessionConfirm;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get buttonClose;

  /// No description provided for @buttonStartSession.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get buttonStartSession;

  /// No description provided for @buttonEditWorkout.
  ///
  /// In en, this message translates to:
  /// **'Edit workout'**
  String get buttonEditWorkout;

  /// No description provided for @buttonDeleteWorkout.
  ///
  /// In en, this message translates to:
  /// **'Delete workout'**
  String get buttonDeleteWorkout;

  /// No description provided for @buttonEditExercise.
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get buttonEditExercise;

  /// No description provided for @buttonDeleteExercise.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get buttonDeleteExercise;

  /// No description provided for @buttonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get buttonUndo;

  /// No description provided for @buttonFinishSession.
  ///
  /// In en, this message translates to:
  /// **'Finish session'**
  String get buttonFinishSession;

  /// No description provided for @buttonCancelSession.
  ///
  /// In en, this message translates to:
  /// **'Cancel session'**
  String get buttonCancelSession;

  /// No description provided for @noPlannedSets.
  ///
  /// In en, this message translates to:
  /// **'No planned sets for this training'**
  String get noPlannedSets;

  /// No description provided for @errorUnableToOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to open link'**
  String get errorUnableToOpenLink;

  /// No description provided for @errorUnableToLoadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Unable to load photo'**
  String get errorUnableToLoadPhoto;

  /// No description provided for @sessionSummaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sets were tracked in this session'**
  String get sessionSummaryEmpty;

  /// No description provided for @sessionSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed session summary'**
  String get sessionSummaryTitle;

  /// No description provided for @completeSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete set'**
  String get completeSetTitle;

  /// No description provided for @errorEnterValidRepetitions.
  ///
  /// In en, this message translates to:
  /// **'Enter valid repetitions'**
  String get errorEnterValidRepetitions;

  /// No description provided for @errorEnterValidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter valid weight'**
  String get errorEnterValidWeight;

  /// No description provided for @errorWeightRequired.
  ///
  /// In en, this message translates to:
  /// **'Weight required for this exercise'**
  String get errorWeightRequired;

  /// No description provided for @emptySessionSets.
  ///
  /// In en, this message translates to:
  /// **'No sets in this session'**
  String get emptySessionSets;

  /// No description provided for @errorFinishSession.
  ///
  /// In en, this message translates to:
  /// **'Unable to finish session'**
  String get errorFinishSession;

  /// No description provided for @errorCancelSession.
  ///
  /// In en, this message translates to:
  /// **'Unable to cancel session'**
  String get errorCancelSession;

  /// No description provided for @errorCompleteSet.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete set'**
  String get errorCompleteSet;

  /// No description provided for @errorUndoSet.
  ///
  /// In en, this message translates to:
  /// **'Unable to undo set'**
  String get errorUndoSet;

  /// No description provided for @labelRepetitions.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get labelRepetitions;

  /// No description provided for @labelWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get labelWeight;

  /// No description provided for @helperWeightedExercise.
  ///
  /// In en, this message translates to:
  /// **'Required for weighted exercises'**
  String get helperWeightedExercise;

  /// No description provided for @bodyweightOnly.
  ///
  /// In en, this message translates to:
  /// **'This exercise is bodyweight only'**
  String get bodyweightOnly;

  /// No description provided for @sessionSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get sessionSheetTitle;

  /// No description provided for @sessionAddSetButton.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get sessionAddSetButton;

  /// No description provided for @sessionAddSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add workout set'**
  String get sessionAddSetTitle;

  /// No description provided for @sessionAddSetExerciseLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get sessionAddSetExerciseLabel;

  /// No description provided for @sessionAddSetNoExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises available'**
  String get sessionAddSetNoExercises;

  /// No description provided for @sessionDeleteSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete workout set'**
  String get sessionDeleteSetTitle;

  /// No description provided for @sessionDeleteSetMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove {exercise} from this session?'**
  String sessionDeleteSetMessage(Object exercise);

  /// No description provided for @categoriesSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesSheetTitle;

  /// No description provided for @categoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get categoriesEmpty;

  /// No description provided for @categoryFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Create category'**
  String get categoryFormTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNameLabel;

  /// No description provided for @categoryColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get categoryColorLabel;

  /// No description provided for @categoryCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create category'**
  String get categoryCreateButton;

  /// No description provided for @categoryPickColorButton.
  ///
  /// In en, this message translates to:
  /// **'Choose color'**
  String get categoryPickColorButton;

  /// No description provided for @categoryColorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a color'**
  String get categoryColorPickerTitle;

  /// No description provided for @messageCategoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created'**
  String get messageCategoryCreated;

  /// No description provided for @categoryEditDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get categoryEditDialogTitle;

  /// No description provided for @categoryActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get categoryActionEdit;

  /// No description provided for @categoryDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get categoryDeleteDialogTitle;

  /// No description provided for @categoryDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This action cannot be undone.'**
  String categoryDeleteConfirmation(String name);

  /// No description provided for @messageCategoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated'**
  String get messageCategoryUpdated;

  /// No description provided for @messageCategoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted'**
  String get messageCategoryDeleted;

  /// No description provided for @errorCategoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get errorCategoryNameRequired;

  /// No description provided for @errorCreateCategory.
  ///
  /// In en, this message translates to:
  /// **'Unable to create category'**
  String get errorCreateCategory;

  /// No description provided for @errorUpdateCategory.
  ///
  /// In en, this message translates to:
  /// **'Unable to update category'**
  String get errorUpdateCategory;

  /// No description provided for @errorDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete category'**
  String get errorDeleteCategory;

  /// No description provided for @sectionPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get sectionPhoto;

  /// No description provided for @sectionTechnique.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get sectionTechnique;

  /// No description provided for @sectionNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get sectionNotes;

  /// No description provided for @sectionLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get sectionLinks;

  /// No description provided for @exerciseFormCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Exercise'**
  String get exerciseFormCreateTitle;

  /// No description provided for @exerciseFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Exercise'**
  String get exerciseFormEditTitle;

  /// No description provided for @exerciseFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise name'**
  String get exerciseFormNameLabel;

  /// No description provided for @errorExerciseNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter exercise name'**
  String get errorExerciseNameRequired;

  /// No description provided for @exerciseFormNoPhoto.
  ///
  /// In en, this message translates to:
  /// **'No photo selected'**
  String get exerciseFormNoPhoto;

  /// No description provided for @exerciseFormAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get exerciseFormAddPhoto;

  /// No description provided for @exerciseFormChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get exerciseFormChangePhoto;

  /// No description provided for @exerciseFormRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get exerciseFormRemovePhoto;

  /// No description provided for @exerciseFormTechniqueLabel.
  ///
  /// In en, this message translates to:
  /// **'Technique description'**
  String get exerciseFormTechniqueLabel;

  /// No description provided for @exerciseFormNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get exerciseFormNotesLabel;

  /// No description provided for @exerciseFormCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get exerciseFormCategoriesLabel;

  /// No description provided for @exerciseFormNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get exerciseFormNoCategories;

  /// No description provided for @exerciseFormLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Link {index}'**
  String exerciseFormLinkLabel(int index);

  /// No description provided for @exerciseFormAddLink.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get exerciseFormAddLink;

  /// No description provided for @exerciseFormAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get exerciseFormAddExercise;

  /// No description provided for @exerciseFormSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get exerciseFormSaveChanges;

  /// No description provided for @exerciseUsesWeights.
  ///
  /// In en, this message translates to:
  /// **'Uses weights'**
  String get exerciseUsesWeights;

  /// No description provided for @exerciseBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight / no weights'**
  String get exerciseBodyweight;

  /// No description provided for @plannedSetsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} planned set} other{{count} planned sets}}'**
  String plannedSetsCount(int count);

  /// No description provided for @completedSetsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} completed set} other{{count} completed sets}}'**
  String completedSetsCount(int count);

  /// No description provided for @buttonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get buttonUpdate;

  /// No description provided for @buttonComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get buttonComplete;

  /// No description provided for @repetitionsWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String repetitionsWithUnit(int count);

  /// No description provided for @weightDisplay.
  ///
  /// In en, this message translates to:
  /// **'@ {weight}'**
  String weightDisplay(String weight);

  /// No description provided for @errorEnterTrainingName.
  ///
  /// In en, this message translates to:
  /// **'Enter training name'**
  String get errorEnterTrainingName;

  /// No description provided for @errorFillSets.
  ///
  /// In en, this message translates to:
  /// **'Fill all new sets with valid exercises and repetitions'**
  String get errorFillSets;

  /// No description provided for @errorTrainingNeedsSet.
  ///
  /// In en, this message translates to:
  /// **'Training must have at least one planned set'**
  String get errorTrainingNeedsSet;

  /// No description provided for @errorAddAtLeastOneSet.
  ///
  /// In en, this message translates to:
  /// **'Add at least one set'**
  String get errorAddAtLeastOneSet;

  /// No description provided for @editTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Training'**
  String get editTrainingTitle;

  /// No description provided for @createTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Training'**
  String get createTrainingTitle;

  /// No description provided for @labelTrainingName.
  ///
  /// In en, this message translates to:
  /// **'Training name'**
  String get labelTrainingName;

  /// No description provided for @existingSetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Existing sets'**
  String get existingSetsLabel;

  /// No description provided for @newSetsLabel.
  ///
  /// In en, this message translates to:
  /// **'New sets'**
  String get newSetsLabel;

  /// No description provided for @setsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get setsLabel;

  /// No description provided for @labelExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get labelExercise;

  /// No description provided for @actionKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get actionKeep;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @buttonAddSet.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get buttonAddSet;

  /// No description provided for @buttonAddNewSet.
  ///
  /// In en, this message translates to:
  /// **'Add new set'**
  String get buttonAddNewSet;

  /// No description provided for @buttonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get buttonSaveChanges;

  /// No description provided for @buttonAddTraining.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get buttonAddTraining;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
