import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GymClubTestApp(apiBaseUrl: _resolveApiBaseUrl()));
}

String _resolveApiBaseUrl() {
  const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

  if (configuredBaseUrl.isNotEmpty) {
    return configuredBaseUrl;
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:4000';
  }

  return 'http://127.0.0.1:4000';
}
