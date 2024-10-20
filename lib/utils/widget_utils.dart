import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/screens/recognize/widgets/bottom_sheet_camera_settings_view.dart';
import 'package:face_detector/screens/recognize/widgets/bottom_sheet_settings_view.dart';
import 'package:face_detector/screens/recognize/widgets/bottom_sheet_settings_viewmodel.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:flutter/material.dart';

class WidgetUtils {
  static showSnackBar(BuildContext context, String message, {bool? fromTop}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: (fromTop ?? false) ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
        margin: (fromTop ?? false)
            ? EdgeInsets.only(
                bottom: MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).top - 100,
                left: 10,
                right: 10,
              )
            : null,
      ),
    );
  }

  static Future<SheetOperation> showSettingsBottomSheet({
    required BuildContext context,
    String? defaultPerson,
  }) async {
    final SheetOperation? result = await showModalBottomSheet<SheetOperation>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BottomSheetSettingsView(defaultPerson: defaultPerson);
      },
    );
    return result ?? SheetOperation(SheetOperationType.close);
  }

  static Future<SheetOperation> showCameraSettingsBottomSheet({
    required BuildContext context,
  }) async {
    final SheetOperation? result = await showModalBottomSheet<SheetOperation>(
      context: context,
      builder: (_) {
        return const BottomSheetCameraSettingsView();
      },
    );
    return result ?? SheetOperation(SheetOperationType.close);
  }

  static Future<bool> askPassword(BuildContext context) async {
    String storedPassword = locator.get<StorageService>().getMasterPassword();
    if (storedPassword.isNotEmpty) {
      String password = await WidgetUtils.showAlertInputDialog(context);
      if (password.isEmpty) {
        return false;
      }
      if (password != storedPassword) {
        if (context.mounted) {
          WidgetUtils.showSnackBar(
            context,
            CommonUtils.getLocalizedString(
              context,
              context.l10n.error_wrong_password,
            ),
          );
        }
        return false;
      }
    }

    return true;
  }

  static Future<String> showAlertInputDialog(BuildContext context) async {
    return await showDialog<String>(
          context: context,
          builder: (_) {
            return const ResponsiveTextInput(isPassword: true);
          },
        ) ??
        '';
  }

  static Future<bool> showAlertDialog({
    required BuildContext context,
    String? title,
    required String message,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (BuildContext builderContext) {
            return AlertDialog(
              title: title != null ? Text(title, style: AppText.font20Regular) : null,
              content: SizedBox(width: 200, child: Text(message)),
              actions: [
                ElevatedButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.of(builderContext).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static Future<bool> showAlertDialogYesNo({
    required BuildContext context,
    required String title,
    required String message,
    String yesLabel = 'Yes',
    String noLabel = 'No',
    bool barrierDismissible = true,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (BuildContext builderContext) {
            return AlertDialog(
              title: Text(title, style: AppText.font20Regular),
              content: SizedBox(width: 200, child: Text(message)),
              actions: [
                ElevatedButton(
                  child: Text(
                    noLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(builderContext).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text(
                    yesLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.of(builderContext).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class ResponsiveTextInput extends StatefulWidget {
  final bool isPassword;

  const ResponsiveTextInput({super.key, required this.isPassword});

  @override
  State<ResponsiveTextInput> createState() => _ResponsiveTextInputState();
}

class _ResponsiveTextInputState extends State<ResponsiveTextInput> {
  bool isMini = false;
  String password = '';

  @override
  Widget build(BuildContext context) {
    if (isMini) {
      return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      obscuringCharacter: widget.isPassword ? '*' : '',
                      autofocus: true,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        labelText: CommonUtils.getLocalizedString(
                          context,
                          context.l10n.password,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(password.trim());
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return AlertDialog(
      title: Text(
        CommonUtils.getLocalizedString(
          context,
          context.l10n.password_required,
        ),
        style: AppText.font20Regular,
      ),
      contentPadding: const EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              obscuringCharacter: '*',
              autofocus: DeviceUtils.isMacOS() || DeviceUtils.isMediumScreen(context),
              onTap: () {
                if (!DeviceUtils.isMacOS() &&
                    DeviceUtils.isLandscape(context) &&
                    DeviceUtils.isSmallScreen(context)) {
                  DeviceUtils.hideKeyboard();
                  setState(() {
                    isMini = true;
                  });
                }
              },
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                labelText: CommonUtils.getLocalizedString(
                  context,
                  context.l10n.password,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(password.trim());
          },
          child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
