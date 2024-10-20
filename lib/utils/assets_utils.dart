import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetsUtils {
  static Future<List<String>> getImagePaths(String assetsPath) async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestContent);
      final imagePaths = manifest.keys.where((String key) => key.startsWith(assetsPath)).toList();

      return imagePaths;
    } catch (e) {
      debugPrint('Error loading asset manifest: $e');
      return [];
    }
  }
}
