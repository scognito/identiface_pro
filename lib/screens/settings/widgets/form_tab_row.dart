import 'package:face_detector/config/app_text.dart';
import 'package:face_detector/screens/settings/screen_settings_viewmodel.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/extensions.dart';
import 'package:face_detector/utils/theme_utils.dart';
import 'package:face_detector/utils/widget_utils.dart';
import 'package:face_detector/widgets/loading_button/loading_button_view.dart';
import 'package:flutter/material.dart';

class FormTabRow extends StatelessWidget {
  final ScreenSettingsViewModel model;
  final String label;
  final String? description;

  const FormTabRow({required this.model, required this.label, this.description, super.key});

  @override
  Widget build(BuildContext context) {
    final infoIcon = description != null
        ? Icon(
            Icons.info_outline,
            size: 16,
            color: ThemeUtils.getSettingsLabelColor(context),
          )
        : const SizedBox.shrink();

    final text = RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 18,
              color: ThemeUtils.getSettingsLabelColor(context),
            ),
        children: [
          TextSpan(text: CommonUtils.getLocalizedString(context, label)),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 3.0),
              child: infoIcon,
            ),
          ),
        ],
      ),
    );

    final tabs = DefaultTabController(
      length: 3,
      child: Container(
        decoration: ThemeUtils.getBorderTheme(context),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'URL'),
                Tab(text: 'Header'),
                Tab(text: 'Body'),
              ],
            ),
            SizedBox(
              height: 150,
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButtonFormField<String>(
                              value: model.extApiMethod,
                              isExpanded: true,
                              items: kExtApiMethods.map((String name) {
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Text(
                                    name.toUpperCase(),
                                    style: AppText.font18Regular.copyWith(
                                      color: ThemeUtils.getDropdownItemColor(
                                        context,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                model.setExtApiMethod(newValue!);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: model.externalApiUrlController,
                              style: const TextStyle(fontSize: 18),
                              validator: (value) {
                                if (value != null && value.trim().isNotEmpty) {
                                  if (!value.startsWith('http://') &&
                                      !value.startsWith('https://')) {
                                    return CommonUtils.getLocalizedString(
                                      context,
                                      context.l10n.error_url_scheme,
                                    );
                                  }
                                  if (CommonUtils.getValidBaseUrl(value).isEmpty) {
                                    return CommonUtils.getLocalizedString(
                                      context,
                                      context.l10n.error_invalid_url,
                                    );
                                  }
                                  return null;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingButtonView(
                              label: 'TEST',
                              onPressed: () async => await model.testExternalApi(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      controller: model.externalApiHeadersController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Enter valid JSON',
                      ),
                      minLines: 1,
                      maxLines: 10,
                      onChanged: (value) {
                        model.validateForm();
                      },
                      validator: (value) {
                        return model.validateJson(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      controller: model.externalApiBodyController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Enter valid JSON',
                      ),
                      minLines: 1,
                      maxLines: 10,
                      onChanged: (value) {
                        model.validateForm();
                      },
                      validator: (value) {
                        return model.validateJson(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (DeviceUtils.isLandscape(context)) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () => description != null
                    ? WidgetUtils.showAlertDialog(
                        context: context,
                        title: CommonUtils.getLocalizedString(context, label),
                        message: CommonUtils.getLocalizedString(context, description!),
                      )
                    : null,
                child: text,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(flex: 2, child: tabs),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        onTap: () => description != null
            ? WidgetUtils.showAlertDialog(
                context: context,
                title: CommonUtils.getLocalizedString(context, label),
                message: CommonUtils.getLocalizedString(context, description!),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [text, const SizedBox(height: 16), tabs],
        ),
      ),
    );
  }
}
