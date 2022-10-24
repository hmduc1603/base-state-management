import 'package:example/app/app_cubit.dart';
import 'package:example/app/app_state.dart';
import 'package:example/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:mlstatemanagement/mlstatemanagement.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends BaseState<AppState, AppCubit, AppPage> {
  @override
  void initState() {
    cubit.init();
    super.initState();
  }

  @override
  Widget buildByState(BuildContext context, AppState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        if (state.pageStatus.isLoading) {
          return const AppLoadingWidget();
        }
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  onPressed: () => cubit.showMessage('Message'),
                  child: const Text('Show Dialog')),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => cubit.showLoading(),
                  child: const Text('Show Loading')),
            ],
          ),
        );
      }),
    );
  }
}
