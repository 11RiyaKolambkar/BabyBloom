import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AppConfig {
  // Configurable base URL
  // Android Emulator uses 10.0.2.2 to access host machine's localhost:5000
  // Windows desktop and web use localhost:5000
  // On real physical device over Wi-Fi, change this to your computer's IP (e.g. 192.168.1.x)
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000";
    }
    try {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:5000";
      }
    } catch (_) {}
    return "http://localhost:5000";
  }

  // Helper to format full image URL from backend relative paths
  static String getImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      return "";
    }
    if (relativePath.startsWith("http://") || relativePath.startsWith("https://")) {
      return relativePath;
    }
    final cleanPath = relativePath.startsWith("/") ? relativePath : "/$relativePath";
    return "$baseUrl$cleanPath";
  }
}
