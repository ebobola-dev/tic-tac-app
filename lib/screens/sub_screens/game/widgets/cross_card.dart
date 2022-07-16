import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tic_tac_app/config.dart';

class CrossCard extends StatefulWidget {
  final bool rivals;
  const CrossCard({Key? key, required this.rivals}) : super(key: key);

  @override
  State<CrossCard> createState() => _CrossCardState();
}

class _CrossCardState extends State<CrossCard> with TickerProviderStateMixin {
  late final AnimationController _cross1Controller;
  late final AnimationController _cross2Controller;

  late final Animation<double> _cross1Animation;
  late final Animation<double> _cross2Animation;

  @override
  void initState() {
    final size =
        (window.physicalSize.shortestSide / window.devicePixelRatio - 65) / 3;
    _cross1Controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _cross2Controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _cross1Animation = Tween(
      begin: size / 2,
      end: size - 32.5,
    ).animate(_cross1Controller)
      ..addListener(() => setState(() {}));
    _cross2Animation = Tween(
      begin: size / 2,
      end: size - 32.5,
    ).animate(_cross2Controller)
      ..addListener(() => setState(() {}));
    _animate();
    super.initState();
  }

  @override
  void dispose() {
    _cross1Controller.dispose();
    _cross2Controller.dispose();
    super.dispose();
  }

  _animate() async {
    await _cross1Controller.forward();
    _cross2Controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CrossDrawPaint(
        color: widget.rivals ? Config.rivalItemColor : Config.ourItemColor,
        size1: _cross1Animation.value,
        size2: _cross2Animation.value,
      ),
      child: Container(),
    );
  }
}

class CrossDrawPaint extends CustomPainter {
  final Color color;
  final double size1;
  final double size2;
  CrossDrawPaint({
    required this.color,
    required this.size1,
    required this.size2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint crossBrush = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size1, size1),
      Offset(size.width - size1, size.height - size1),
      crossBrush,
    );
    canvas.drawLine(
      Offset(size.width - size2, size2),
      Offset(size2, size.height - size2),
      crossBrush,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
