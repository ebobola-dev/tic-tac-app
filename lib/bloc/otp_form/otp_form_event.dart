import 'package:flutter/material.dart';

@immutable
abstract class OtpFormEvent {}

//* FROM UI
class OtpFormChangeEvent extends OtpFormEvent {
  final int index;
  final int? newValue;
  OtpFormChangeEvent(this.index, this.newValue);
}

//* FROM SERVER BLOC
class OtpFormClearEvent extends OtpFormEvent {}
