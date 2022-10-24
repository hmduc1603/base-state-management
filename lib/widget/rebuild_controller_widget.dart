import 'package:flutter/material.dart';

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

class _RebuildControllerWidgetState<D>
    extends State<RebuildControllerWidget<D>> {
  final GlobalKey _globalKey = GlobalKey();
  D? previousValue;

  @override
  void dispose() {
    _globalKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_globalKey.currentWidget == null ||
        widget.shouldRebuild(previousValue)) {
      previousValue = widget.currentValue;
      return Container(
        key: _globalKey,
        child: widget.child,
      );
    }
    return _globalKey.currentWidget!;
  }
}
