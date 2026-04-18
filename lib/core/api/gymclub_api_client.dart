import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/workout/data/models/user_profile.dart';
import '../../features/workout/data/models/exercise.dart';
import '../../features/workout/data/models/routine.dart';
import '../../features/workout/data/models/workout_session.dart';
import '../../features/workout/data/models/analytics_overview.dart';

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class AuthResult {
  AuthResult({required this.accessToken, required this.user});

  final String accessToken;
  final UserProfile user;
}

class GymClubApiClient {
  GymClubApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  String? _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  String? get accessToken => _accessToken;

  bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;

  void dispose() {
    _client.close();
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String preferredWeightUnit,
  }) async {
    final payload = await _post('/api/auth/register', <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'preferredWeightUnit': preferredWeightUnit,
    });

    final data = Map<String, dynamic>.from(payload as Map);
    final token = data['accessToken'] as String;
    _accessToken = token;

    return AuthResult(
      accessToken: token,
      user: UserProfile.fromJson(Map<String, dynamic>.from(data['user'] as Map)),
    );
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final payload = await _post('/api/auth/login', <String, dynamic>{
      'email': email,
      'password': password,
    });

    final data = Map<String, dynamic>.from(payload as Map);
    final token = data['accessToken'] as String;
    _accessToken = token;

    return AuthResult(
      accessToken: token,
      user: UserProfile.fromJson(Map<String, dynamic>.from(data['user'] as Map)),
    );
  }

  Future<void> logout() async {
    _accessToken = null;
  }

  Future<UserProfile> fetchCurrentUser() async {
    final payload = await _get('/api/me');
    return UserProfile.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<List<Exercise>> fetchExercises() async {
    final payload = await _get('/api/exercises');
    return _parseList(payload, Exercise.fromJson);
  }

  Future<List<Routine>> fetchRoutines() async {
    final payload = await _get('/api/routines');
    return _parseList(payload, Routine.fromJson);
  }

  Future<WorkoutSession?> fetchActiveWorkout() async {
    final payload = await _get('/api/workouts/active');

    if (payload == null) {
      return null;
    }

    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<List<WorkoutSession>> fetchHistory() async {
    final payload = await _get('/api/history');
    return _parseList(payload, WorkoutSession.fromJson);
  }

  Future<AnalyticsOverview> fetchAnalyticsOverview() async {
    final payload = await _get('/api/analytics/overview');
    return AnalyticsOverview.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> startWorkoutFromRoutine(String routineId) async {
    final payload = await _post('/api/workouts/start', <String, dynamic>{
      'routineId': routineId,
    });
    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> addWorkoutSet({
    required String workoutId,
    required String workoutExerciseId,
    int? reps,
    double? weightKg,
    int? rir,
  }) async {
    final payload = await _post(
      '/api/workouts/$workoutId/exercises/$workoutExerciseId/sets',
      <String, dynamic>{
        'reps': reps,
        'weightKg': weightKg,
        'rir': rir,
      },
    );

    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> updateWorkoutSet({
    required String workoutId,
    required String workoutExerciseId,
    required String setId,
    required int? reps,
    required double? weightKg,
    int? rir,
    bool? isComplete,
    String? type,
  }) async {
    final data = <String, dynamic>{
      'reps': reps,
      'weightKg': weightKg,
      'rir': rir,
    };
    if (isComplete != null) {
      data['isComplete'] = isComplete;
    }
    if (type != null) {
      data['type'] = type;
    }
    final payload = await _patch(
      '/api/workouts/$workoutId/exercises/$workoutExerciseId/sets/$setId',
      data,
    );

    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> completeWorkout(String workoutId) async {
    final payload = await _post('/api/workouts/$workoutId/complete', const <String, dynamic>{});
    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> removeWorkoutSet({
    required String workoutId,
    required String workoutExerciseId,
    required String setId,
  }) async {
    final payload = await _delete(
      '/api/workouts/$workoutId/exercises/$workoutExerciseId/sets/$setId',
    );

    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> removeWorkoutExercise({
    required String workoutId,
    required String workoutExerciseId,
  }) async {
    final payload = await _delete(
      '/api/workouts/$workoutId/exercises/$workoutExerciseId',
    );

    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> syncWorkout({
    required String workoutId,
    required String name,
    required String notes,
    required List<Map<String, dynamic>> exercises,
  }) async {
    final payload = await _put(
      '/api/workouts/$workoutId',
      <String, dynamic>{
        'name': name,
        'notes': notes,
        'exercises': exercises,
      },
    );

    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> saveCompletedWorkout({
    required String name,
    required String notes,
    required DateTime startedAt,
    required DateTime completedAt,
    required List<Map<String, dynamic>> exercises,
  }) async {
    final payload = await _post(
      '/api/workouts',
      <String, dynamic>{
        'name': name,
        'notes': notes,
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt.toIso8601String(),
        'exercises': exercises,
      },
    );

    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<Object?> _get(String path) async {
    final response = await _client.get(_uri(path), headers: _headers);
    return _decodeResponse(response);
  }

  Future<Object?> _post(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Future<Object?> _patch(String path, Map<String, dynamic> body) async {
    final response = await _client.patch(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Future<Object?> _delete(String path) async {
    final response = await _client.delete(
      _uri(path),
      headers: _headers,
    );
    return _decodeResponse(response);
  }

  Future<Object?> _put(String path, Map<String, dynamic> body) async {
    final response = await _client.put(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Object? _decodeResponse(http.Response response) {
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded['data'];
    }

    final error = Map<String, dynamic>.from(decoded['error'] as Map? ?? const {});
    throw ApiException(
      error['message'] as String? ?? 'Request failed.',
      response.statusCode,
    );
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  List<T> _parseList<T>(
    Object? payload,
    T Function(Map<String, dynamic> json) mapper,
  ) {
    final raw = payload as List<dynamic>? ?? <dynamic>[];
    return raw
        .map((item) => mapper(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }
}
