import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DialogWarningViewmodel extends BaseViewModel {
  final BuildContext context;

  DialogWarningViewmodel({required this.context});

  Future<void> openURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  void closeAlert() {
    Navigator.of(context).pop();
  }
}
