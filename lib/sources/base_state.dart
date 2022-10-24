import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mlstatemanagement/mlstatemanagement.dart';
import 'package:mlstatemanagement/sources/base_message.dart';
import 'base_app_loading.dart';

abstract class BaseState<S extends BaseCubitState, C extends BaseCubit<S>,
        W extends StatefulWidget> extends State<W>
    with AutomaticKeepAliveClientMixin {
  final C cubit = GetIt.instance<C>();
  final loadingController = AppLoadingController();
  late S _state;
  StreamSubscription? _eventStreamSub;

  S get state => _state;

  // Use when you want to maintain Cubit & State
  bool get shouldMaintainState => false;

  @override
  void initState() {
    super.initState();
    _state = cubit.state;
    _eventStreamSub = cubit.eventStream.listen(
      (value) => onNewEvent(value),
    );
  }

  @override
  void dispose() {
    if (!shouldMaintainState) {
      _eventStreamSub?.cancel();
      cubit.close();
    }
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: cubit,
      child: BlocListener<C, S>(
        listenWhen: (S previous, S current) {
          onStateChanged(previous, current);
          return shouldRebuild(previous, current);
        },
        listener: (context, state) => setState(() => _state = state),
        child: AppLoadingHUD(
            controller: loadingController,
            child: buildByState(context, _state)),
      ),
    );
  }

  Widget buildByState(BuildContext context, S state);

  onStateChanged(S previous, S current) {}

  bool shouldRebuild(S previous, S current) {
    return true;
  }

  onNewEvent(BaseEvent event) {
    if (event is LoadingEvent) {
      event.isLoading
          ? loadingController.showLoading(
              blurBG: event.hasBlurBackground, msg: getMessage(event.message))
          : loadingController.hideLoading();
    }
    if (event is MessageEvent) {
      showMessage(getMessage(event.msg));
    }
    if (event is ErrorEvent) {
      if (kDebugMode) {
        showError(event.error.toString());
      } else {
        showError(getErrorMessage(event.error));
      }
    }
  }

  String getErrorMessage(error) {
    if (error is BaseMessage) {
      return error.localized(context);
    }
    return 'Something wrong is happened, please try again';
  }

  String getMessage(msg) {
    if (msg is BaseMessage) {
      return msg.localized(context);
    }
    return '';
  }

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

  showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MLStateManagement().appDialogBuilder(message);
      },
    );
  }
}

enum StateStatus { loading, idle, error }

class PageStatus {
  final StateStatus stateStatus;
  final dynamic error;

  const PageStatus({
    this.stateStatus = StateStatus.loading,
    this.error,
  });

  bool get isLoading => stateStatus == StateStatus.loading;
  bool get isError => stateStatus == StateStatus.error;
  bool get isIdle => stateStatus == StateStatus.idle;

  factory PageStatus.idle() {
    return const PageStatus(stateStatus: StateStatus.idle);
  }

  factory PageStatus.loading() {
    return const PageStatus(stateStatus: StateStatus.loading, error: null);
  }

  factory PageStatus.error(dynamic error) {
    return PageStatus(stateStatus: StateStatus.error, error: error);
  }
}
