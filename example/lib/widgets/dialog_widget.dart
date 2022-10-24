import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String? buttonTitle;

  const AppDialog({
    Key? key,
    this.title,
    required this.message,
    this.buttonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...{
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                )
              },
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 8,
              ),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(buttonTitle ?? 'Close'))
            ],
          ),
        ],
      ),
    );
  }
}

class AppOptionalDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? buttonTitle;
  final VoidCallback onPressedBtn;
  final String? altButtonTitle;
  final VoidCallback onPressedAltBtn;

  const AppOptionalDialog({
    Key? key,
    this.title,
    this.message,
    this.buttonTitle,
    this.altButtonTitle,
    required this.onPressedAltBtn,
    required this.onPressedBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...{
              Text(
                title!,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            },
            if (message != null) ...{
              Text(
                message!,
                textAlign: TextAlign.center,
                maxLines: 8,
              ),
            },
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  ElevatedButton(
                      onPressed: () {
                        onPressedBtn();
                        Navigator.of(context).pop();
                      },
                      child: Text(buttonTitle ?? 'Ok'))
                ]),
                const TableRow(children: [SizedBox()]),
                TableRow(children: [
                  ElevatedButton(
                    onPressed: () {
                      onPressedAltBtn();
                      Navigator.of(context).pop();
                    },
                    child: Text(buttonTitle ?? 'Cancel'),
                  )
                ]),
              ],
            )
          ],
        ),
      ],
    );
  }
}
