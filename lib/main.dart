import 'package:fit_app/adapters/models.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'providers.dart';
import 'domain/logs.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  logger.i("Application started");
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      ExerciseModelSchema,
      SessionModelSchema,
      TrainingModelSchema,
      WorkoutSetModelSchema,
      PlannedSetModelSchema,
    ],
    directory: dir.path,
  );
  runApp(FitApp(isar: isar));
}

class FitApp extends StatelessWidget {
  const FitApp({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildAppProviders(isar),
      child: MaterialApp(
        title: 'Fit App',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
