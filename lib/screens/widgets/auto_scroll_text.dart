import 'dart:async';

import 'package:flutter/material.dart';

class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration scrollDuration;
  const AutoScrollText({
    Key? key,
    required this.text,
    required this.style,
    this.scrollDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  final _scrollController = ScrollController();
  Timer? _scrollTimer;

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        _scrollTimer?.cancel();
        _scrollTimer = Timer(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: widget.scrollDuration,
            curve: Curves.linear,
          );
        });
      }
      if (_scrollController.offset ==
          _scrollController.position.minScrollExtent) {
        _scrollTimer?.cancel();
        _scrollTimer = Timer(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: widget.scrollDuration,
            curve: Curves.linear,
          );
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: widget.scrollDuration,
        curve: Curves.linear,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
      ),
    );
  }
}
