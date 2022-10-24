import 'package:flutter/material.dart';

export 'sources/base_cubit.dart';
export 'sources/base_event.dart';
export 'sources/base_simple_state.dart';
export 'sources/base_state.dart';

class MLStateManagement {
  static final MLStateManagement _singleton = MLStateManagement._internal();

  MLStateManagement._internal();

  factory MLStateManagement() {
    return _singleton;
  }

  late Widget Function(String message) appDialogBuilder;
  late Widget Function(
    String? title,
    String? message,
    String? buttonTitle,
    String? altButtonTitle,
    VoidCallback onPressedAltBtn,
    VoidCallback onPressedBtn,
  ) appOptionalDialogBuilder;
  late Widget Function(String message) appLoadingBuilder;

  /// It's compulsory to call this setUp function before run app
  void setUp({
    required Widget Function(String message) appDialogBuilder,
    required Widget Function(String message) appLoadingHUDBuilder,
    required Widget Function(
      String? title,
      String? message,
      String? buttonTitle,
      String? altButtonTitle,
      VoidCallback onPressedAltBtn,
      VoidCallback onPressedBtn,
    )
        appOptionalDialogBuilder,
    required Widget Function(String message) appLoadingBuilder,
  }) {
    _singleton.appDialogBuilder = appDialogBuilder;
    _singleton.appOptionalDialogBuilder = appOptionalDialogBuilder;
    _singleton.appLoadingBuilder = appLoadingHUDBuilder;
  }
}
