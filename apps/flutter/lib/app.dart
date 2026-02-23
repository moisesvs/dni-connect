import 'package:flutter/material.dart';
import 'package:dni_connect/core/theme/app_theme.dart';
import 'package:dni_connect/core/router/app_router.dart';

class DniConnectApp extends StatelessWidget {
  const DniConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DNI-Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
