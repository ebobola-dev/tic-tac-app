import 'package:flutter/material.dart';
import 'package:tic_tac_app/models/coords.dart';
import 'package:tic_tac_app/models/game.dart';
import 'package:tic_tac_app/models/invitation.dart';
import 'package:tic_tac_app/models/move.dart';
import 'package:tic_tac_app/models/reasons_for_ending.dart';
import 'package:tic_tac_app/models/server_errors.dart';

@immutable
abstract class ServerEvent {}

//* FROM UI
class ServerTryConnectEvent extends ServerEvent {}

class ServerSendNewNameEvent extends ServerEvent {
  final String newName;
  ServerSendNewNameEvent(this.newName);
}

class ServerSendInvitationEvent extends ServerEvent {
  final int code;
  ServerSendInvitationEvent(this.code);
}

class ServerSendAcceptEvent extends ServerEvent {
  final int initiatorCode;
  ServerSendAcceptEvent(this.initiatorCode);
}

//* FROM SERVER BLOC
class ServerConnectedEvent extends ServerEvent {}

class ServerDisconnectedEvent extends ServerEvent {
  final bool byLost;
  ServerDisconnectedEvent({this.byLost = false});
}

class ServerOnlineCountChangeEvent extends ServerEvent {
  final int newOnlineCount;
  ServerOnlineCountChangeEvent(this.newOnlineCount);
}

class ServerInGameCountChangeEvent extends ServerEvent {
  final int newInGameCount;
  ServerInGameCountChangeEvent(this.newInGameCount);
}

class ServerCodeReceivedEvent extends ServerEvent {
  final int code;
  ServerCodeReceivedEvent(this.code);
}

class ServerChangeNameEvent extends ServerEvent {
  final int code;
  final String newName;
  ServerChangeNameEvent(this.code, this.newName);
}

class ServerAddInitationEvent extends ServerEvent {
  final Invitation newInvitation;
  ServerAddInitationEvent(this.newInvitation);
}

class ServerAddErrorInAcceptEvent extends ServerEvent {
  final ServerError newError;
  ServerAddErrorInAcceptEvent(this.newError);
}

class ServerExitFromGameEvent extends ServerEvent {}

class ServerTryMoveEvent extends ServerEvent {
  final Coords coords;
  ServerTryMoveEvent(this.coords);
}

//* GAME EVENTS
class ServerEnterTheGameEvent extends ServerEvent {
  final Game game;
  ServerEnterTheGameEvent(this.game);
}

class ServerExitTheGameEvent extends ServerEvent {}

class ServerGameMoveEvent extends ServerEvent {
  final Move move;
  ServerGameMoveEvent(this.move);
}

class ServerGameAddMoveErrorEvent extends ServerEvent {
  final ServerError error;
  ServerGameAddMoveErrorEvent(this.error);
}

class ServerGameEndEvent extends ServerEvent {
  final ReasonsForEnding reason;
  ServerGameEndEvent(this.reason);
}
