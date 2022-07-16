import 'package:flutter/material.dart';

@immutable
abstract class CloseGameEvent {}

class CloseGameStartEvent extends CloseGameEvent {}

class CloseGameStopEvent extends CloseGameEvent {}

//* INTERNAL
class CloseGameTickEvent extends CloseGameEvent {}
