import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_bloc.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_state.dart';

class ChangeNameButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onSuccessfully;
  const ChangeNameButton({
    Key? key,
    required this.onTap,
    required this.onSuccessfully,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BlocConsumer<ChangeNameBloc, ChangeNameState>(
          listener: (context, changeNameState) {
        if (changeNameState is ChangeNameSuccessfullyState) {
          onSuccessfully();
        }
      }, builder: (context, changeNameState) {
        if (changeNameState is ChangeNameNormalState) {
          return const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: FaIcon(
              FontAwesomeIcons.paperPlane,
              size: 32.0,
            ),
          );
        } else if (changeNameState is ChangeNameSentState) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 6.0, top: 4.0),
            child: Lottie.asset(
              'assets/lottie/circle_loading.json',
              width: 26,
              height: 26,
            ),
          );
        } else if (changeNameState is ChangeNameSuccessfullyState) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 6.0, top: 4.0),
            child: Lottie.asset(
              'assets/lottie/success.json',
              repeat: false,
              width: 26,
              height: 26,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 6.0, top: 4.0),
            child: Lottie.asset(
              'assets/lottie/fail.json',
              repeat: false,
              width: 26,
              height: 26,
            ),
          );
        }
      }),
    );
  }
}
