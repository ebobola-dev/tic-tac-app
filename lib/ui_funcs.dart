import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_app/models/reasons_for_ending.dart';

String getEndPhrase({required ReasonsForEnding reason, String? rivalName}) {
  switch (reason) {
    case ReasonsForEnding.win:
      return "Вы победили!";
    case ReasonsForEnding.lose:
      return "Вы проиграли(\n$rivalName победил";
    case ReasonsForEnding.draw:
      return "Ничья";
    case ReasonsForEnding.rivalDisconnected:
      return "Противник отключился, можете считать это победой";
    case ReasonsForEnding.rivalLeftTheGame:
      return "Вы победили!\nПротивник покинул игру";
  }
}

String getEndLottie(ReasonsForEnding reason) {
  switch (reason) {
    case ReasonsForEnding.win:
      return "assets/lottie/victory.json";
    case ReasonsForEnding.lose:
      return "assets/lottie/lost.json";
    case ReasonsForEnding.draw:
      return "assets/lottie/draw.json";
    case ReasonsForEnding.rivalDisconnected:
      return "assets/lottie/disconnected.json";
    case ReasonsForEnding.rivalLeftTheGame:
      return "assets/lottie/left_the_game.json";
  }
}

void showSimpleSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(milliseconds: 3000),
}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: duration,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
    ));

void showGetSnackBar(
  BuildContext context,
  String message, {
  SnackPosition from = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
  Color? textColor,
  double? fontSize,
  String? buttonText,
  VoidCallback? onButtonTap,
  Color? buttonColor,
}) {
  assert(
    buttonText != null && onButtonTap != null ||
        buttonText == null && onButtonTap == null,
  );
  Get.snackbar(
    '',
    '',
    snackPosition: from,
    snackStyle: SnackStyle.FLOATING,
    duration: duration,
    messageText: Text(
      message,
      style: TextStyle(
        color: textColor ??
            Theme.of(context).snackBarTheme.contentTextStyle!.color,
        fontSize: fontSize ??
            Theme.of(context).snackBarTheme.contentTextStyle!.fontSize,
      ),
      textAlign: onButtonTap != null ? TextAlign.left : TextAlign.center,
    ),
    titleText: Container(),
    margin: EdgeInsets.only(
      top: from == SnackPosition.TOP ? kBottomNavigationBarHeight : 0.0,
      bottom: from == SnackPosition.BOTTOM ? kBottomNavigationBarHeight : 0.0,
      left: 8,
      right: 8,
    ),
    mainButton: onButtonTap != null
        ? TextButton(
            onPressed: () {
              onButtonTap();
              Get.closeCurrentSnackbar();
            },
            child: Text(
              buttonText!,
              style: TextStyle(
                color: buttonColor ?? Theme.of(context).primaryColor,
                fontSize: 17.0,
              ),
            ),
          )
        : null,
  );
}
