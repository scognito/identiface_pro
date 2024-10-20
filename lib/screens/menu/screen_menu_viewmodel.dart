import 'package:face_detector/locator.dart';
import 'package:face_detector/app_router.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/widgets/dialog_warning/dialog_warning_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

class ScreenMenuViewModel extends BaseViewModel {
  final _storage = locator.get<StorageService>();

  final BuildContext context;

  ScreenMenuViewModel({required this.context}) {
    showWarning();
  }

  Future<void> showWarning() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) {
      showDialog<String>(
        context: context,
        builder: (_) {
          return const DialogWarningView();
        },
      );
    }
  }

  Future<void> navigateToRecognize() async {
    if (context.mounted) {
      await context.push(Routes.recognize);
    }
  }

  Future<void> navigateToSettings() async {
    if (context.mounted) {
      await context.push(Routes.settings);
    }

    if (_storage.getMasterPassword().isNotEmpty) {
      if (context.mounted) {
        context.pushReplacement(Routes.recognize);
      }
    }
  }
}
