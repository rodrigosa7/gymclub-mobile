import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class GymClubApiClient {
  GymClubApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  void dispose() {
    _client.close();
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
    required int? reps,
    required double? weightKg,
    int? rir,
  }) async {
    final payload = await _post(
      '/api/workouts/$workoutId/exercises/$workoutExerciseId/sets',
      <String, dynamic>{
        'reps': reps,
        'weightKg': weightKg,
        'rir': rir,
        'isComplete': true,
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
  }) async {
    final payload = await _patch(
      '/api/workouts/$workoutId/exercises/$workoutExerciseId/sets/$setId',
      <String, dynamic>{
        'reps': reps,
        'weightKg': weightKg,
        'rir': rir,
        'isComplete': true,
      },
    );

    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<WorkoutSession> completeWorkout(String workoutId) async {
    final payload = await _post('/api/workouts/$workoutId/complete', const <String, dynamic>{});
    return WorkoutSession.fromJson(Map<String, dynamic>.from(payload as Map));
  }

  Future<Object?> _get(String path) async {
    final response = await _client.get(_uri(path));
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

  Map<String, String> get _headers => const <String, String>{
        'Content-Type': 'application/json',
      };
}
