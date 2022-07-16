import 'package:equatable/equatable.dart';

class CloseGameState extends Equatable {
  final int seconds;
  final bool started;
  const CloseGameState({required this.seconds, required this.started});

  @override
  List<Object> get props => [seconds, started];

  CloseGameState copyWith({
    int? seconds,
    bool? started,
  }) =>
      CloseGameState(
        seconds: seconds ?? this.seconds,
        started: started ?? this.started,
      );
}
