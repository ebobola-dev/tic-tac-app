import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_bloc.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_event.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_state.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';
import 'package:tic_tac_app/screens/sub_screens/invite/widgets/invite_button.dart';
import 'package:tic_tac_app/screens/sub_screens/invite/widgets/opt_form.dart';
import 'package:tic_tac_app/screens/widgets/change_name.dart';

class InviteSubScreen extends StatefulWidget {
  const InviteSubScreen({Key? key}) : super(key: key);

  @override
  State<InviteSubScreen> createState() => _InviteSubScreenState();
}

class _InviteSubScreenState extends State<InviteSubScreen> {
  final GlobalKey<OtpFormWidgetState> _otpFormWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: BlocBuilder<ServerBloc, ServerState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (context, globalState) {
          if (globalState.runtimeType != ServerConnectedState) {
            return Lottie.asset(
              'assets/lottie/404_glitch.json',
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<ServerBloc, ServerState>(
                      builder: (context, state) {
                        final state_ = state as ServerConnectedState;
                        return Text(
                          'Ваш код: ' + (state_.ourCode?.toString() ?? '???'),
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100.0),
                    Column(
                      children: [
                        const Text(
                          'Введите код друга, чтобы поиграть с ним:',
                          style: TextStyle(fontSize: 17.0),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        OtpForm(key: _otpFormWidgetKey),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: BlocBuilder<OtpFormBloc, OtpFormState>(
                            builder: (context, otpState) {
                              return ElevatedButton(
                                onPressed: otpState.clean
                                    ? null
                                    : () {
                                        context
                                            .read<OtpFormBloc>()
                                            .add(OtpFormClearEvent());
                                        _otpFormWidgetKey
                                            .currentState?.firstDigitFocusNode
                                            .requestFocus();
                                      },
                                child: const Text("Отчистить"),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const InviteButton(),
                      ],
                    ),
                  ],
                ),
              ),
              ChangeName(),
            ],
          );
        },
      ),
    );
  }
}
