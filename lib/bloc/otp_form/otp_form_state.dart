import 'package:equatable/equatable.dart';

class OtpFormState extends Equatable {
  final List<int?> code;
  const OtpFormState({
    this.code = const [null, null, null, null],
  });

  @override
  List<Object?> get props => [code];

  bool get filled => code.where((element) => element != null).length == 4;
  bool get clean => code.where((element) => element == null).length == 4;

  int getNumber() => int.parse('${code[0]}${code[1]}${code[2]}${code[3]}');

  OtpFormState copyWith(int index, int? value) => OtpFormState(code: [
        index == 0 ? value : code[0],
        index == 1 ? value : code[1],
        index == 2 ? value : code[2],
        index == 3 ? value : code[3],
      ]);
}
