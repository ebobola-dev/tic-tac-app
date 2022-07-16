import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_bloc.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_bloc.dart';
import 'package:tic_tac_app/bloc/invitation_process/invitation_process_bloc.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_event.dart';
import 'package:tic_tac_app/bloc/settings/settings_bloc.dart';
import 'package:tic_tac_app/pref/saving_name.dart';
import 'package:tic_tac_app/screens/main_screen.dart';
import 'package:tic_tac_app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  final bool? savingName = await SavingNamePref.read();
  runApp(MyApp(savingName: savingName ?? false));
}

class MyApp extends StatelessWidget {
  final bool savingName;
  const MyApp({Key? key, required this.savingName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChangeNameBloc(),
        ),
        BlocProvider(
          create: (context) => OtpFormBloc(),
        ),
        BlocProvider(
          create: (context) => InvitationProcessBloc(),
        ),
        BlocProvider(
          create: (context) => CloseGameBloc(),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(savingName),
        ),
      ],
      child: Builder(builder: (context) {
        final changeNameBloc = context.read<ChangeNameBloc>();
        final otpFormBloc = context.read<OtpFormBloc>();
        final invitationProcessBloc = context.read<InvitationProcessBloc>();
        final closeGameBloc = context.read<CloseGameBloc>();
        final settingsBloc = context.read<SettingsBloc>();
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ServerBloc(
                changeNameBloc: changeNameBloc,
                otpFormBloc: otpFormBloc,
                invitationProcessBloc: invitationProcessBloc,
                closeGameBloc: closeGameBloc,
                settingsBloc: settingsBloc,
              )..add(ServerTryConnectEvent()),
            ),
          ],
          child: GetMaterialApp(
            title: 'Twister App',
            debugShowCheckedModeBanner: false,
            theme: getThemeData(context),
            initialRoute: "/start",
            routes: {
              "/start": (context) => const MainScreen(),
            },
          ),
        );
      }),
    );
  }
}
