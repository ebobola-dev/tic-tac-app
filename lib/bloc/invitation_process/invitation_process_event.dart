import 'package:flutter/material.dart';
import 'package:tic_tac_app/models/server_errors.dart';

@immutable
abstract class InvitationProcessEvent {}

//* FROM UI
class InvitationProcessSetNormalEvent extends InvitationProcessEvent {}

//* FROM SERVER BLOC
class InvitationProcessSendEvent extends InvitationProcessEvent {}

class InvitationProcessSuccessfullyEvent extends InvitationProcessEvent {
  final int friendCode;
  final String? friendName;
  InvitationProcessSuccessfullyEvent(this.friendCode, this.friendName);
}

class InvitationProcessErrorEvent extends InvitationProcessEvent {
  final ServerError error;
  InvitationProcessErrorEvent(this.error);
}
