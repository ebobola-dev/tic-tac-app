import 'package:equatable/equatable.dart';

class Invitation extends Equatable {
  final int initiatorCode;
  final String? name;
  const Invitation(this.initiatorCode, this.name);

  @override
  List<Object?> get props => [initiatorCode, name];

  factory Invitation.fromJson(Map json) => Invitation(
        json['initiator_code'],
        json['initiator_name'],
      );
}
