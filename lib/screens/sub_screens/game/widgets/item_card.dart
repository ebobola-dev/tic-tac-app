import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_bloc.dart';
import 'package:tic_tac_app/bloc/server/server_event.dart';
import 'package:tic_tac_app/bloc/server/server_state.dart';
import 'package:tic_tac_app/models/coords.dart';
import 'package:tic_tac_app/models/item.dart';
import 'package:tic_tac_app/screens/sub_screens/game/widgets/cross_card.dart';
import 'package:tic_tac_app/screens/sub_screens/game/widgets/zero_card.dart';

const crossLineSize = 90.0;

class ItemCard extends StatefulWidget {
  final Coords coords;
  const ItemCard({Key? key, required this.coords}) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    final serverBloc = context.read<ServerBloc>();
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: BlocBuilder<ServerBloc, ServerState>(
        buildWhen: (previous, current) {
          if (previous is ServerConnectedState &&
              current is ServerConnectedState &&
              previous.game != null &&
              current.game != null) {
            return previous.game!.items[widget.coords.x][widget.coords.y] !=
                current.game!.items[widget.coords.x][widget.coords.y];
          }
          return previous.runtimeType != current.runtimeType;
        },
        builder: (context, state) {
          state as ServerConnectedState;
          final itemOfField =
              state.game!.items[widget.coords.x][widget.coords.y];
          if (itemOfField.item == Items.cross) {
            return CrossCard(rivals: itemOfField.rivals!);
          } else if (itemOfField.item == Items.zero) {
            return ZeroCard(rivals: itemOfField.rivals!);
          } else {
            return SizedBox(
              width: crossLineSize,
              height: crossLineSize,
              child: GestureDetector(
                onTap: () {
                  serverBloc.add(
                    ServerTryMoveEvent(widget.coords),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
