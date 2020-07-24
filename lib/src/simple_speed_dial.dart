import 'package:flutter/material.dart';

import 'simple_speed_dial_child.dart';

class SpeedDial extends StatefulWidget {
  const SpeedDial({
    this.child,
    this.speedDialChildren,
    this.labelsStyle,
    this.controller,
    this.closedForegroundColor,
    this.openForegroundColor,
    this.closedBackgroundColor,
    this.openBackgroundColor,
  });

  final Widget child;

  final List<SpeedDialChild> speedDialChildren;

  final TextStyle labelsStyle;

  final AnimationController controller;

  final Color closedForegroundColor;

  final Color openForegroundColor;

  final Color closedBackgroundColor;

  final Color openBackgroundColor;

  @override
  State<StatefulWidget> createState() {
    return _SpeedDialState();
  }
}

class _SpeedDialState extends State<SpeedDial> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _backgroundColorAnimation;
  Animation<Color> _foregroundColorAnimation;
  List<Animation<double>> _speedDialChildAnimations = <Animation<double>>[];

  @override
  void initState() {
    _animationController = (widget.controller ??
        AnimationController(vsync: this, duration: const Duration(milliseconds: 450)))
      ..addListener(() => setState(() {}));

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

  void _onChildPressed(speedDialChild) {
    if (speedDialChild.closeSpeedDialOnPressed) {
      _animationController.reverse();
    }
    speedDialChild.onPressed?.call();
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
              children: widget.speedDialChildren?.map<Widget>((SpeedDialChild speedDialChild) {
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
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  _onChildPressed(speedDialChild);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    speedDialChild.label,
                                    style: widget.labelsStyle,
                                  ),
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
                                  _onChildPressed(speedDialChild);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    speedDialChildAnimationIndex++;
                    return speedDialChildWidget;
                  })?.toList() ??
                  <Widget>[],
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
