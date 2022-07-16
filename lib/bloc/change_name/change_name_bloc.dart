import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_event.dart';
import 'package:tic_tac_app/bloc/change_name/change_name_state.dart';

class ChangeNameBloc extends Bloc<ChangeNameEvent, ChangeNameState> {
  ChangeNameBloc() : super(ChangeNameNormalState()) {
    //* FROM UI
    on<ChangeNameSetNormalEvent>((event, emit) {
      emit(ChangeNameNormalState());
    });

    //* FROM SERVER BLOC
    on<ChangeNameSendEvent>((event, emit) {
      emit(ChangeNameSentState());
    });

    on<ChangeNameSuccessfullyEvent>((event, emit) {
      emit(ChangeNameSuccessfullyState());
    });

    on<ChangeNameErrorEvent>((event, emit) {
      emit(ChangeNameErrorState());
    });
  }
}
