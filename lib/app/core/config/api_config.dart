import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // TIMEOUTS
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 15000;

  // BASE URL LOGIC
  static String get baseUrl {
    // In release mode, you might want a hardcoded production URL or read from env if baked in
    if (kReleaseMode) {
      return "https://api.yourproduction.com";
    }

    // Read from .env, fallback to localhost if not set
    var url = dotenv.env['API_BASE_URL'] ?? "http://localhost:8000";

    // Android Emulator requires 10.0.2.2 to access the host machine
    if (Platform.isAndroid && url.contains("localhost")) {
      url = url.replaceAll("localhost", "10.0.2.2");
    }

    return url;
  }
}
