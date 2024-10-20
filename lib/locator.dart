import 'package:face_detector/services/api_service.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/database_service.dart';
import 'package:face_detector/services/event_bus.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocators() {
  locator.registerSingletonAsync<StorageService>(() async {
    final storageService = StorageService();
    await storageService.init();
    return storageService;
  });

  locator.registerSingletonWithDependencies<ApiService>(
    () {
      return ApiService();
    },
    dependsOn: [StorageService],
  );

  locator.registerSingleton<EventBus>(EventBus());

  locator.registerSingletonAsync<DatabaseService>(() async {
    final databaseService = DatabaseService();
    await databaseService.init();
    return databaseService;
  });

  locator.registerSingletonAsync<CameraService>(
    () async {
      final cameraService = CameraService();
      await cameraService.setupCameraController();
      return cameraService;
    },
    dependsOn: [StorageService],
  );
}
