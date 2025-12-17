// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Fit App';

  @override
  String get tabWorkouts => 'Тренировки';

  @override
  String get tabExercises => 'Упражнения';

  @override
  String get searchHint => 'Поиск';

  @override
  String get historyButton => 'История';

  @override
  String get calendarButton => 'Календарь';

  @override
  String get historyViewList => 'Список';

  @override
  String get historyViewCalendar => 'Календарь';

  @override
  String get noWorkouts => 'Тренировок пока нет';

  @override
  String get noExercises => 'Упражнений пока нет';

  @override
  String get sessionHistoryTitle => 'История сессий';

  @override
  String get sessionHistoryEmpty => 'Завершённых сессий пока нет';

  @override
  String get sessionCalendarTitle => 'Календарь сессий';

  @override
  String get sessionCalendarEmpty => 'Завершённых сессий пока нет';

  @override
  String sessionsOnDay(String date) {
    return 'Сессии на $date';
  }

  @override
  String get sessionDayEmpty => 'В этот день сессий не было';

  @override
  String get noTechniqueDescription => 'Описание техники отсутствует';

  @override
  String get noNotes => 'Заметок нет';

  @override
  String startedLabel(String date) {
    return 'Начало $date';
  }

  @override
  String finishedLabel(String date) {
    return 'Окончание $date';
  }

  @override
  String get languageSelectorTooltip => 'Язык';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageRussian => 'Русский';

  @override
  String get fabActiveSessionTooltip => 'Активная сессия';

  @override
  String get deleteExerciseTitle => 'Удалить упражнение';

  @override
  String deleteExerciseMessage(String name) {
    return 'Удалить упражнение «$name»?';
  }

  @override
  String get deleteWorkoutTitle => 'Удалить тренировку';

  @override
  String deleteWorkoutMessage(String name) {
    return 'Удалить тренировку «$name»?';
  }

  @override
  String get cancelSessionTitle => 'Отменить сессию';

  @override
  String get cancelSessionMessage =>
      'Точно отменить сессию? Прогресс будет потерян.';

  @override
  String get cancelSessionKeep => 'Оставить';

  @override
  String get cancelSessionConfirm => 'Отменить сессию';

  @override
  String get buttonCancel => 'Отмена';

  @override
  String get buttonDelete => 'Удалить';

  @override
  String get buttonSave => 'Сохранить';

  @override
  String get buttonClose => 'Закрыть';

  @override
  String get buttonStartSession => 'Начать сессию';

  @override
  String get buttonEditWorkout => 'Изменить';

  @override
  String get buttonDeleteWorkout => 'Удалить';

  @override
  String get buttonEditExercise => 'Изменить';

  @override
  String get buttonDeleteExercise => 'Удалить';

  @override
  String get buttonUndo => 'Отменить';

  @override
  String get buttonFinishSession => 'Завершить сессию';

  @override
  String get buttonCancelSession => 'Отменить сессию';

  @override
  String get noPlannedSets => 'У этой тренировки нет планов';

  @override
  String get noLinksAttached => 'Ссылок нет';

  @override
  String get errorUnableToOpenLink => 'Не удалось открыть ссылку';

  @override
  String get errorUnableToLoadPhoto => 'Не удалось загрузить фото';

  @override
  String get sessionSummaryEmpty => 'В этой сессии не отслеживались подходы';

  @override
  String get sessionSummaryTitle => 'Итоги сессии';

  @override
  String get completeSetTitle => 'Завершение подхода';

  @override
  String get errorEnterValidRepetitions =>
      'Введите корректное количество повторений';

  @override
  String get errorEnterValidWeight => 'Введите корректный вес';

  @override
  String get errorWeightRequired => 'Для этого упражнения нужен вес';

  @override
  String get emptySessionSets => 'В этой сессии нет подходов';

  @override
  String get errorFinishSession => 'Не удалось завершить сессию';

  @override
  String get errorCancelSession => 'Не удалось отменить сессию';

  @override
  String get errorCompleteSet => 'Не удалось завершить подход';

  @override
  String get errorUndoSet => 'Не удалось отменить подход';

  @override
  String get labelRepetitions => 'Повторения';

  @override
  String get labelWeight => 'Вес';

  @override
  String get helperWeightedExercise => 'Нужно для упражнений с весом';

  @override
  String get bodyweightOnly => 'Это упражнение только с собственным весом';

  @override
  String sessionSheetTitle(String name) {
    return 'Сессия: $name';
  }

  @override
  String get sectionPhoto => 'Фото';

  @override
  String get sectionTechnique => 'Техника';

  @override
  String get sectionNotes => 'Заметки';

  @override
  String get sectionLinks => 'Ссылки';

  @override
  String get exerciseUsesWeights => 'С весами';

  @override
  String get exerciseBodyweight => 'Без веса / собственный вес';

  @override
  String plannedSetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запланированных подходов',
      many: '$count запланированных подходов',
      few: '$count запланированных подхода',
      one: '$count запланированный подход',
    );
    return '$_temp0';
  }

  @override
  String completedSetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завершённых подходов',
      many: '$count завершённых подходов',
      few: '$count завершённых подхода',
      one: '$count завершённый подход',
    );
    return '$_temp0';
  }

  @override
  String get buttonUpdate => 'Обновить';

  @override
  String get buttonComplete => 'Завершить';

  @override
  String repetitionsWithUnit(int count) {
    return '$count повт.';
  }

  @override
  String weightDisplay(String weight) {
    return '@ $weight';
  }

  @override
  String get errorEnterTrainingName => 'Введите название тренировки';

  @override
  String get errorFillSets =>
      'Заполните новые подходы корректными упражнениями и повторениями';

  @override
  String get errorTrainingNeedsSet =>
      'В тренировке должен быть хотя бы один подход';

  @override
  String get errorAddAtLeastOneSet => 'Добавьте хотя бы один подход';

  @override
  String get editTrainingTitle => 'Редактирование тренировки';

  @override
  String get createTrainingTitle => 'Создание тренировки';

  @override
  String get labelTrainingName => 'Название тренировки';

  @override
  String get existingSetsLabel => 'Существующие подходы';

  @override
  String get newSetsLabel => 'Новые подходы';

  @override
  String get setsLabel => 'Подходы';

  @override
  String get labelExercise => 'Упражнение';

  @override
  String get actionKeep => 'Оставить';

  @override
  String get actionRemove => 'Удалить';

  @override
  String get buttonAddSet => 'Добавить подход';

  @override
  String get buttonAddNewSet => 'Добавить новый подход';

  @override
  String get buttonSaveChanges => 'Сохранить изменения';

  @override
  String get buttonAddTraining => 'Добавить';
}
