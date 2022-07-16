import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_event.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_state.dart';

class OtpFormBloc extends Bloc<OtpFormEvent, OtpFormState> {
  OtpFormBloc() : super(const OtpFormState()) {
    //* FROM UI
    on<OtpFormChangeEvent>((event, emit) {
      emit(state.copyWith(event.index, event.newValue));
    });

    //* FROM SERVER BLOC
    on<OtpFormClearEvent>((event, emit) {
      emit(const OtpFormState());
    });
  }
}
