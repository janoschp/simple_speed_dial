import 'package:flutter/widgets.dart';

class SpeedDialChild {
  const SpeedDialChild({
    this.child,
    this.foregroundColor,
    this.backgroundColor,
    this.label,
    this.onPressed,
    this.closeSpeedDialOnPressed = true,
  });

  final Widget? child;

  final Color? foregroundColor;

  final Color? backgroundColor;

  final String? label;

  final Function? onPressed;

  final bool closeSpeedDialOnPressed;
}
