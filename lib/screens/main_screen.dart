import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_bloc.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_event.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';
import 'package:tic_tac_app/screens/sub_screens/game/game_sub_screen.dart';
import 'package:tic_tac_app/screens/sub_screens/invite/invite_sub_screen.dart';
import 'package:tic_tac_app/screens/sub_screens/invite/widgets/header.dart';
import 'package:tic_tac_app/screens/sub_screens/invite/widgets/listening_events.dart';
import 'package:tic_tac_app/screens/widgets/check_for_updates.dart';
import 'package:tic_tac_app/screens/widgets/side_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  static const apkName = 'tic_tac_app.apk';
  final ReceivePort _port = ReceivePort();
  final PageController _subPagesController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<HeaderState> _headerKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showCheckUpdates();
    });
    log('initState', name: 'Main_screen');
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      log('data: $data');
      if (status == DownloadTaskStatus.running) {
        log('running: ${progress.toDouble()}');
      }
      if (status == DownloadTaskStatus.failed) {
        log('failed');
      }
      if (status == DownloadTaskStatus.complete) {
        log('complete, installing');
        Navigator.pop(context);
        _installApk();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    log('disoise', name: 'Main_screen');
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<void> _installApk() async {
    final path = await apkLocalPath();
    await OpenFile.open(path + '/' + apkName);
  }

  Future<void> showCheckUpdates() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => const CheckForUpdatesSheet(),
    );
  }

  void _animateToSubPage(int page) => _subPagesController.animateToPage(
        page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SideBar(
          onCheckUpdate: () async {
            await showCheckUpdates();
          },
        ),
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            _headerKey.currentState?.animateForward();
          } else {
            _headerKey.currentState?.animateBackward();
          }
        },
        body: SafeArea(
          child: BlocConsumer<ServerBloc, ServerState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            listenWhen: (previous, current) {
              if (previous is ServerConnectedState &&
                  current is ServerConnectedState) {
                return (previous.game == null) != (current.game == null);
              }
              return previous.runtimeType != current.runtimeType;
            },
            listener: (context, serverState) {
              if (serverState is ServerConnectedState) {
                if (serverState.game != null && _subPagesController.page == 0) {
                  _animateToSubPage(1);
                }
                if (serverState.game == null && _subPagesController.page == 1) {
                  _animateToSubPage(0);
                  context.read<CloseGameBloc>().add(CloseGameStopEvent());
                }
              }
            },
            builder: (context, state) => ListView(
              physics: state is ServerConnectedState
                  ? null
                  : const NeverScrollableScrollPhysics(),
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  width: double.infinity,
                  height: state is ServerConnectedState
                      ? 70
                      : MediaQuery.of(context).size.height,
                  child: Header(key: _headerKey, scaffoldKey: _scaffoldKey),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 70 - 25,
                  width: double.infinity,
                  child: PageView(
                    controller: _subPagesController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const InviteSubScreen(),
                      GameSubScreen(
                        back: () => _animateToSubPage(0),
                      ),
                    ],
                  ),
                ),
                const ListeningEventForSnackBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
