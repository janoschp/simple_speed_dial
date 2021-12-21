import 'package:flutter/material.dart';

import 'simple_speed_dial_child.dart';

class SpeedDial extends StatefulWidget {
  const SpeedDial({
    required this.child,
    required this.speedDialChildren,
    this.labelsStyle,
    this.controller,
    this.closedForegroundColor,
    this.openForegroundColor,
    this.closedBackgroundColor,
    this.openBackgroundColor,
  });

  final Widget child;

  /// A list of [SpeedDialChild] to display when the [SpeedDial] is open.
  final List<SpeedDialChild> speedDialChildren;

  /// Specifies the [SpeedDialChild] label text style.
  final TextStyle? labelsStyle;

  /// An animation controller for the [SpeedDial].
  ///
  /// Provide an [AnimationController] to control the animations
  /// from outside the [SpeedDial] widget.
  final AnimationController? controller;

  /// The color of the [SpeedDial] button foreground when closed.
  ///
  /// The [SpeedDial] foreground will animate to this color when the user
  /// closes the speed dial.
  final Color? closedForegroundColor;

  /// The color of the [SpeedDial] button foreground when opened.
  ///
  /// The [SpeedDial] foreground will animate to this color when the user
  /// opens the speed dial.
  final Color? openForegroundColor;

  /// The color of the [SpeedDial] button background when closed.
  ///
  /// The [SpeedDial] background will animate to this color when the user
  /// closes the speed dial.
  final Color? closedBackgroundColor;

  /// The color of the [SpeedDial] button background when open.
  ///
  /// The [SpeedDial] background will animate to this color when the user
  /// opens the speed dial.
  final Color? openBackgroundColor;

  @override
  State<StatefulWidget> createState() {
    return _SpeedDialState();
  }
}

class _SpeedDialState extends State<SpeedDial> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _foregroundColorAnimation;
  final List<Animation<double>> _speedDialChildAnimations = <Animation<double>>[];

  @override
  void initState() {
    _animationController =
        widget.controller ?? AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _backgroundColorAnimation = ColorTween(
      begin: widget.closedBackgroundColor,
      end: widget.openBackgroundColor,
    ).animate(_animationController);

    _foregroundColorAnimation = ColorTween(
      begin: widget.closedForegroundColor,
      end: widget.openForegroundColor,
    ).animate(_animationController);

    final double fractionOfOneSpeedDialChild = 1.0 / widget.speedDialChildren.length;
    for (int speedDialChildIndex = 0; speedDialChildIndex < widget.speedDialChildren.length; ++speedDialChildIndex) {
      final List<TweenSequenceItem<double>> tweenSequenceItems = <TweenSequenceItem<double>>[];

      final double firstWeight = fractionOfOneSpeedDialChild * speedDialChildIndex;
      if (firstWeight > 0.0) {
        tweenSequenceItems.add(TweenSequenceItem<double>(
          tween: ConstantTween<double>(0.0),
          weight: firstWeight,
        ));
      }

      tweenSequenceItems.add(TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: fractionOfOneSpeedDialChild,
      ));

      final double lastWeight =
          fractionOfOneSpeedDialChild * (widget.speedDialChildren.length - 1 - speedDialChildIndex);
      if (lastWeight > 0.0) {
        tweenSequenceItems.add(TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: lastWeight));
      }

      _speedDialChildAnimations.insert(0, TweenSequence<double>(tweenSequenceItems).animate(_animationController));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int speedDialChildAnimationIndex = 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!_animationController.isDismissed)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: widget.speedDialChildren.map<Widget>((SpeedDialChild speedDialChild) {
                final Widget speedDialChildWidget = Opacity(
                  opacity: _speedDialChildAnimations[speedDialChildAnimationIndex].value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0 - 4.0),
                        child: Card(
                          elevation: 6.0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Text(
                              speedDialChild.label!,
                              style: widget.labelsStyle,
                            ),
                          ),
                        ),
                      ),
                      ScaleTransition(
                        scale: _speedDialChildAnimations[speedDialChildAnimationIndex],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: FloatingActionButton(
                            heroTag: speedDialChildAnimationIndex,
                            mini: true,
                            child: speedDialChild.child,
                            foregroundColor: speedDialChild.foregroundColor,
                            backgroundColor: speedDialChild.backgroundColor,
                            onPressed: () {
                              if (speedDialChild.closeSpeedDialOnPressed) {
                                _animationController.reverse();
                              }
                              speedDialChild.onPressed.call();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                speedDialChildAnimationIndex++;
                return speedDialChildWidget;
              }).toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FloatingActionButton(
            child: widget.child,
            foregroundColor: _foregroundColorAnimation.value,
            backgroundColor: _backgroundColorAnimation.value,
            onPressed: () {
              if (_animationController.isDismissed) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            },
          ),
        )
      ],
    );
  }
}
