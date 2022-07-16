import 'package:flutter/material.dart';

@immutable
abstract class SettingsEvent {}

class SettingsChangeSavingNameEvent extends SettingsEvent {
  final bool newSaving;
  SettingsChangeSavingNameEvent(this.newSaving);
}
