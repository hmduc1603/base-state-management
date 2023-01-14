// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'base_event.dart';
import 'base_state.dart';

abstract class BaseCubit<T extends Equatable> extends Cubit<T> {
  //Core
  final eventSubject = PublishSubject<BaseEvent>();
  Stream<BaseEvent> get eventStream => eventSubject.stream;

  BaseCubit(T initialState) : super(initialState);

  showLoading({bool hasBlurBackground = true, dynamic message}) {
    _addToEvent(LoadingEvent(isLoading: true, hasBlurBackground: hasBlurBackground, message: message));
  }

  hideLoading({bool hasBlurBackground = true}) {
    _addToEvent(LoadingEvent(isLoading: false, hasBlurBackground: hasBlurBackground));
  }

  showMessage(dynamic msg) {
    _addToEvent(MessageEvent(msg: msg));
  }

  handleError(dynamic error) {
    _addToEvent(ErrorEvent(error: error));
  }

  _addToEvent(BaseEvent event) {
    if (!eventSubject.isClosed) {
      eventSubject.add(event);
    }
  }

  @override
  Future<void> close() {
    eventSubject.close();
    return super.close();
  }
}

class SimpleCubitState extends Equatable {
  final PageStatus pageStatus;

  const SimpleCubitState({
    this.pageStatus = const PageStatus(),
  });
  @override
  List<Object?> get props => [
        pageStatus,
      ];

  SimpleCubitState copyWith({
    PageStatus? pageStatus,
  }) {
    return SimpleCubitState(
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }
}
