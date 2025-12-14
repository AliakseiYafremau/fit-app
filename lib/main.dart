import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'application/di/providers.dart';
import 'domain/logs.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/theme.dart';

void main() {
  logger.i("Application started");
  runApp(const FitApp());
}

class FitApp extends StatelessWidget {
  const FitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        title: 'Fit App',
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
