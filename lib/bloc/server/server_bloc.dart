import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_bloc.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_event.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_bloc.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_event.dart';
import 'package:tic_tac_app/bloc/settings/settings_bloc.dart';
import 'package:tic_tac_app/models/game.dart';
import 'package:tic_tac_app/bloc/invitation_process/invitation_process_bloc.dart';
import 'package:tic_tac_app/bloc/invitation_process/invitation_process_event.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_bloc.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_event.dart';
import 'package:tic_tac_app/bloc/server/server_event.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';
import 'package:tic_tac_app/config.dart';
import 'package:tic_tac_app/models/invitation.dart';
import 'package:tic_tac_app/models/item_of_field.dart';
import 'package:tic_tac_app/models/move.dart';
import 'package:tic_tac_app/models/reasons_for_ending.dart';
import 'package:tic_tac_app/models/server_errors.dart';
import 'package:tic_tac_app/pref/saving_name.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  //* OTHER BLOCS
  final ChangeNameBloc changeNameBloc;
  final OtpFormBloc otpFormBloc;
  final InvitationProcessBloc invitationProcessBloc;
  final CloseGameBloc closeGameBloc;
  final SettingsBloc settingsBloc;
  //*
  late Socket socket;
  Timer? connectTimer;
  ServerBloc({
    required this.changeNameBloc,
    required this.otpFormBloc,
    required this.invitationProcessBloc,
    required this.closeGameBloc,
    required this.settingsBloc,
  }) : super(ServerDisconnectedState()) {
    //* FROM UI
    on<ServerTryConnectEvent>((event, emit) {
      emit(ServerConnectingState());
      socket = io(
        Config.serverUrl,
        OptionBuilder().setTransports(['websocket']).build(),
      );
      socket.onConnect((data) async {
        log('connected with socket.id -> ${socket.id}');
        add(ServerConnectedEvent());
        if (settingsBloc.state.savingName) {
          final savedName = await SavedNamePref.read();
          if (savedName != null) {
            socket.emit("say_name", {'name': savedName});
            changeNameBloc.add(ChangeNameSendEvent());
          }
        }
      });
      socket.onDisconnect((_) {
        log('disconnected');
        add(ServerDisconnectedEvent(byLost: true));
      });
      socket.on('your_code',
          (data) => add(ServerCodeReceivedEvent(data['your_code'])));
      socket.on(
        'change_online',
        (data) => add(ServerOnlineCountChangeEvent(data['server_online'])),
      );
      socket.on(
        'change_in_game_count',
        (data) => add(ServerInGameCountChangeEvent(data['in_game_count'])),
      );
      socket.on(
        'change_name',
        (data) => add(ServerChangeNameEvent(data['code'], data['new_name'])),
      );
      socket.on(
        'failed_to_say_name',
        (data) => changeNameBloc.add(ChangeNameErrorEvent()),
      );
      socket.on('invite', (data) {
        if (state is ServerConnectedState) {
          final state_ = state as ServerConnectedState;
          if (data['initiator'] == socket.id) {
            otpFormBloc.add(OtpFormClearEvent());
            invitationProcessBloc.add(InvitationProcessSuccessfullyEvent(
                data['invited_code'], data['invited_name']));
            log('from bloc: successfully invitation(${data['invited_name'] ?? data['invited_code']})');
          } else if (data['invited_code'] == state_.ourCode &&
              state_.ourCode != null) {
            log('from bloc: we are invited by (${data['initiator_name'] ?? data['initiator_code']})');
            add(ServerAddInitationEvent(Invitation.fromJson(data)));
          }
        }
      });
      socket.on('failed_to_invite', (data) {
        invitationProcessBloc
            .add(InvitationProcessErrorEvent(ServerError.fromJson(data)));
      });
      socket.on('start_game', (data) {
        closeGameBloc.add(CloseGameStopEvent());
        if (state is ServerConnectedState) {
          final state_ = state as ServerConnectedState;
          final ourCode = state_.ourCode!;
          final Map codesMap = data['players_info']['codes'];
          final codesList = codesMap.values.toList();
          final int rivalCode =
              codesList.firstWhere((element) => element != ourCode);
          add(
            ServerEnterTheGameEvent(
              Game.newFromJson(data, ourCode, rivalCode),
            ),
          );
        }
      });
      socket.on('failed_to_accept', (data) {
        log('fail to invite: $data');
        add(ServerAddErrorInAcceptEvent(ServerError.fromJson(data)));
      });
      socket.on('move', (data) {
        add(ServerGameMoveEvent(Move.fromJson(data)));
      });
      socket.on('failed_to_move', (data) {
        add(ServerGameAddMoveErrorEvent(ServerError.fromJson(data)));
      });
      socket.on('draw', (data) {
        log('draw: $data');
        add(ServerGameEndEvent(ReasonsForEnding.draw));
        closeGameBloc.add(CloseGameStartEvent());
      });
      socket.on('win', (data) {
        log('win: $data');
        if (state is ServerConnectedState) {
          final state_ = state as ServerConnectedState;
          if (state_.game != null) {
            if (data['winner'] == socket.id) {
              add(ServerGameEndEvent(ReasonsForEnding.win));
              closeGameBloc.add(CloseGameStartEvent());
            } else if (data['winner'] == state_.game!.rivalSid) {
              add(ServerGameEndEvent(ReasonsForEnding.lose));
              closeGameBloc.add(CloseGameStartEvent());
            }
          }
        }
      });
      socket.on('win_by_disconnected', (data) {
        log('win_by_disconnected: $data');
        add(ServerGameEndEvent(ReasonsForEnding.rivalDisconnected));
        closeGameBloc.add(CloseGameStartEvent());
      });
      socket.on('win_by_left_the_game', (data) {
        log('win_by_left_the_game: $data');
        add(ServerGameEndEvent(ReasonsForEnding.rivalLeftTheGame));
        closeGameBloc.add(CloseGameStartEvent());
      });
      log('connecting...');
      socket.connect();
      connectTimer = Timer(const Duration(seconds: 15), () {
        socket.disconnect();
        add(ServerDisconnectedEvent());
      });
    });

    on<ServerSendNewNameEvent>((event, emit) {
      socket.emit("say_name", {'name': event.newName});
      changeNameBloc.add(ChangeNameSendEvent());
    });

    on<ServerSendInvitationEvent>((event, emit) {
      socket.emit('invite', {
        'friend_code': event.code,
      });
      invitationProcessBloc.add(InvitationProcessSendEvent());
    });

    on<ServerSendAcceptEvent>((event, emit) {
      socket.emit('accept', {
        'initiator_code': event.initiatorCode,
      });
    });

    on<ServerExitFromGameEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        if (state_.game != null) {
          socket.emit('left_the_game', {
            'game_id': state_.game!.gameId,
          });
          add(ServerExitTheGameEvent());
        }
      }
    });

    on<ServerTryMoveEvent>((event, emit) {
      log('move');
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        if (state_.game != null) {
          socket.emit('move', {
            'game_id': state_.game!.gameId,
            'coords': event.coords.toJson(),
          });
        }
      }
    });

    //* FROM BLOC
    on<ServerConnectedEvent>((event, emit) {
      connectTimer?.cancel();
      emit(ServerConnectedState());
    });

    on<ServerDisconnectedEvent>((event, emit) {
      connectTimer?.cancel();
      emit(ServerDisconnectedState(byLost: event.byLost));
    });

    on<ServerOnlineCountChangeEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        emit(state_.copyWith(serverOnlineCount: event.newOnlineCount));
      }
    });

    on<ServerInGameCountChangeEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        emit(state_.copyWith(serverInGameCount: event.newInGameCount));
      }
    });

    on<ServerCodeReceivedEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        emit(state_.copyWith(ourCode: event.code));
      }
    });

    on<ServerChangeNameEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        if (state_.ourCode != null && event.code == state_.ourCode) {
          changeNameBloc.add(ChangeNameSuccessfullyEvent());
          emit(state_.copyWith(ourName: event.newName));
          if (settingsBloc.state.savingName) {
            SavedNamePref.save(event.newName);
          }
        }
        if (state_.game != null) {
          if (state_.game!.rivalCode == event.code) {
            emit(state_.copyWithNewGame(
                state_.game!.copyWith(rivalName: event.newName)));
          }
        }
      }
    });

    on<ServerAddInitationEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        emit(state_.copyWithNewInvitation(event.newInvitation));
      }
    });

    on<ServerAddErrorInAcceptEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        emit(state_.copyWithNewErrorInAccept(event.newError));
      }
    });

    //* GAME EVENTS
    on<ServerEnterTheGameEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        emit(state_.copyWithNewGame(event.game));
      }
    });

    on<ServerExitTheGameEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        emit(state_.copyWithNewGame(null));
      }
    });

    on<ServerGameMoveEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        if (state_.game != null) {
          bool rivals = event.move.sid == state_.game!.rivalSid;
          emit(state_.copyWithNewGame(
            state_.game!.copyWithNewItem(
              newItem: ItemOfField(
                item: rivals ? state_.game!.rivalMark : state_.game!.ourMark,
                rivals: rivals,
                coords: event.move.coords,
              ),
            ),
          ));
        }
      }
    });

    on<ServerGameAddMoveErrorEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        if (state_.game != null) {
          emit(state_.copyWithNewGame(
            state_.game!.copyWith(newError: event.error),
          ));
        }
      }
    });
    on<ServerGameEndEvent>((event, emit) {
      if (state is ServerConnectedState) {
        final state_ = state as ServerConnectedState;
        if (state_.game != null) {
          emit(state_.copyWithNewGame(
            state_.game!.copyWith(reasonForEnding: event.reason),
          ));
        }
      }
    });

    closeGameBloc.stream.listen((cGState) {
      if (cGState.started && cGState.seconds == 0) {
        add(ServerExitTheGameEvent());
      }
    });
  }
}
