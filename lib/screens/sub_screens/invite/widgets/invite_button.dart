import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tic_tac_app/bloc/invitation_process/invitation_process_bloc.dart';
import 'package:tic_tac_app/bloc/invitation_process/invitation_process_state.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_bloc.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_state.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_event.dart';
import 'package:tic_tac_app/ui_funcs.dart';

class InviteButton extends StatelessWidget {
  const InviteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serverBloc = context.read<ServerBloc>();
    return SizedBox(
      width: MediaQuery.of(context).size.width * .6,
      child: BlocBuilder<OtpFormBloc, OtpFormState>(
        builder: (context, otpState) => ElevatedButton(
          onPressed: otpState.filled
              ? () {
                  serverBloc.add(ServerSendInvitationEvent(
                      context.read<OtpFormBloc>().state.getNumber()));
                  FocusScope.of(context).unfocus();
                }
              : null,
          child: BlocConsumer<InvitationProcessBloc, InvitationProcessState>(
              listener: (context, state) {
            if (state is InvitationProcessSuccessfullyState) {
              String message =
                  'Игрок ${state.friendName ?? state.friendCode.toString()} ';
              if (state.friendName != null) {
                message += '(${state.friendCode.toString()}) ';
              }
              message += 'успешно приглашён';
              showGetSnackBar(
                context,
                message,
                from: SnackPosition.TOP,
                textColor: Colors.green,
              );
            } else if (state is InvitationProcessErrorState) {
              showGetSnackBar(
                context,
                'Ошибка при приглашении: ' + state.error.errorRu,
                from: SnackPosition.TOP,
                textColor: Colors.red,
              );
            }
          }, builder: (context, inviteState) {
            if (inviteState is InvitationProcessSentState) {
              return LinearProgressIndicator(
                color: Theme.of(context).secondaryHeaderColor,
                backgroundColor: Theme.of(context).primaryColor,
              );
            } else {
              return const Text("Пригласить");
            }
          }),
        ),
      ),
    );
  }
}
