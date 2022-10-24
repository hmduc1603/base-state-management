import 'package:mlstatemanagement/mlstatemanagement.dart';

class AppState extends BaseCubitState {
  const AppState({PageStatus? pageStatus})
      : super(pageStatus: pageStatus ?? const PageStatus());

  @override
  List<Object?> get extraProps => [];

  AppState copyWith({
    PageStatus? pageStatus,
  }) {
    return AppState(
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }
}
