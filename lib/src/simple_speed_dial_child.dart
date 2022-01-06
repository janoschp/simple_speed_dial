import 'package:flutter/widgets.dart';

class SpeedDialChild {
  const SpeedDialChild({
    required this.child,
    required this.onPressed,
    this.foregroundColor,
    this.backgroundColor,
    this.label,
    this.closeSpeedDialOnPressed = true,
  });

  /// A widget to display as the [SpeedDialChild].
  final Widget child;

  /// A callback to be executed when the [SpeedDialChild] is pressed.
  final Function onPressed;

  /// The [SpeedDialChild] foreground color.
  final Color? foregroundColor;

  /// The [SpeedDialChild] background color.
  final Color? backgroundColor;

  /// The text displayed next to the [SpeedDialChild] when the [SpeedDial] is open.
  final String? label;

  /// Whether the [SpeedDial] should close after the [onPressed] callback of
  /// [SpeedDialChild] is called.
  ///
  /// Defaults to [true].
  final bool closeSpeedDialOnPressed;
}
