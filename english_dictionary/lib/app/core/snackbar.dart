import 'package:another_flushbar/flushbar.dart';
import 'constants.dart';
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
          backgroundColor: const Color.fromARGB(255, 102, 140, 99),
          textColor: const Color.fromARGB(255, 255, 255, 255),
          icon: icon ??
              const Icon(
                Icons.check,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
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
          textColor: const Color.fromARGB(255, 255, 255, 255),
          icon: icon ??
              const Icon(
                Icons.warning,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
        );
}

class ErrorSnackbar extends _BaseSnackbar {
  ErrorSnackbar(
    BuildContext context, {
    String? message,
    String? title,
    Widget? icon,
  }) : super(
          context,
          title: title,
          message: message ?? Constants.defaultError,
          backgroundColor: const Color(0xFFF64343),
          textColor: const Color(0xFFFCFCFC),
          icon: icon ??
              const Icon(
                Icons.error,
                color: Color(0xFFFCFCFC),
              ),
        );
}
