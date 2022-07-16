import 'package:tic_tac_app/models/server_errors.dart';

abstract class InvitationProcessState {}

class InvitationProcessNormalState extends InvitationProcessState {}

class InvitationProcessSentState extends InvitationProcessState {}

class InvitationProcessSuccessfullyState extends InvitationProcessState {
  final int friendCode;
  final String? friendName;
  InvitationProcessSuccessfullyState(this.friendCode, this.friendName);
}

class InvitationProcessErrorState extends InvitationProcessState {
  final ServerError error;
  InvitationProcessErrorState(this.error);
}
