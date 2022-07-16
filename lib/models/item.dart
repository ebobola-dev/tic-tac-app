import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String? letterMark;
  const Item({this.letterMark});

  @override
  List<Object?> get props => [letterMark];

  factory Item.fromString(String? letterMark) => Item(
        letterMark: letterMark,
      );
}

class Items {
  static const zero = Item(letterMark: '0');
  static const cross = Item(letterMark: 'X');
  static const none = Item();
}
