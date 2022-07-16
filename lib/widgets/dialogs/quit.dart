import 'package:flutter/material.dart';
import 'package:tic_tac_app/widgets/animations/scale_on_create.dart';

class QuitDialog extends StatelessWidget {
  final VoidCallback onExit;
  const QuitDialog({
    Key? key,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleOnCreate(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .75,
            child: AlertDialog(
              title: Text(
                "Вы действительно хотите покинуть игру?".toUpperCase(),
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              contentPadding: const EdgeInsets.all(8.0),
              titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              actionsPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              actions: [
                TextButton(
                  onPressed: () {
                    onExit();
                    Navigator.pop(context);
                  },
                  child: Text("Выйти".toUpperCase()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Отмена".toUpperCase()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
