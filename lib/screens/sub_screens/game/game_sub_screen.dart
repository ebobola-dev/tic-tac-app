import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_bloc.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_event.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_state.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_event.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';
import 'package:tic_tac_app/models/reasons_for_ending.dart';
import 'package:tic_tac_app/screens/sub_screens/game/widgets/field.dart';
import 'package:tic_tac_app/screens/widgets/auto_scroll_text.dart';
import 'package:tic_tac_app/screens/widgets/change_name.dart';
import 'package:tic_tac_app/ui_funcs.dart';
import 'package:tic_tac_app/widgets/dialogs/quit.dart';

class GameSubScreen extends StatelessWidget {
  final VoidCallback back;
  const GameSubScreen({Key? key, required this.back}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serverBloc = context.read<ServerBloc>();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: BlocBuilder<ServerBloc, ServerState>(
        buildWhen: (previous, current) {
          if (previous is ServerConnectedState &&
              current is ServerConnectedState) {
            return (previous.game == null) != (current.game == null);
          }
          return previous.runtimeType != current.runtimeType;
        },
        builder: (context, serverState) {
          if (serverState is ServerConnectedState) {
            if (serverState.game != null) {
              return BlocBuilder<ServerBloc, ServerState>(
                buildWhen: (previous, current) {
                  if (previous is ServerConnectedState &&
                      current is ServerConnectedState &&
                      previous.game != null &&
                      current.game != null) {
                    return previous.game!.reasonForEnding !=
                        current.game!.reasonForEnding;
                  }
                  return previous.runtimeType != current.runtimeType;
                },
                builder: (context, stateGE) {
                  stateGE as ServerConnectedState;
                  if (stateGE.game!.reasonForEnding == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => QuitDialog(
                                        onExit: () => serverBloc
                                            .add(ServerExitFromGameEvent()),
                                      ),
                                    ),
                                    child: const Text(
                                      "Покинуть игру",
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: BlocBuilder<ServerBloc, ServerState>(
                                        buildWhen: (previous, current) {
                                      if (previous is ServerConnectedState &&
                                          current is ServerConnectedState) {
                                        return previous.game!.rivalName !=
                                            current.game!.rivalName;
                                      }
                                      return previous.runtimeType !=
                                          current.runtimeType;
                                    }, builder: (context, serverStateRN) {
                                      serverStateRN as ServerConnectedState;
                                      String rivalName =
                                          '${serverStateRN.game!.rivalName ?? serverStateRN.game!.rivalCode.toString()} ';
                                      if (serverStateRN.game!.rivalName !=
                                          null) {
                                        rivalName +=
                                            '(${serverStateRN.game!.rivalCode}) ';
                                      }
                                      return Row(
                                        children: [
                                          const Text(
                                            'Соперник:',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: AutoScrollText(
                                                text: rivalName,
                                                key: ValueKey(rivalName),
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                                scrollDuration:
                                                    const Duration(seconds: 5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              BlocBuilder<ServerBloc, ServerState>(
                                builder: (context, serverStateOM) {
                                  serverStateOM as ServerConnectedState;
                                  return Text(
                                    serverStateOM.game!.nowOurMove
                                        ? "Сейчас ваш ход"
                                        : "Сейчас ходит соперник",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: serverStateOM.game!.nowOurMove
                                          ? Colors.green
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.5),
                                child: Field(),
                              ),
                            ],
                          ),
                        ),
                        ChangeName(),
                      ],
                    );
                  } else {
                    String rivalName =
                        '${stateGE.game!.rivalName ?? stateGE.game!.rivalCode.toString()} ';
                    if (stateGE.game!.rivalName != null) {
                      rivalName += '(${stateGE.game!.rivalCode})';
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          Text(
                            getEndPhrase(
                              reason: stateGE.game!.reasonForEnding!,
                              rivalName: rivalName,
                            ),
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 25),
                          Lottie.asset(
                            getEndLottie(stateGE.game!.reasonForEnding!),
                            width: MediaQuery.of(context).size.width * .45,
                            repeat: stateGE.game!.reasonForEnding! !=
                                ReasonsForEnding.win,
                          ),
                          const SizedBox(height: 20),
                          if (stateGE.game!.reasonForEnding !=
                              ReasonsForEnding.rivalDisconnected) ...[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .75,
                              child: ElevatedButton(
                                onPressed: () => serverBloc.add(
                                  ServerSendInvitationEvent(
                                    stateGE.game!.rivalCode,
                                  ),
                                ),
                                child: const Text("Пригласить ещё раз"),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .75,
                            child: ElevatedButton(
                              onPressed: () {
                                back();
                                context
                                    .read<CloseGameBloc>()
                                    .add(CloseGameStopEvent());
                                serverBloc.add(ServerExitTheGameEvent());
                              },
                              child: BlocBuilder<CloseGameBloc, CloseGameState>(
                                builder: (context, cGState) {
                                  return Text("Назад ${cGState.seconds}");
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            } else {
              return Lottie.asset(
                'assets/lottie/404_glitch.json',
              );
            }
          } else {
            return Lottie.asset(
              'assets/lottie/404_glitch.json',
            );
          }
        },
      ),
    );
  }
}
