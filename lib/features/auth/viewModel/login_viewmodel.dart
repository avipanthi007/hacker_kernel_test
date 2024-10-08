import 'package:get/get.dart';
import 'package:hacker_kernel_test/core/localStorage/token.dart';
import 'package:hacker_kernel_test/features/auth/repository/login_repo.dart';
import 'package:hacker_kernel_test/features/home/view/pages/home-screen.dart';

class LoginViewmodel extends GetxController {
  LoginRepo loginRepo = LoginRepo();
  Rx<bool> loading = false.obs;
  Future loginUser({required String email, required String password}) async {
    loading.value = true;
    final res = await loginRepo.login(email: email, password: password);
    loading.value = false;

    if (res != null) {
      SharedPrefToken().saveToken(res);
      Get.off(HomeScreen());
    }
  }
}
