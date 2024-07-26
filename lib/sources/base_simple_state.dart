import 'package:base_state_management/sources/base_app_loading.dart';
import 'package:base_state_management/statemanagement.dart';
import 'package:flutter/material.dart';
import 'base_message.dart';

abstract class BaseSimpleState<P extends StatefulWidget> extends State<P>
    with AutomaticKeepAliveClientMixin {
  final AppLoadingController appLoadingController = AppLoadingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppLoadingHUD(
        child: buildPage(context), controller: appLoadingController);
  }

  Widget buildPage(BuildContext context);

  Future<void> showMessage(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return StateManagement().appDialogBuilder(message);
      },
    );
  }

  void showOptionalDialog({
    String? title,
    String? message,
    String? buttonTitle,
    String? altButtonTitle,
    Widget? decorationWidget,
    required VoidCallback onPressedAltBtn,
    required VoidCallback onPressedBtn,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return StateManagement().appOptionalDialogBuilder(
          title,
          message,
          buttonTitle,
          altButtonTitle,
          decorationWidget,
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
        return StateManagement().appDialogBuilder(_getErrorMessage(error));
      },
    );
  }

  String _getErrorMessage(error) {
    if (error != null) {
      if (error is BaseMessage) {
        return error.localized(context);
      }
    }
    return 'Something wrong is happened, please try again';
  }
}
