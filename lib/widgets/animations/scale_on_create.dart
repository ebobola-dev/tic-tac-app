import 'package:flutter/material.dart';

class ScaleOnCreate extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ScaleOnCreate({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => ScaleOnCreateState();
}

class ScaleOnCreateState extends State<ScaleOnCreate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
