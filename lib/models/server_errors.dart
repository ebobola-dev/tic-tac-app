import 'package:equatable/equatable.dart';

class ServerError extends Equatable {
  final String error;
  final String errorRu;
  final int code;

  const ServerError({
    required this.error,
    required this.errorRu,
    required this.code,
  });

  @override
  List<Object> get props => [code];

  factory ServerError.fromJson(json) => ServerError(
        error: json['error'],
        errorRu: json['error_ru'],
        code: json['error_code'],
      );
}
