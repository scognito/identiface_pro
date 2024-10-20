import 'package:face_detector/locator.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/screens/recognize/widgets/bottom_sheet_settings_viewmodel.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/event_bus.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class BottomSheetCameraSettingsViewmodel extends FutureViewModel {
  final _camera = locator.get<CameraService>();
  final _storage = locator.get<StorageService>();
  final _bus = locator.get<EventBus>();

  int _cameraCount = 0;

  int get cameraCount => _cameraCount;

  final BuildContext context;

  BottomSheetCameraSettingsViewmodel({required this.context});

  @override
  Future futureToRun() async {
    _cameraCount = await _camera.getCameraCount();
    debugPrint('Camera count: $_cameraCount');
  }

  void changeCamera() {
    //await _camera.changeCamera();
    _bus.fire(EventBusEvent.cameraSwitch);
  }

  Future<void> changeOrientation() async {
    debugPrint('Changing camera orientation');
    await _camera.changeOrientation();
    if (context.mounted) {
      Provider.of<SettingsProvider>(context, listen: false)
          .setCameraOrientation(_camera.getCameraOrientation());
      await _storage.setCameraOrientation(_camera.getCameraOrientation());
    }
  }

  Future<void> toggleLockCamera() async {
    bool cameraLocked = _camera.isCameraLocked();
    await _camera.setCameraLocked(!cameraLocked);
    await _storage.setLockOrientation(!cameraLocked);
    notifyListeners();
  }

  bool isCameraLocked() {
    return _camera.isCameraLocked();
  }

  bool hasFeature(CameraFeature feature) {
    return _camera.hasFeature(feature);
  }

  void closeBottomSheet() {
    context.pop(SheetOperation(SheetOperationType.close));
  }
}
