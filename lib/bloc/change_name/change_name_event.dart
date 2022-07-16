import 'package:flutter/material.dart';

@immutable
abstract class ChangeNameEvent {}

//* FROM UI
class ChangeNameSetNormalEvent extends ChangeNameEvent {}

//* FROM SERVER BLOC
class ChangeNameSendEvent extends ChangeNameEvent {}

class ChangeNameSuccessfullyEvent extends ChangeNameEvent {}

class ChangeNameErrorEvent extends ChangeNameEvent {}
