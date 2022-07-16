import 'package:equatable/equatable.dart';
import 'package:tic_tac_app/models/coords.dart';
import 'package:tic_tac_app/models/item.dart';

class ItemOfField extends Equatable {
  final Item item;
  final Coords? coords;
  final bool? rivals;
  const ItemOfField({
    required this.item,
    this.coords,
    this.rivals,
  });

  @override
  List<Object?> get props => [item, coords, rivals];
}
