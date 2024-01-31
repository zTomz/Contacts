import 'package:flutter/material.dart';

extension ScaffoldMessangerExtension on BuildContext {
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message) {
    return scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<T?> showBottomSheet<T>(Widget widget) {
    return showModalBottomSheet(context: this, builder: (_) => widget);
  }
}
