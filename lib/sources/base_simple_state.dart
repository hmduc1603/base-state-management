import 'package:flutter/material.dart';
import 'package:mlstatemanagement/mlstatemanagement.dart';
import 'package:mlstatemanagement/sources/base_app_loading.dart';

import 'base_message.dart';

abstract class BaseSimpleState<P extends StatefulWidget> extends State<P> {
  final AppLoadingController appLoadingController = AppLoadingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoadingHUD(
        child: buildPage(context), controller: appLoadingController);
  }

  Widget buildPage(BuildContext context);

  Future<void> showMessage(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return MLStateManagement().appDialogBuilder(message);
      },
    );
  }

  void showOptionalDialog({
    String? title,
    String? message,
    String? buttonTitle,
    String? altButtonTitle,
    required VoidCallback onPressedAltBtn,
    required VoidCallback onPressedBtn,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return MLStateManagement().appOptionalDialogBuilder(
          title,
          message,
          buttonTitle,
          altButtonTitle,
          onPressedAltBtn,
          onPressedBtn,
        );
      },
    );
  }

  showError(dynamic error) {
    showDialog(
      context: context,
      builder: (context) {
        return MLStateManagement().appDialogBuilder(_getErrorMessage(error));
      },
    );
  }

  String _getErrorMessage(error) {
    if (error is BaseMessage) {
      return error.localized(context);
    }
    return 'Something wrong is happened, please try again';
  }
}
