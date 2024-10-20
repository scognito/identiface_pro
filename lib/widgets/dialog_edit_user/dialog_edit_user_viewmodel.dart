import 'dart:convert';

import 'package:face_detector/locator.dart';
import 'package:face_detector/app_router.dart';
import 'package:face_detector/services/database_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/image_utils.dart';
import 'package:face_detector/utils/widget_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class DialogEditUserViewModel extends FutureViewModel {
  final _database = locator.get<DatabaseService>();

  final BuildContext context;
  final String? initialName;
  final bool isEditing;

  bool _isLoadingPhoto = false;

  bool get isLoadingPhoto => _isLoadingPhoto;

  bool newPictureAdded = false;

  final formKey = GlobalKey<FormState>();

  String _name = '';

  String get name => _name;

  late final ImagePicker _picker;

  // Using Uint8List to store the image bytes, so that it can be displayed in the UI
  // as a preview. I'm not using FileImage because it caches the image
  Uint8List? _fileBytes;

  Uint8List? get fileBytes => _fileBytes;

  bool _isMiniInputDialog = false;

  bool get isMiniInputDialog => _isMiniInputDialog;

  DialogEditUserViewModel({
    required this.context,
    required this.isEditing,
    required this.initialName,
  }) {
    _picker = ImagePicker();
  }

  @override
  Future<void> futureToRun() async {
    if (isEditing) {
      _name = initialName!;

      String? imageData = await _database.getItemByKey(DatabaseService.usersStoreName, _name);
      if (imageData != null) {
        _fileBytes = base64Decode(imageData);
      }
    }
    debugPrint('Alert loaded');
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (context.mounted) {
        Image? ret = await context.push(Routes.crop, extra: pickedFile.path);

        // the image was cropped
        if (ret != null) {
          _fileBytes = null;
          _isLoadingPhoto = true;
          notifyListeners();

          _fileBytes = await ImageUtils.convertImageToBytes(ret);
          newPictureAdded = true;

          _isLoadingPhoto = false;
        }
      }
      notifyListeners();
    }
  }

  void setName(String value) {
    _name = value.trim();
    notifyListeners();
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      // Save the image only if provided

      if (newPictureAdded && _fileBytes != null) {
        Uint8List? binaryData = ImageUtils.resizeBinaryImage(
          imageData: _fileBytes!,
          maxHeight: 512,
        );
        if (binaryData != null) {
          String base64String = base64Encode(binaryData);
          await _database.updateItem(
            DatabaseService.usersStoreName,
            _name,
            base64String,
          );
          debugPrint('After resize : ${base64String.length}');
        }
      }

      if (context.mounted) {
        context.pop(
          DialogResult(
            operation: isEditing ? DialogOperation.edit : DialogOperation.add,
            name: _name,
          ),
        );
      }
    }
  }

  Future<void> delete() async {
    bool res = await WidgetUtils.showAlertDialogYesNo(
      context: context,
      title: CommonUtils.getLocalizedString(context, context.l10n.warning),
      message: context.l10n.delete_user_name(name),
      barrierDismissible: false,
    );

    if (context.mounted) {
      if (res) {
        context.pop(
          DialogResult(operation: DialogOperation.delete, name: _name),
        );
      }
    }
  }

  void cancel() {
    if (context.mounted) {
      context.pop();
    }
  }

  bool canSubmit() {
    return _name.isNotEmpty;
  }

  void setMiniInputDialog(bool mini) {
    _isMiniInputDialog = mini;
    notifyListeners();
  }
}

class DialogResult {
  final DialogOperation operation;
  final String? name;

  const DialogResult({required this.operation, this.name});
}

enum DialogOperation { add, edit, delete, as }
