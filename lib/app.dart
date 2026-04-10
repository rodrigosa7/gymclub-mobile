import 'package:flutter/material.dart';

import 'core/api/gymclub_api_client.dart';
import 'features/workout/presentation/app_controller.dart';
import 'features/workout/presentation/home_page.dart';

class GymClubTestApp extends StatefulWidget {
  const GymClubTestApp({super.key, required this.apiBaseUrl});

  final String apiBaseUrl;

  @override
  State<GymClubTestApp> createState() => _GymClubTestAppState();
}

class _GymClubTestAppState extends State<GymClubTestApp> {
  late final AppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppController(
      api: GymClubApiClient(baseUrl: widget.apiBaseUrl),
    )..initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFDD6B20),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Gym Club Test App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF7F1E8),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF2A1F17),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFE8D9C8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD7C1AA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD7C1AA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
        ),
      ),
      home: HomePage(
        controller: _controller,
        apiBaseUrl: widget.apiBaseUrl,
      ),
    );
  }
}
