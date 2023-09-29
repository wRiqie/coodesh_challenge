import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

abstract class _BaseSnackbar {
  Flushbar? _currentBar;

  _BaseSnackbar(BuildContext context,
      {String? title,
      required String message,
      Widget? icon,
      required Color backgroundColor,
      Color? textColor}) {
    _closeCurrent();
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      title: title,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      titleColor: textColor,
      messageColor: textColor,
      borderRadius: BorderRadius.circular(4),
      duration: const Duration(seconds: 3),
    ).show(context);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: backgroundColor,
    //     margin: const EdgeInsets.all(8),
    //     content: Text(
    //       message,
    //       style: TextStyle(color: textColor),
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(4),
    //     ),
    //     duration: const Duration(seconds: 3),
    //   ),
    // );
  }

  void _closeCurrent() {
    _currentBar?.dismiss();
  }
}

class SuccessSnackbar extends _BaseSnackbar {
  SuccessSnackbar(
    BuildContext context, {
    required String message,
    String? title,
    Widget? icon,
  }) : super(
          context,
          title: title,
          message: message,
          backgroundColor: const Color.fromARGB(255, 156, 156, 156),
          textColor: const Color(0xFF1E1E1E),
          icon: icon,
        );
}

class AlertSnackbar extends _BaseSnackbar {
  AlertSnackbar(
    BuildContext context, {
    required String message,
    String? title,
    Widget? icon,
  }) : super(
          context,
          title: title,
          message: message,
          backgroundColor: Colors.orange,
          textColor: const Color(0xFF1E1E1E),
          icon: icon,
        );
}

class ErrorSnackbar extends _BaseSnackbar {
  ErrorSnackbar(
    BuildContext context, {
    required String message,
    String? title,
    Widget? icon,
  }) : super(
          context,
          title: title,
          message: message,
          backgroundColor: const Color(0xFFF64343),
          textColor: const Color(0xFFFCFCFC),
          icon: icon,
        );
}
