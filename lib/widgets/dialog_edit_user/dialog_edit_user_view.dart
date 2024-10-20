import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:face_detector/widgets/dialog_edit_user/dialog_edit_user_viewmodel.dart';
import 'package:face_detector/widgets/loading_button/loading_button_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DialogEditUserView extends StatelessWidget {
  final String? name;
  final bool isEditing;

  const DialogEditUserView({super.key, this.name, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DialogEditUserViewModel>.reactive(
      viewModelBuilder: () => DialogEditUserViewModel(
        context: context,
        isEditing: isEditing,
        initialName: name,
      ),
      builder: (builderContext, model, child) {
        if (model.isMiniInputDialog) {
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
                        child: TextFormField(
                          enabled: !isEditing,
                          initialValue: (isEditing && model.name.isEmpty) ? name : model.name,
                          autofocus: true,
                          style: TextStyle(
                            color: Theme.of(builderContext).colorScheme.onSurfaceVariant,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return CommonUtils.getLocalizedString(
                                builderContext,
                                builderContext.l10n.error_mandatory_field,
                              );
                            }
                            return null;
                          },
                          onChanged: (value) => model.setName(value),
                          decoration: InputDecoration(
                            labelText: CommonUtils.getLocalizedString(
                              builderContext,
                              builderContext.l10n.name,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          FocusScope.of(builderContext).unfocus();
                          model.setMiniInputDialog(false);
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
            isEditing
                ? CommonUtils.getLocalizedString(
                    builderContext,
                    builderContext.l10n.edit_user_name(name!.toString()),
                  )
                : CommonUtils.getLocalizedString(
                    builderContext,
                    builderContext.l10n.create_user,
                  ),
            style: AppText.font20Regular,
          ),
          content: SizedBox(
            width: 400,
            child: Form(
              key: model.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => model.pickImage(),
                        child: SizedBox(
                          width: 80,
                          height: 100,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              if (model.fileBytes == null)
                                ThemeUtils.getImageAddPerson(builderContext),
                              if (model.isLoadingPhoto) const CircularProgressIndicator(),
                              model.fileBytes != null
                                  ? Container(
                                      width: 80,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: MemoryImage(model.fileBytes!),
                                        ),
                                      ),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          CommonUtils.getLocalizedString(
                                            builderContext,
                                            builderContext.l10n.add_image,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          enabled: !isEditing,
                          initialValue: (isEditing && model.name.isEmpty) ? name : model.name,
                          style: TextStyle(
                            color: Theme.of(builderContext).colorScheme.onSurfaceVariant,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return CommonUtils.getLocalizedString(
                                builderContext,
                                builderContext.l10n.error_mandatory_field,
                              );
                            }
                            return null;
                          },
                          onTap: () {
                            if (!model.isMiniInputDialog &&
                                DeviceUtils.isLandscape(builderContext) &&
                                DeviceUtils.isSmallScreen(builderContext)) {
                              model.setMiniInputDialog(true);
                            }
                          },
                          onChanged: (value) => model.setName(value),
                          decoration: InputDecoration(
                            labelText: CommonUtils.getLocalizedString(
                              builderContext,
                              builderContext.l10n.name,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            if (isEditing) ...[
              LoadingButtonView(
                label: CommonUtils.getLocalizedString(
                  builderContext,
                  builderContext.l10n.delete_user,
                ),
                isDangerous: true,
                onPressed: () async => await model.delete(),
              ),
              LoadingButtonView(
                label: CommonUtils.getLocalizedString(
                  builderContext,
                  builderContext.l10n.button_save,
                ),
                onPressed: () async => await model.save(),
              ),
            ] else ...[
              // ElevatedButton(
              //   onPressed: () async => await model.cancel(),
              //   child: Text(
              //     CommonUtils.getLocalizedString(context, context.l10n.button_cancel),
              //     style: const TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
              ElevatedButton(
                onPressed: () => model.save(),
                child: Text(
                  CommonUtils.getLocalizedString(
                    builderContext,
                    builderContext.l10n.button_confirm,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
