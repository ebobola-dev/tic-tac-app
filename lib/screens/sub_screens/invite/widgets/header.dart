import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_event.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';

class Header extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const Header({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  State<Header> createState() => HeaderState();
}

class HeaderState extends State<Header> with TickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotateAnimation = Tween(
      begin: 0.0,
      end: .5,
    ).animate(_rotateController);
    super.initState();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> animateForward() async {
    _rotateController.forward();
  }

  Future<void> animateBackward() async {
    _rotateController.animateBack(0.0);
  }

  @override
  Widget build(BuildContext context) {
    final serverBloc = context.read<ServerBloc>();
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).appBarTheme.backgroundColor!,
              offset: const Offset(.5, .5),
              blurRadius: 15.0,
              spreadRadius: 3.0,
            )
          ]),
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: BlocBuilder<ServerBloc, ServerState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (context, gloabalState) {
          final Widget child;
          if (gloabalState is ServerConnectedState) {
            child = Row(
              key: const ValueKey(1),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () =>
                      widget.scaffoldKey.currentState?.openDrawer(),
                  icon: RotationTransition(
                    turns: _rotateAnimation,
                    child: Image.asset(
                      'assets/images/menu.png',
                      width: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const FittedBox(
                  child: Text(
                    "Соединение установлено",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
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
                      return Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidCircle,
                            color: state.serverOnlineCount == null
                                ? Colors.grey
                                : Colors.green,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: animation.drive(Tween(
                                  begin: const Offset(0, -1),
                                  end: Offset.zero,
                                )),
                                child: child,
                              );
                            },
                            child: Text(
                              state.serverOnlineCount?.toString() ?? '???',
                              key: ValueKey(state.serverOnlineCount),
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            );
          } else if (gloabalState is ServerDisconnectedState) {
            child = Center(
              key: const ValueKey(2),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      gloabalState.byLost
                          ? 'Соединение с сервером потеряно('
                          : 'Не удалось соединиться с сервером(',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Lottie.asset(
                      "assets/lottie/no_connection.json",
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => serverBloc.add(ServerTryConnectEvent()),
                      child: const Text('Переподключиться'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            child = Center(
              key: const ValueKey(3),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Соединение с сервером...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Lottie.asset(
                      "assets/lottie/connecting.json",
                    ),
                  ],
                ),
              ),
            );
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: child,
          );
        },
      ),
    );
  }
}
