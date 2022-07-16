import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_app/config.dart';

class SavingNamePref {
  static Future<void> save(bool saving) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefKeys.savingName, saving);
  }

  static Future<bool?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final saving = prefs.getBool(PrefKeys.savingName);
    return saving;
  }
}

class SavedNamePref {
  static Future<void> save(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.savedName, name);
  }

  static Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(PrefKeys.savedName);
    return name;
  }
}
