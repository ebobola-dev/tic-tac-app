import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_app/bloc/invitation_process/invitation_process_event.dart';
import 'package:tic_tac_app/bloc/invitation_process/invitation_process_state.dart';

class InvitationProcessBloc
    extends Bloc<InvitationProcessEvent, InvitationProcessState> {
  InvitationProcessBloc() : super(InvitationProcessNormalState()) {
    //* FROM UI
    on<InvitationProcessSetNormalEvent>((event, emit) {
      emit(InvitationProcessNormalState());
    });

    //* FROM SERVER BLOC
    on<InvitationProcessSendEvent>((event, emit) {
      emit(InvitationProcessSentState());
    });

    on<InvitationProcessSuccessfullyEvent>((event, emit) {
      emit(InvitationProcessSuccessfullyState(
        event.friendCode,
        event.friendName,
      ));
    });

    on<InvitationProcessErrorEvent>((event, emit) {
      emit(InvitationProcessErrorState(event.error));
    });
  }
}
