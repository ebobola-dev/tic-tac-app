import 'package:flutter/material.dart';
import 'package:tic_tac_app/models/coords.dart';
import 'package:tic_tac_app/screens/sub_screens/game/widgets/item_card.dart';

class Field extends StatelessWidget {
  const Field({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width - 65,
      //width: MediaQuery.of(context).size.width - 65,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.32),
      ),
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        children: const [
          ...[
            ItemCard(coords: Coords(0, 0)),
            ItemCard(coords: Coords(0, 1)),
            ItemCard(coords: Coords(0, 2)),
          ],
          ...[
            ItemCard(coords: Coords(1, 0)),
            ItemCard(coords: Coords(1, 1)),
            ItemCard(coords: Coords(1, 2)),
          ],
          ...[
            ItemCard(coords: Coords(2, 0)),
            ItemCard(coords: Coords(2, 1)),
            ItemCard(coords: Coords(2, 2)),
          ],
        ],
      ),
    );
  }
}
