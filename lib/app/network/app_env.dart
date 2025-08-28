import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }
    return '.env.development';
  }

  static String get apiUrl {
    return dotenv.env["API_URL"] ?? 'API_URL not found';
  }

  static String get apiUsername {
    return dotenv.env["API_USER_NAME"] ?? 'API_USER_NAME not found';
  }

  static String get apiPassword {
    return dotenv.env["API_PASSWORD"] ?? 'API_PASSWORD not found';
  }
}
