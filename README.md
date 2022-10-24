## Supported Flutter Version
#### 2.10.1


## Introduction

#### What is MLStateManagement?
It’s a hand-on package for state management using BLOC (& CUBIT) pattern & [Flutter_Bloc](https://pub.dev/packages/flutter_bloc) package. It help user implement new app faster with strong management on how widget rebuilding overtime, also this package include many common widgets & functions (ex: showLoading, showError, ...).

#### Why MLStateManagement?
No more boilerplate, save your time on the main features of your project, easy to upgrade, high performance, easy to control.

## Installation
Add the package to your **pubspec.yaml**
```              
dependencies:              
  mlstatemanagement:
    git: 
        url: https://gitlab.com/maplelabs-android-libs/mlstatemanagement
        ref: [branch-that-matched-with-your-flutter-version]
```    

## Setup 
### MLStateManagement is a singleton. Before runApp(), you must call setUp() function.

- appDialogBuilder: Customize dialog that shows around your app in a lot of cases
- appLoadingHUDBuilder: build your own loading widget
- appOptionalDialogBuilder: create a widget that have two buttons (primary and alternative), usually "OK" & "CANCEL"
- appLoadingBuilder: build a loading indicator widget
- getErrorMessage & getMessage: normally use when want to localize the message or transfer error (could be and enum) to something readable

```              
void main() {
  
  MLStateManagement().setUp(
    appDialogBuilder: (message) => AppDialog(message: message),
    appLoadingHUDBuilder: (message) => AppLoadingWidget(message: message),
    appOptionalDialogBuilder: (title, message, buttonTitle, altButtonTitle,
            onPressedAltBtn, onPressedBtn) =>
        AppOptionalDialog(
            onPressedAltBtn: onPressedAltBtn, onPressedBtn: onPressedBtn),
    appLoadingBuilder: (message) => AppLoadingWidget(message: message),
    getErrorMessage: (error) {
      return 'This is Error';
    },
    getMessage: (message) {
      return 'This is message';
    },
  );

  runApp(const MyApp());
}
``` 

## Before Using
Find more about the architecture:
- https://bloclibrary.dev/#/architecture
- https://resocoder.com/2020/08/04/flutter-bloc-cubit-tutorial/

In this package, we would use the lighter version of BLOC called **Cubit**, which removed a bunch of boilerplate.

Instead of mutating individual fields, we emit whole new MyState objects. Also, the state is in a class separate from the one responsible for changing the state. Here is graphical explaination...

<p align="left">              
<img  src="https://i0.wp.com/resocoder.com/wp-content/uploads/2020/07/cubit_architecture_full.png?w=800&ssl=1" height="170">              
</p>  

***A page/screen should implement three classes that extend: BaseCubit, BaseCubitState, BaseState***.


## BaseCubit
This extends Cubit to handle business logics, using **emit** every time you have to rebuild UI.

Example:

``` 
class AppCubit extends BaseCubit<AppState> {
  AppCubit() : super(const AppState());

  init() async {
    await Future.delayed(const Duration(seconds: 5));
    emit(state.copyWith(pageStatus: PageStatus.idle()));
  }
}
``` 
### Explanations:
Cubit have some functions that you will use all the time:
1. **showLoading**: fire an event to BaseState to show loading dialog (cannot be closed by return button)
2. **hideLoading**: close loading dialog
3. **showMessage**: show message dialog with close button
4. **handleError**: should be used to handle error when implement bussiness logics, it will show a dialog

## BaseCubitState
This with extends Equatable to compare between states (only different state can force UI to rebuild) when using **emit**. This class should only store variable that affect the UI

Example:
```
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
```
### Explanations:
BaseCubitState need to implement **copyWith()** function (recommend to use this annotatio [CopyWith()](https://pub.dev/packages/copy_with_extension) to autogen)

1. **PageStatus**: default a page status is Loading
```
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

```

## BaseState
This will replate **State Widget**

Example:
```
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
```
### Explanations:
There are functions inside BaseState you should know to manipulate whenever you want, **but keep in mind that EVERY LOGIC SHOULD HANDLE INSIDE BASECUBIT**:

1. **cubit**: the getter or BaseCubit, you can access it in the UI building process
```
final C cubit = GetIt.instance<C>();
```
2. **loadingController**: beside showing LoadingHUD inside BaseCubit, you can also manipulate using this controller
```
final loadingController = AppLoadingController();
```
3. **shouldMaintainState**: your can override this getter to keep BaseCubit & BaseState on memory when the Page closed
```
bool get shouldMaintainState => false;
```
4. **wantKeepAlive**: BaseState also extends **AutomaticKeepAliveClientMixin**, so you can access to this too
```
@override
  bool get wantKeepAlive => false;
```
5. **buildByState**: this is a required function when implement BaseState to build UI (do not override old **build**)
```
Widget buildByState(BuildContext context, S state);
```
6. **onStateChanged** : called everytime state changed, override this to perform some logics that you want
```
onStateChanged(S previous, S current) {}

```
7. **shouldRebuild**: define which condition the page should redraw, it's **TRUE** by default
```
bool shouldRebuild(S previous, S current) {
    return true;
  }
```
8. **onNewEvent**: catch events (Stream) from BaseCubit, you can override this to implement more (recommend declare **super**)
```
onNewEvent(BaseEvent event) {
    if (event is LoadingEvent) {
      event.isLoading
          ? loadingController.showLoading(
              blurBG: event.hasBlurBackground,
              msg: MLStateManagement().getMessage(event.message))
          : loadingController.hideLoading();
    }
    if (event is MessageEvent) {
      showMessage(MLStateManagement().getMessage(event.msg));
    }
    if (event is ErrorEvent) {
      if (kDebugMode) {
        showError(event.error.toString());
      } else {
        showError(MLStateManagement().getErrorMessage(event.error));
      }
    }
  }
```
9. **showMessage**: show dialog messsage
```
Future<void> showMessage(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return MLStateManagement().appDialogBuilder(message);
      },
    );
  }
```
10. **showOptionalDialog**: show optional dialog
```
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
```
11. **showError**: show error dialog
```
showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MLStateManagement().appDialogBuilder(message);
      },
    );
  }
```

## BaseSimpleState
This is a simple version of BaseState, which does not have BaseCubit & BaseCubitState
```
abstract class BaseSimpleState<P extends StatefulWidget> extends State<P> {}
```

## Some Helpers (Widgets)
These are widgets that help you in some cases with State Management

1. **Rebuild Controller Widget**: Control how widget should rebuild under conditions

```
class RebuildControllerWidget<D> extends StatefulWidget {
  final bool Function(D? last) shouldRebuild;
  final Widget child;

  /// Use this when you want to get the old value to compare on shouldRebuild function
  final D currentValue;

  const RebuildControllerWidget({
    Key? key,
    required this.shouldRebuild,
    required this.child,
    required this.currentValue,
  }) : super(key: key);

  @override
  State<RebuildControllerWidget<D>> createState() =>
      _RebuildControllerWidgetState<D>();
}
```