import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'navigation/app_router.dart';

class HandsFreeApp extends StatelessWidget {
  const HandsFreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp.router(
          title: 'HandsFree Messenger',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: currentMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
