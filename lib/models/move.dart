import 'package:equatable/equatable.dart';
import 'package:tic_tac_app/models/coords.dart';

class Move extends Equatable {
  final String sid;
  final Coords coords;
  const Move({required this.sid, required this.coords});

  @override
  List<Object> get props => [sid, coords];

  factory Move.fromJson(json) => Move(
        sid: json['sid'],
        coords: Coords.fromJson(json['coords']),
      );
}
