import 'package:flutter/material.dart';
import 'package:tic_tac_app/config.dart';

ThemeData getThemeData(BuildContext context) => ThemeData.light().copyWith(
      primaryColor: ThemeColors.primary,
      secondaryHeaderColor: ThemeColors.secondary,
      backgroundColor: ThemeColors.background,
      scaffoldBackgroundColor: ThemeColors.background,
      dividerColor: const Color.fromRGBO(220, 220, 220, 1),
      iconTheme: const IconThemeData(color: ThemeColors.primary),
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Montserrat',
            bodyColor: ThemeColors.text,
          ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        color: ThemeColors.secondary,
        iconTheme: IconThemeData(color: ThemeColors.text),
        titleTextStyle: TextStyle(
          color: ThemeColors.text,
          fontFamily: "Montserrat",
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: ThemeColors.text),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: "Montserrat",
          ),
          elevation: 3,
          primary: ThemeColors.primary,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          onSurface: ThemeColors.disable,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: "Montserrat",
            color: ThemeColors.primary,
            fontSize: 16.0,
          ),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: ThemeColors.primary,
        secondary: ThemeColors.secondary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          color: ThemeColors.text,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none,
        ),
        fillColor: ThemeColors.secondary,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: ThemeColors.chip,
        deleteIconColor: ThemeColors.primary,
        shadowColor: Colors.black,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: ThemeColors.snack,
        contentTextStyle: TextStyle(
          fontSize: 18.0,
          fontFamily: "Montserrat",
          color: ThemeColors.text,
        ),
      ),
      dialogBackgroundColor: ThemeColors.background,
      dialogTheme: const DialogTheme(
        alignment: Alignment.center,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          color: ThemeColors.text,
          fontFamily: "Montserrat",
        ),
      ),
    );
