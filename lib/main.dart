import 'dart:io';

import 'package:fit_app/adapters/models.dart';
import 'package:fit_app/presentation/providers/locale_controller.dart';
import 'package:fit_app/presentation/scaffold_messenger_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fit_app/l10n/app_localizations.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';
import 'domain/logs.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  logger.i("Application started");
  final dir = await getApplicationDocumentsDirectory();
  final prefs = await SharedPreferences.getInstance();
  final localeCode = prefs.getString('preferred_locale');
  final initialLocale =
      localeCode != null && localeCode.isNotEmpty ? Locale(localeCode) : null;
  final isar = await Isar.open(
    [
      ExerciseModelSchema,
      CategoryModelSchema,
      SessionModelSchema,
      TrainingModelSchema,
      WorkoutSetModelSchema,
      PlannedSetModelSchema,
    ],
    directory: dir.path,
  );
  runApp(FitApp(
    isar: isar,
    appDirectory: dir,
    sharedPreferences: prefs,
    initialLocale: initialLocale,
  ));
}

class FitApp extends StatelessWidget {
  const FitApp({
    super.key,
    required this.isar,
    required this.appDirectory,
    required this.sharedPreferences,
    required this.initialLocale,
  });

  final Isar isar;
  final Directory appDirectory;
  final SharedPreferences sharedPreferences;
  final Locale? initialLocale;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...buildAppProviders(isar, appDirectory),
        ChangeNotifierProvider(
          create: (_) =>
              LocaleController(sharedPreferences, initialLocale),
        ),
      ],
      child: Consumer<LocaleController>(
        builder: (context, localeController, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeController.locale,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ),
      ),
    );
  }
}
