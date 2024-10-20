import 'dart:async';

import 'package:face_detector/config/assets.dart';
import 'package:face_detector/config/constants.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class DialogRecognizeViewModel extends FutureViewModel {
  final bool? found;
  final List<PhotoType> photos;
  final BuildContext context;

  DialogRecognizeViewModel({required this.context, required this.photos, required this.found});

  int currentIndex = 0;
  Timer? timer;

  PhotoType currentPhoto() {
    return photos[currentIndex];
  }

  PhotoType currentShiftedPhoto() {
    return photos[(currentIndex + 2) % photos.length];
  }

  @override
  Future<void> futureToRun() async {
    startRolling();
  }

  String getAssetFoundOrNot(String name) {
    String assetToFind = '$name.jpg';

    PhotoType? assetFound;
    try {
      assetFound = photos.firstWhere((element) => element.path == assetToFind);
    } catch (e) {
      debugPrint('Asset not found: $assetToFind');
    }

    if (assetFound != null) {
      return assetFound.path;
    }
    return Assets.imageCyborg;
  }

  String getLoadingMessage(bool? isFound) {
    if (isFound == null) {
      return CommonUtils.getLocalizedString(context, context.l10n.analyzing);
    }

    return isFound
        ? CommonUtils.getLocalizedString(context, 'Match!')
        : CommonUtils.getLocalizedString(context, 'No Match!');
  }

  String getNameFromAsset(String path) {
    return basename(path).split('.').first;
  }

  void startRolling() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      currentIndex++;
      if (currentIndex >= photos.length) {
        currentIndex = 0;
      }

      notifyListeners();
    });
  }

  bool showRollingFaces() {
    return Provider.of<SettingsProvider>(context, listen: false).getShowFacesOnRecognize();
  }

  BoxDecoration? getThemeDecoration() {
    String themeName = Provider.of<SettingsProvider>(context, listen: false).getThemeName();

    switch (themeName) {
      case kThemeDefault:
        return BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          image: const DecorationImage(
            image: AssetImage(Assets.imageRecognizeMatcher),
            fit: BoxFit.fill,
          ),
        );
      case kThemeMaterial:
        return BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        );
      default:
        return null;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

enum MediaType {
  asset,
  file,
}

class PhotoType {
  final String path;
  final MediaType type;

  const PhotoType({required this.path, required this.type});
}
