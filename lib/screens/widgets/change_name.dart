import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_bloc.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_event.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_event.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';
import 'package:tic_tac_app/screens/sub_screens/invite/widgets/change_name_button.dart';
import 'package:tic_tac_app/screens/widgets/auto_scroll_text.dart';

class ChangeName extends StatelessWidget {
  ChangeName({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final serverBloc = context.read<ServerBloc>();
    final changeNameBloc = context.read<ChangeNameBloc>();
    return Column(
      children: [
        BlocBuilder<ServerBloc, ServerState>(
          builder: (context, state) {
            if (state.runtimeType != ServerConnectedState) {
              return Lottie.asset(
                'assets/lottie/404_glitch.json',
              );
            }
            final state_ = state as ServerConnectedState;
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Text(
                    'Ваше имя:',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: AutoScrollText(
                        text: state_.ourName ?? 'Не указано',
                        key: ValueKey(state_.ourName),
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        BlocBuilder<ServerBloc, ServerState>(
          buildWhen: (previous, current) {
            if (previous is ServerConnectedState &&
                current is ServerConnectedState) {
              return (previous.ourName == null) != (current.ourName == null);
            }
            return previous.runtimeType != current.runtimeType;
          },
          builder: (context, serverStateON) {
            if (serverStateON is ServerConnectedState) {
              return TextField(
                onChanged: (_) =>
                    changeNameBloc.add(ChangeNameSetNormalEvent()),
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: const Color(0xFFCED7E8),
                  hintText: serverStateON.ourName == null
                      ? 'Введите ваше имя'
                      : 'Вы можете изменить имя',
                  hintStyle: const TextStyle(color: Color(0xFFA1A9BB)),
                  suffixIcon: ChangeNameButton(
                    onTap: () {
                      if (_nameController.text.isNotEmpty) {
                        serverBloc.add(
                          ServerSendNewNameEvent(_nameController.text),
                        );
                      }
                    },
                    onSuccessfully: () => _nameController.clear(),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
