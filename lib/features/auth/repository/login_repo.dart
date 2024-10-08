import 'dart:convert';

import 'package:hacker_kernel_test/core/failure/server_exception.dart';
import 'package:hacker_kernel_test/core/network/api_urls.dart';
import 'package:hacker_kernel_test/core/network/http_wrapper.dart';
import 'package:hacker_kernel_test/core/utils/constants/custom_snackbar.dart';

class LoginRepo {
  Future<String?> login(
      {required String email, required String password}) async {
    try {
      final res = await HttpWrapper.postRequest(
          login_url, {"email": email, "password": password});
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return data['token'];
      } else {
        customSnackbar(data['error']);
      }
    } on ServerException catch (e) {
      customSnackbar(e.message);
    }
    return null;
  }
}
