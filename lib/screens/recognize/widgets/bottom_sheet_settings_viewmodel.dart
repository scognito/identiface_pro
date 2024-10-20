import 'package:face_detector/locator.dart';
import 'package:face_detector/services/database_service.dart';
import 'package:face_detector/services/api_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/filesystem_utils.dart';
import 'package:face_detector/utils/widget_utils.dart';
import 'package:face_detector/widgets/dialog_edit_user/dialog_edit_user_view.dart';
import 'package:face_detector/widgets/dialog_edit_user/dialog_edit_user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

class BottomSheetSettingsViewmodel extends FutureViewModel {
  final _api = locator.get<ApiService>();
  final _database = locator.get<DatabaseService>();

  Set<String> _personList = {};

  Set<String> get personList => _personList;

  String? _currentPerson;

  String? get currentPerson => _currentPerson;

  final BuildContext context;
  final String? defaultPerson;

  BottomSheetSettingsViewmodel({required this.context, this.defaultPerson});

  @override
  Future<void> futureToRun() async {
    await getPersons(setToPersonName: defaultPerson);
    await FileSystemUtils.deleteAllFilesInMediaDirectory();
  }

  Future<void> getPersons({String? setToPersonName}) async {
    setBusy(true);
    ApiResponse response = await _api.getSubjects();

    if (response.hasData) {
      _personList.clear();
      _personList = Set<String>.from(response.data!);

      if (setToPersonName != null && _personList.contains(setToPersonName)) {
        _currentPerson = setToPersonName;
      } else {
        _currentPerson = _personList.first;
      }
    } else {
      setError(response.error);
      if (context.mounted) {
        WidgetUtils.showSnackBar(context, response.error!, fromTop: true);
      }
    }

    setBusy(false);
  }

  void setCurrentPerson(String person) {
    _currentPerson = person;
    notifyListeners();
  }

  Future<void> takePicture() async {
    bool shouldTakePicture = await WidgetUtils.showAlertDialogYesNo(
      context: context,
      title: CommonUtils.getLocalizedString(context, context.l10n.warning),
      message: context.l10n.add_image_for_name_question(_currentPerson!),
      yesLabel: context.l10n.yes,
      noLabel: context.l10n.no,
    );

    if (!shouldTakePicture) {
      return;
    }
    debugPrint(_currentPerson);

    if (context.mounted) {
      context.pop(
        SheetOperation(SheetOperationType.takePhoto, user: _currentPerson),
      );
    }
  }

  Future<void> addPerson() async {
    DialogResult? result = await showDialog<DialogResult?>(
      context: context,
      builder: (_) {
        return const DialogEditUserView(isEditing: false);
      },
    );

    if (result != null) {
      setBusy(true);
      ApiResponse response = await _api.addSubject(result.name!);

      if (response.hasData) {
        if (context.mounted) {
          WidgetUtils.showSnackBar(
            context,
            CommonUtils.getLocalizedString(
              context,
              context.l10n.person_added,
            ),
            fromTop: true,
          );
        }
        await getPersons(setToPersonName: result.name!);
      } else {
        if (context.mounted) {
          WidgetUtils.showSnackBar(context, response.error!, fromTop: true);
        }
      }

      setBusy(false);
    }
  }

  Future<void> deletePerson() async {
    setBusy(true);
    ApiResponse response = await _api.deleteSubject(_currentPerson!);

    if (response.hasData) {
      // String avatarPath = (await FileSystemUtils.getAvatarDirectory()).path;
      // String filePath = '$avatarPath/$_currentPerson.jpg';
      // await FileSystemUtils.deleteFile(filePath);

      await _database.deleteItem(
        DatabaseService.usersStoreName,
        _currentPerson!,
      );

      if (context.mounted) {
        WidgetUtils.showSnackBar(
          context,
          CommonUtils.getLocalizedString(context, context.l10n.person_deleted),
          fromTop: true,
        );
      }
      await getPersons();
    } else {
      if (context.mounted) {
        WidgetUtils.showSnackBar(context, response.error!, fromTop: true);
      }
    }

    setBusy(false);
  }

  Future<void> editPerson() async {
    DialogResult? result = await showDialog<DialogResult?>(
      context: context,
      builder: (_) {
        return DialogEditUserView(isEditing: true, name: _currentPerson);
      },
    );

    if (result != null) {
      if (result.operation == DialogOperation.delete) {
        await deletePerson();
      }
    }
  }

  void closeBottomSheet() {
    context.pop(SheetOperation(SheetOperationType.close));
  }
}

class SheetOperation {
  SheetOperationType type;
  String? user;

  SheetOperation(this.type, {this.user});
}

enum SheetOperationType { close, takePhoto }
