import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool savingName;
  const SettingsState({
    required this.savingName,
  });

  @override
  List<Object?> get props => [savingName];

  SettingsState copyWith({
    bool? savingName,
  }) =>
      SettingsState(
        savingName: savingName ?? this.savingName,
      );
}
