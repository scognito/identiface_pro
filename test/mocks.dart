import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/services/api_service.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/database_service.dart';
import 'package:face_detector/services/event_bus.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  Dio,
  SharedPreferences,
  DatabaseService,
  StorageService,
  ApiService,
  DatabaseClient,
  SettingsProvider,
  EventBus,
  CameraService,
])
void main() {
  debugPrint('Generated mocks');
}
