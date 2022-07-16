import 'package:equatable/equatable.dart';
import 'package:tic_tac_app/models/coords.dart';
import 'package:tic_tac_app/models/item.dart';
import 'package:tic_tac_app/models/item_of_field.dart';
import 'package:tic_tac_app/models/move.dart';
import 'package:tic_tac_app/models/reasons_for_ending.dart';
import 'package:tic_tac_app/models/server_errors.dart';

class Game extends Equatable {
  final String gameId;
  final bool finished;
  final String ourSid;
  final int ourCode;
  final String rivalSid;
  final int rivalCode;
  final String? rivalName;
  final Item rivalMark;
  final Item ourMark;
  final bool nowOurMove;
  final List<ServerError> errorsOnMove;
  final ReasonsForEnding? reasonForEnding;
  final List<List<ItemOfField>> items;

  const Game({
    required this.gameId,
    this.finished = false,
    required this.ourSid,
    required this.ourCode,
    required this.rivalSid,
    required this.rivalCode,
    this.rivalName,
    required this.rivalMark,
    required this.ourMark,
    required this.nowOurMove,
    this.errorsOnMove = const [],
    this.reasonForEnding,
    this.items = const [
      [
        ItemOfField(item: Items.none, coords: Coords(0, 0)),
        ItemOfField(item: Items.none, coords: Coords(0, 1)),
        ItemOfField(item: Items.none, coords: Coords(0, 2)),
      ],
      [
        ItemOfField(item: Items.none, coords: Coords(1, 0)),
        ItemOfField(item: Items.none, coords: Coords(1, 1)),
        ItemOfField(item: Items.none, coords: Coords(1, 2)),
      ],
      [
        ItemOfField(item: Items.none, coords: Coords(2, 0)),
        ItemOfField(item: Items.none, coords: Coords(2, 1)),
        ItemOfField(item: Items.none, coords: Coords(2, 2)),
      ],
    ],
  });

  @override
  List<Object?> get props => [
        gameId,
        finished,
        ourSid,
        ourCode,
        rivalSid,
        rivalCode,
        rivalName,
        rivalMark,
        ourMark,
        errorsOnMove,
        reasonForEnding,
        nowOurMove,
        items,
      ];

  Game copyWith({
    bool? finished,
    String? rivalName,
    Move? newMove,
    ServerError? newError,
    ReasonsForEnding? reasonForEnding,
    bool? nowOurMove,
  }) =>
      Game(
        gameId: gameId,
        finished: finished ?? this.finished,
        ourSid: ourSid,
        ourCode: ourCode,
        rivalSid: rivalSid,
        rivalCode: rivalCode,
        rivalName: rivalName ?? this.rivalName,
        rivalMark: rivalMark,
        ourMark: ourMark,
        items: items,
        errorsOnMove:
            newError != null ? errorsOnMove + [newError] : errorsOnMove,
        reasonForEnding: reasonForEnding ?? this.reasonForEnding,
        nowOurMove: nowOurMove ?? this.nowOurMove,
      );

  Game copyWithNewItem({
    required ItemOfField newItem,
  }) =>
      Game(
        gameId: gameId,
        finished: finished,
        ourSid: ourSid,
        ourCode: ourCode,
        rivalSid: rivalSid,
        rivalCode: rivalCode,
        rivalName: rivalName,
        rivalMark: rivalMark,
        ourMark: ourMark,
        errorsOnMove: errorsOnMove,
        reasonForEnding: reasonForEnding,
        nowOurMove: newItem.rivals!,
        items: [
          [
            newItem.coords == const Coords(0, 0) ? newItem : items[0][0],
            newItem.coords == const Coords(0, 1) ? newItem : items[0][1],
            newItem.coords == const Coords(0, 2) ? newItem : items[0][2],
          ],
          [
            newItem.coords == const Coords(1, 0) ? newItem : items[1][0],
            newItem.coords == const Coords(1, 1) ? newItem : items[1][1],
            newItem.coords == const Coords(1, 2) ? newItem : items[1][2],
          ],
          [
            newItem.coords == const Coords(2, 0) ? newItem : items[2][0],
            newItem.coords == const Coords(2, 1) ? newItem : items[2][1],
            newItem.coords == const Coords(2, 2) ? newItem : items[2][2],
          ],
        ],
      );

  factory Game.newFromJson(Map json, int ourCode, int rivalCode) => Game(
        gameId: json['game_id'],
        ourSid: json['players_info']['sids'][ourCode.toString()],
        ourCode: ourCode,
        rivalSid: json['players_info']['sids'][rivalCode.toString()],
        rivalCode: rivalCode,
        rivalMark: Item.fromString(
            json['players_info']['marks'][rivalCode.toString()]),
        ourMark:
            Item.fromString(json['players_info']['marks'][ourCode.toString()]),
        rivalName: json['players_info']['names'][rivalCode.toString()],
        nowOurMove: json['move_now'] == ourCode,
      );
}
