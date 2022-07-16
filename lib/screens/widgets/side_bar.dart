import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';
import 'package:tic_tac_app/bloc/settings/settings_bloc.dart';
import 'package:tic_tac_app/bloc/settings/settings_event.dart';
import 'package:tic_tac_app/bloc/settings/settings_state.dart';

class SideBar extends StatefulWidget {
  final VoidCallback onCheckUpdate;
  const SideBar({Key? key, required this.onCheckUpdate}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _lottieController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SizedBox(
        width: screenWidth * .8,
        child: Drawer(
          backgroundColor: Theme.of(context).backgroundColor,
          child: ListView(
            children: [
              SizedBox(
                height: screenWidth * .8,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).chipTheme.backgroundColor,
                  ),
                  child: BlocBuilder<ServerBloc, ServerState>(
                    buildWhen: (previous, current) =>
                        previous.runtimeType != current.runtimeType,
                    builder: (context, state) {
                      if (state is ServerConnectedState) {
                        return Column(
                          children: [
                            Lottie.asset(
                              'assets/lottie/connected.json',
                              controller: _lottieController,
                              width: screenWidth * .6,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Соединение установлено",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                FaIcon(
                                  FontAwesomeIcons.checkDouble,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Lottie.asset('assets/lottie/404_glitch.json');
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Text(
                      "Онлайн: ",
                      style: TextStyle(fontSize: 17.0),
                    ),
                    BlocBuilder<ServerBloc, ServerState>(
                      buildWhen: (previous, current) {
                        if (previous is ServerConnectedState &&
                            current is ServerConnectedState) {
                          return previous.serverOnlineCount !=
                              current.serverOnlineCount;
                        } else {
                          return previous.runtimeType != current.runtimeType;
                        }
                      },
                      builder: (context, state) {
                        if (state is ServerConnectedState) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Text(
                              state.serverOnlineCount?.toString() ?? '???',
                              key: ValueKey(state.serverOnlineCount.toString()),
                              style: TextStyle(
                                fontSize: 17.0,
                                color: state.serverOnlineCount == null
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color
                                    : Colors.green,
                              ),
                            ),
                          );
                        } else {
                          return Lottie.asset(
                            'assets/lottie/404_glitch.json',
                            height: 20,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Text(
                      "В игре: ",
                      style: TextStyle(fontSize: 17.0),
                    ),
                    BlocBuilder<ServerBloc, ServerState>(
                      buildWhen: (previous, current) {
                        if (previous is ServerConnectedState &&
                            current is ServerConnectedState) {
                          return previous.serverInGameCount !=
                              current.serverInGameCount;
                        } else {
                          return previous.runtimeType != current.runtimeType;
                        }
                      },
                      builder: (context, state) {
                        if (state is ServerConnectedState) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              state.serverInGameCount?.toString() ?? '???',
                              key: ValueKey(state.serverInGameCount.toString()),
                              style: TextStyle(
                                fontSize: 17.0,
                                color: state.serverInGameCount == null
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        } else {
                          return Lottie.asset(
                            'assets/lottie/404_glitch.json',
                            height: 20,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) => SwitchListTile(
                  title: const Text(
                    "Сохранять имя",
                    style: TextStyle(fontSize: 17.0),
                  ),
                  value: settingsState.savingName,
                  onChanged: (newSaving) => context
                      .read<SettingsBloc>()
                      .add(SettingsChangeSavingNameEvent(newSaving)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: widget.onCheckUpdate,
                child: const Text("Проверить обновления"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
