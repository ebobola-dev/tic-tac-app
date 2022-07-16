import 'package:equatable/equatable.dart';
import 'package:tic_tac_app/models/game.dart';
import 'package:tic_tac_app/models/invitation.dart';
import 'package:tic_tac_app/models/server_errors.dart';

abstract class ServerState extends Equatable {}

class ServerConnectingState extends ServerState {
  @override
  List<Object> get props => [];
}

class ServerConnectedState extends ServerState {
  final int? serverOnlineCount;
  final int? serverInGameCount;
  final int? ourCode;
  final String? ourName;
  final Game? game;
  final List<Invitation> invitations;
  final List<ServerError> errorsInAccept;

  ServerConnectedState({
    this.serverOnlineCount,
    this.serverInGameCount,
    this.ourCode,
    this.ourName,
    this.invitations = const [],
    this.errorsInAccept = const [],
    this.game,
  });

  @override
  List<Object?> get props => [
        serverOnlineCount,
        serverInGameCount,
        ourCode,
        ourName,
        invitations,
        errorsInAccept,
        game
      ];

  ServerConnectedState copyWith({
    int? serverOnlineCount,
    int? serverInGameCount,
    int? ourCode,
    String? ourName,
  }) =>
      ServerConnectedState(
        serverOnlineCount: serverOnlineCount ?? this.serverOnlineCount,
        serverInGameCount: serverInGameCount ?? this.serverInGameCount,
        ourCode: ourCode ?? this.ourCode,
        ourName: ourName ?? this.ourName,
        invitations: invitations,
        errorsInAccept: errorsInAccept,
        game: game,
      );

  ServerConnectedState copyWithNewInvitation(Invitation newInvitation) =>
      ServerConnectedState(
        serverOnlineCount: serverOnlineCount,
        serverInGameCount: serverInGameCount,
        ourCode: ourCode,
        ourName: ourName,
        invitations: invitations + [newInvitation],
        errorsInAccept: errorsInAccept,
        game: game,
      );

  ServerConnectedState copyWithNewErrorInAccept(ServerError newError) =>
      ServerConnectedState(
        serverOnlineCount: serverOnlineCount,
        serverInGameCount: serverInGameCount,
        ourCode: ourCode,
        ourName: ourName,
        invitations: invitations,
        errorsInAccept: errorsInAccept + [newError],
        game: game,
      );

  ServerConnectedState copyWithNewGame(Game? newGame_) => ServerConnectedState(
        serverOnlineCount: serverOnlineCount,
        serverInGameCount: serverInGameCount,
        ourCode: ourCode,
        ourName: ourName,
        invitations: invitations,
        errorsInAccept: errorsInAccept,
        game: newGame_,
      );
}

class ServerDisconnectedState extends ServerState {
  final bool byLost;
  ServerDisconnectedState({this.byLost = false});
  @override
  List<Object> get props => [byLost];
}
