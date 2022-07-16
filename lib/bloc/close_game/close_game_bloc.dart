import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_event.dart';
import 'package:tic_tac_app/bloc/close_game/close_game_state.dart';

class CloseGameBloc extends Bloc<CloseGameEvent, CloseGameState> {
  Timer? timer;
  CloseGameBloc() : super(const CloseGameState(seconds: 10, started: false)) {
    on<CloseGameStartEvent>((event, emit) {
      emit(const CloseGameState(seconds: 10, started: true));
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (state.seconds > 0) {
          add(CloseGameTickEvent());
        } else {
          add(CloseGameStopEvent());
        }
      });
    });

    on<CloseGameStopEvent>((event, emit) {
      emit(const CloseGameState(seconds: 10, started: false));
      timer?.cancel();
    });

    on<CloseGameTickEvent>((event, emit) {
      if (state.seconds > 0) {
        emit(state.copyWith(seconds: state.seconds - 1));
      } else {
        emit(state.copyWith(seconds: 10, started: false));
      }
    });
  }
}
