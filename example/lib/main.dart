import 'package:example/app/app_page.dart';
import 'package:example/widgets/dialog_widget.dart';
import 'package:example/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:mlstatemanagement/mlstatemanagement.dart';

import 'di/injector.dart';

void main() {
  configureDependencies();
  MLStateManagement().setUp(
    appDialogBuilder: (message) => AppDialog(message: message),
    appLoadingHUDBuilder: (message) => AppLoadingWidget(message: message),
    appOptionalDialogBuilder: (title, message, buttonTitle, altButtonTitle,
            onPressedAltBtn, onPressedBtn) =>
        AppOptionalDialog(
            onPressedAltBtn: onPressedAltBtn, onPressedBtn: onPressedBtn),
    appLoadingBuilder: (message) => AppLoadingWidget(message: message),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const AppPage(),
    );
  }
}
