import 'package:equatable/equatable.dart';

class Coords extends Equatable {
  final int x;
  final int y;

  const Coords(this.x, this.y);
  @override
  List<Object> get props => [x, y];

  factory Coords.fromJson(json) => Coords(json['x'], json['y']);

  Map<String, int> toJson() => {'x': x, 'y': y};
}
