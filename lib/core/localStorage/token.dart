import 'package:hacker_kernel_test/core/localStorage/init_shared_pref.dart';

class SharedPrefToken {
  saveToken(String value) async {
    await SharedPref.preferences.setString('token', value);
  }

  Future<String?> fetchToken() async {
    return await SharedPref.preferences.getString('token');
  }

  removeToken() {
    SharedPref.preferences.remove('token');
  }
}
