// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Fit App';

  @override
  String get tabWorkouts => 'Entrenamientos';

  @override
  String get tabExercises => 'Ejercicios';

  @override
  String get searchHint => 'Buscar';

  @override
  String get historyButton => 'Historial';

  @override
  String get calendarButton => 'Calendario';

  @override
  String get dashboardTooltip => '';

  @override
  String get dashboardTitle => '';

  @override
  String get dashboardCategories => 'Categorías';

  @override
  String get dashboardMuscles => 'Músculos';

  @override
  String get historyViewList => 'Lista';

  @override
  String get historyViewCalendar => 'Calendario';

  @override
  String get noWorkouts => 'Aún no hay entrenamientos';

  @override
  String get noExercises => 'Aún no hay ejercicios';

  @override
  String get sessionHistoryTitle => 'Historial de sesiones';

  @override
  String get sessionHistoryEmpty => 'Aún no hay sesiones completadas';

  @override
  String get sessionCalendarTitle => 'Calendario de sesiones';

  @override
  String get sessionCalendarEmpty => 'Aún no hay sesiones completadas';

  @override
  String sessionsOnDay(String date) {
    return 'Sesiones en $date';
  }

  @override
  String get sessionDayEmpty => 'No hay sesiones este día';

  @override
  String startedLabel(String date) {
    return 'Iniciado el $date';
  }

  @override
  String finishedLabel(String date) {
    return 'Finalizado el $date';
  }

  @override
  String get languageSelectorTooltip => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageRussian => 'Ruso';

  @override
  String get languageSpanish => 'Español';

  @override
  String get fabActiveSessionTooltip => 'Ver sesión activa';

  @override
  String get deleteExerciseTitle => 'Eliminar ejercicio';

  @override
  String deleteExerciseMessage(String name) {
    return '¿Seguro que quieres eliminar \"$name\"?';
  }

  @override
  String get deleteWorkoutTitle => 'Eliminar entrenamiento';

  @override
  String deleteWorkoutMessage(String name) {
    return '¿Eliminar el entrenamiento \"$name\"?';
  }

  @override
  String get cancelSessionTitle => 'Cancelar sesión';

  @override
  String get cancelSessionMessage =>
      '¿Seguro que quieres cancelar esta sesión? Se perderá el progreso.';

  @override
  String get cancelSessionKeep => 'Mantener sesión';

  @override
  String get cancelSessionConfirm => 'Cancelar sesión';

  @override
  String get buttonCancel => 'Cancelar';

  @override
  String get buttonDelete => 'Eliminar';

  @override
  String get buttonSave => 'Guardar';

  @override
  String get buttonClose => 'Cerrar';

  @override
  String get buttonStartSession => 'Iniciar sesión';

  @override
  String get buttonEditWorkout => 'Editar entrenamiento';

  @override
  String get buttonDeleteWorkout => 'Eliminar entrenamiento';

  @override
  String get buttonEditExercise => 'Editar ejercicio';

  @override
  String get buttonDeleteExercise => 'Eliminar ejercicio';

  @override
  String get buttonUndo => 'Deshacer';

  @override
  String get buttonFinishSession => 'Finalizar sesión';

  @override
  String get buttonCancelSession => 'Cancelar sesión';

  @override
  String get noPlannedSets =>
      'No hay series planificadas para este entrenamiento';

  @override
  String get errorUnableToOpenLink => 'No se puede abrir el enlace';

  @override
  String get errorUnableToLoadPhoto => 'No se puede cargar la foto';

  @override
  String get sessionSummaryEmpty => 'No se registraron series en esta sesión';

  @override
  String get sessionSummaryTitle => 'Resumen de sesión completada';

  @override
  String get completeSetTitle => 'Completar serie';

  @override
  String get errorEnterValidRepetitions => 'Ingresa repeticiones válidas';

  @override
  String get errorEnterValidWeight => 'Ingresa un peso válido';

  @override
  String get errorWeightRequired => 'Se requiere peso para este ejercicio';

  @override
  String get emptySessionSets => 'No hay series en esta sesión';

  @override
  String get errorFinishSession => 'No se puede finalizar la sesión';

  @override
  String get errorCancelSession => 'No se puede cancelar la sesión';

  @override
  String get errorCompleteSet => 'No se puede completar la serie';

  @override
  String get errorUndoSet => 'No se puede deshacer la serie';

  @override
  String get labelRepetitions => 'Repeticiones';

  @override
  String get labelWeight => 'Peso';

  @override
  String get helperWeightedExercise => 'Requerido para ejercicios con peso';

  @override
  String get bodyweightOnly => 'Este ejercicio es solo con el peso corporal';

  @override
  String get sessionSheetTitle => 'Sesión';

  @override
  String get sessionAddSetButton => 'Agregar serie';

  @override
  String get sessionAddSetTitle => 'Agregar serie de entrenamiento';

  @override
  String get sessionAddSetExerciseLabel => 'Ejercicio';

  @override
  String get sessionAddSetNoExercises => 'No hay ejercicios disponibles';

  @override
  String get sessionDeleteSetTitle => 'Eliminar serie de entrenamiento';

  @override
  String sessionDeleteSetMessage(Object exercise) {
    return '¿Quitar $exercise de esta sesión?';
  }

  @override
  String get categoriesSheetTitle => 'Categorías';

  @override
  String get categoriesEmpty => 'Aún no hay categorías';

  @override
  String get categoryFormTitle => 'Crear categoría';

  @override
  String get categoryNameLabel => 'Nombre de la categoría';

  @override
  String get categoryColorLabel => 'Color';

  @override
  String get categoryCreateButton => 'Crear categoría';

  @override
  String get categoryPickColorButton => 'Elegir color';

  @override
  String get categoryColorPickerTitle => 'Elegir un color';

  @override
  String get messageCategoryCreated => 'Categoría creada';

  @override
  String get categoryEditDialogTitle => 'Editar categoría';

  @override
  String get categoryActionEdit => 'Editar';

  @override
  String get categoryDeleteDialogTitle => 'Eliminar categoría';

  @override
  String categoryDeleteConfirmation(String name) {
    return '¿Eliminar \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get messageCategoryUpdated => 'Categoría actualizada';

  @override
  String get messageCategoryDeleted => 'Categoría eliminada';

  @override
  String get errorCategoryNameRequired => 'Ingresa el nombre de la categoría';

  @override
  String get errorCreateCategory => 'No se puede crear la categoría';

  @override
  String get errorUpdateCategory => 'No se puede actualizar la categoría';

  @override
  String get errorDeleteCategory => 'No se puede eliminar la categoría';

  @override
  String get sectionPhoto => 'Foto';

  @override
  String get sectionTechnique => 'Técnica';

  @override
  String get sectionNotes => 'Notas';

  @override
  String get sectionLinks => 'Enlaces';

  @override
  String get exerciseFormCreateTitle => 'Crear ejercicio';

  @override
  String get exerciseFormEditTitle => 'Editar ejercicio';

  @override
  String get exerciseFormNameLabel => 'Nombre del ejercicio';

  @override
  String get errorExerciseNameRequired => 'Ingresa el nombre del ejercicio';

  @override
  String get exerciseFormNoPhoto => 'No se seleccionó ninguna foto';

  @override
  String get exerciseFormAddPhoto => 'Agregar foto';

  @override
  String get exerciseFormChangePhoto => 'Cambiar foto';

  @override
  String get exerciseFormRemovePhoto => 'Eliminar foto';

  @override
  String get exerciseFormTechniqueLabel => 'Descripción de la técnica';

  @override
  String get exerciseFormNotesLabel => 'Notas';

  @override
  String get exerciseFormCategoriesLabel => 'Categorías';

  @override
  String get exerciseFormNoCategories => 'Aún no hay categorías';

  @override
  String exerciseFormLinkLabel(int index) {
    return 'Enlace $index';
  }

  @override
  String get exerciseFormAddLink => 'Agregar enlace';

  @override
  String get exerciseFormAddExercise => 'Agregar ejercicio';

  @override
  String get exerciseFormSaveChanges => 'Guardar cambios';

  @override
  String get exerciseUsesWeights => 'Usa peso';

  @override
  String get exerciseBodyweight => 'Peso corporal / sin peso';

  @override
  String plannedSetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series planificadas',
      one: '$count serie planificada',
    );
    return '$_temp0';
  }

  @override
  String completedSetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series completadas',
      one: '$count serie completada',
    );
    return '$_temp0';
  }

  @override
  String get buttonUpdate => 'Actualizar';

  @override
  String get buttonComplete => 'Completar';

  @override
  String repetitionsWithUnit(int count) {
    return '$count repeticiones';
  }

  @override
  String weightDisplay(String weight) {
    return '@ $weight';
  }

  @override
  String get errorEnterTrainingName => 'Ingresa el nombre del entrenamiento';

  @override
  String get errorFillSets =>
      'Completa todas las series nuevas con ejercicios y repeticiones válidos';

  @override
  String get errorTrainingNeedsSet =>
      'El entrenamiento debe tener al menos una serie planificada';

  @override
  String get errorAddAtLeastOneSet => 'Agrega al menos una serie';

  @override
  String get editTrainingTitle => 'Editar entrenamiento';

  @override
  String get createTrainingTitle => 'Crear entrenamiento';

  @override
  String get labelTrainingName => 'Nombre del entrenamiento';

  @override
  String get existingSetsLabel => 'Series existentes';

  @override
  String get newSetsLabel => 'Series nuevas';

  @override
  String get setsLabel => 'Series';

  @override
  String get labelExercise => 'Ejercicio';

  @override
  String get actionKeep => 'Mantener';

  @override
  String get actionRemove => 'Eliminar';

  @override
  String get buttonAddSet => 'Agregar serie';

  @override
  String get buttonAddNewSet => 'Agregar nueva serie';

  @override
  String get buttonSaveChanges => 'Guardar cambios';

  @override
  String get buttonAddTraining => 'Agregar';
}
