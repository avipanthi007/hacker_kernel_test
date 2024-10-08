import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences preferences;
  static Future init() async {
    preferences = await SharedPreferences.getInstance();
  }
}
