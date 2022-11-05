import 'package:base_state_management/statemanagement.dart';
import 'package:example/app/app_state.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppCubit extends BaseCubit<AppState> {
  AppCubit() : super(const AppState());

  init() async {
    await Future.delayed(const Duration(seconds: 5));
    emit(state.copyWith(pageStatus: PageStatus.idle()));
  }
}
