import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tic_tac_app/config.dart';

class ZeroCard extends StatefulWidget {
  final bool rivals;
  const ZeroCard({Key? key, required this.rivals}) : super(key: key);

  @override
  State<ZeroCard> createState() => _ZeroCardState();
}

class _ZeroCardState extends State<ZeroCard> with TickerProviderStateMixin {
  late final AnimationController _circleController;

  late final Animation<double> _circleAnimation;

  @override
  void initState() {
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _circleAnimation = Tween(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_circleController)
      ..addListener(() => setState(() {}));
    _animate();
    super.initState();
  }

  @override
  void dispose() {
    _circleController.dispose();
    super.dispose();
  }

  _animate() async {
    _circleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ZeroDrawPaint(
        color: widget.rivals ? Config.rivalItemColor : Config.ourItemColor,
        cellWidth: (MediaQuery.of(context).size.width - 65) / 3,
        size_: _circleAnimation.value,
      ),
      child: Container(),
    );
  }
}

class ZeroDrawPaint extends CustomPainter {
  final double cellWidth;
  final Color color;
  final double size_;
  ZeroDrawPaint({
    required this.cellWidth,
    required this.color,
    required this.size_,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cellWidth / 2, cellWidth / 2),
        width: cellWidth - 32.5,
        height: cellWidth - 32.5,
      ),
      -math.pi / 2,
      size_,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
