import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_event.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';
import 'package:tic_tac_app/ui_funcs.dart';

class ListeningEventForSnackBar extends StatelessWidget {
  const ListeningEventForSnackBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serverBloc = context.read<ServerBloc>();
    return MultiBlocListener(
      listeners: [
        //* LISTEN INVITATION
        BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) {
            if (previous is ServerConnectedState &&
                current is ServerConnectedState) {
              return previous.invitations != current.invitations;
            } else {
              return previous.runtimeType != current.runtimeType;
            }
          },
          listener: (context, state) {
            if (state is ServerConnectedState) {
              if (state.invitations.isNotEmpty) {
                final lastInvitation = state.invitations.last;
                String message =
                    'Игрок ${lastInvitation.name ?? lastInvitation.initiatorCode.toString()} ';
                if (lastInvitation.name != null) {
                  message += '(${lastInvitation.initiatorCode.toString()}) ';
                }
                message += 'пригласил вас в игру';
                showGetSnackBar(
                  context,
                  message,
                  from: SnackPosition.TOP,
                  duration: const Duration(seconds: 7),
                  buttonText: 'Принять',
                  onButtonTap: () => serverBloc
                      .add(ServerSendAcceptEvent(lastInvitation.initiatorCode)),
                );
              }
            }
          },
          child: Container(),
        ),
        //* LISTEN ERROR ON ACCEPT
        BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) {
            if (previous is ServerConnectedState &&
                current is ServerConnectedState) {
              return previous.errorsInAccept != current.errorsInAccept;
            } else {
              return previous.runtimeType != current.runtimeType;
            }
          },
          listener: (context, state) {
            if (state is ServerConnectedState) {
              if (state.errorsInAccept.isNotEmpty) {
                final lastError = state.errorsInAccept.last;
                String message =
                    'Ошибка при принятии приглашения: ${lastError.errorRu}';
                if (lastError.code == 921) {
                  message += '\nВозможно, игрок уже отключился';
                }
                showGetSnackBar(
                  context,
                  message,
                  from: SnackPosition.TOP,
                  duration: const Duration(seconds: 5),
                  textColor: Colors.red,
                );
              }
            }
          },
          child: Container(),
        ),
        //* LISTEN ERROR ON MOVE
        BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) {
            if (previous is ServerConnectedState &&
                current is ServerConnectedState) {
              if (previous.game != null && current.game != null) {
                return previous.game!.errorsOnMove !=
                    current.game!.errorsOnMove;
              } else {
                return previous.runtimeType != current.runtimeType;
              }
            } else {
              return previous.runtimeType != current.runtimeType;
            }
          },
          listener: (context, state) {
            if (state is ServerConnectedState) {
              if (state.game != null) {
                if (state.game!.errorsOnMove.isNotEmpty) {
                  final lastError = state.game!.errorsOnMove.last;
                  String message =
                      'Ошибка при попытке хода: ${lastError.errorRu}';
                  showGetSnackBar(
                    context,
                    message,
                    from: SnackPosition.TOP,
                    duration: const Duration(seconds: 3),
                    textColor: Colors.red,
                  );
                }
              }
            }
          },
          child: Container(),
        ),
        //* LISTEN GAME START
        BlocListener<ServerBloc, ServerState>(
          listenWhen: (previous, current) {
            if (previous is ServerConnectedState &&
                current is ServerConnectedState) {
              return previous.game == null && current.game != null;
            } else {
              return previous.runtimeType != current.runtimeType;
            }
          },
          listener: (context, state) {
            if (state is ServerConnectedState) {
              if (state.game != null) {
                Get.closeAllSnackbars();
              }
            }
          },
          child: Container(),
        ),
      ],
      child: Container(),
    );
  }
}
