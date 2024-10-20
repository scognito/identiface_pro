import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoadingButtonViewmodel extends BaseViewModel {
  final Function onPressed;

  LoadingButtonViewmodel({required this.onPressed});

  Future<void> onTap() async {
    setBusy(true);
    try {
      await onPressed();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setBusy(false);
    }
  }
}
