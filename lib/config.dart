import 'package:flutter/material.dart';

class Config {
  static const serverDev = false;
  static const prodServerHost = 'http://194.87.144.241';
  static const devServerHost = 'http://192.168.0.13';

  static const serverUrl =
      '${serverDev ? devServerHost : prodServerHost}:4411/';
  static const checkUpdatesUrl = '${serverUrl}check_app_version';
  static const downloadAppUrl = '${serverUrl}download_mobile_app';

  static const rivalItemColor = Colors.grey;
  static const ourItemColor = Colors.green;
}

class ThemeColors {
  static const background = Color(0xFFEAEFFC);
  static const primary = Color(0xFF355BF3);
  static const secondary = Color(0xFFC3CBF1);
  static const text = Color(0xFF262F5D);
  static const chip = Color(0xFFC3CBF1);
  static const disable = Color(0xFF9CACBF);
  static const snack = Color(0xFFC3CBF1);
}

class PrefKeys {
  static const savingName = 'saving_name';
  static const savedName = 'saved_name';
}
