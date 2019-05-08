import 'package:flutter_web/material.dart';
import 'package:taptaptap2_web/widget/shape_widget.dart';

class ScaleFadeAnimation extends StatelessWidget {
  ScaleFadeAnimation({
    Key key,
    @required this.controller,
    @required this.child,
  })  : opacity = Tween<double>(
          begin: 1.0,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.linear,
          ),
        ),
        size = Tween<double>(
          begin: 0.0,
          end: ShapeWidget.SIZE,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.fastLinearToSlowEaseIn,
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.only(
            left: ShapeWidget.SIZE / 2,
            top: ShapeWidget.SIZE / 2,
          ),
          end: const EdgeInsets.only(
            left: 0,
            top: 0,
          ),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.fastLinearToSlowEaseIn,
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<EdgeInsets> padding;
  final Animation<double> size;
  final Widget child;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: padding.value,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: size.value,
          height: size.value,
          child: this.child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
