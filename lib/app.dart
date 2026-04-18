import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/gymclub_api_client.dart';
import 'core/theme/gymclub_theme.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/workout/presentation/app_controller.dart';
import 'features/workout/presentation/home_page.dart';

const _tokenKey = 'auth_token';

class GymClubTestApp extends StatefulWidget {
  const GymClubTestApp({super.key, required this.apiBaseUrl});

  final String apiBaseUrl;

  @override
  State<GymClubTestApp> createState() => _GymClubTestAppState();
}

class _GymClubTestAppState extends State<GymClubTestApp> {
  late final GymClubApiClient _api;
  late final AppController _appController;
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _api = GymClubApiClient(baseUrl: widget.apiBaseUrl);
    _appController = AppController(api: _api);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token != null && token.isNotEmpty) {
        _api.setAccessToken(token);
        if (_api.isAuthenticated) {
          _isAuthenticated = true;
          _appController.initialize();
        }
      }
    } catch (e) {
      debugPrint('Storage init error: $e');
      // Continue without storage - user will need to login again
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogin() async {
    debugPrint('HANDLE_LOGIN: starting');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = _api.accessToken;
      debugPrint('HANDLE_LOGIN: token = $token');
      if (token != null) {
        await prefs.setString(_tokenKey, token);
      }
    } catch (e) {
      debugPrint('Login storage error: $e');
    }

    debugPrint('HANDLE_LOGIN: calling appController.initialize');
    _appController.initialize();

    debugPrint('HANDLE_LOGIN: setting _isAuthenticated = true, _isLoading = false');
    debugPrint('HANDLE_LOGIN: mounted = $mounted');
    if (mounted) {
      setState(() {
        _isAuthenticated = true;
        _isLoading = false;
      });
      debugPrint('HANDLE_LOGIN: setState called');
    }
  }

  Future<void> _handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      debugPrint('Logout storage error: $e');
    }
    _api.logout();

    if (mounted) {
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  @override
  void dispose() {
    _appController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Club',
      theme: GymClubTheme.darkTheme,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    debugPrint('BUILD_HOME: _isLoading=$_isLoading, _isAuthenticated=$_isAuthenticated');
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_isAuthenticated) {
      debugPrint('BUILD_HOME: showing HomePage');
      return HomePage(
        controller: _appController,
        apiBaseUrl: widget.apiBaseUrl,
        onLogout: _handleLogout,
      );
    }

    debugPrint('BUILD_HOME: showing LoginPage');
    return LoginPage(
      api: _api,
      onLogin: _handleLogin,
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: GymClubTheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: GymClubTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: GymClubTheme.onPrimaryFixed,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'GYM CLUB',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: GymClubTheme.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: GymClubTheme.primary,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                color: GymClubTheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}