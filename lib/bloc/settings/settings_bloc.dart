import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_app/bloc/settings/settings_event.dart';
import 'package:tic_tac_app/bloc/settings/settings_state.dart';
import 'package:tic_tac_app/pref/saving_name.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(bool savingName)
      : super(
          SettingsState(savingName: savingName),
        ) {
    on<SettingsChangeSavingNameEvent>((event, emit) {
      emit(state.copyWith(savingName: event.newSaving));
      SavingNamePref.save(event.newSaving);
    });
  }
}
