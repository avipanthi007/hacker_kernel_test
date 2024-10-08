import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hacker_kernel_test/features/auth/view/widgets/custom_button.dart';
import 'package:hacker_kernel_test/features/auth/view/widgets/repeated_text_field.dart';
import 'package:hacker_kernel_test/features/auth/viewModel/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final loginViewmodel = Get.find<LoginViewmodel>();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => SystemNavigator.pop(),
      child: Form(
        key: globalKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Center(child: Image.asset("assets/images/login_logo.png")),
                    SizedBox(height: 50),
                    Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 32),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.alternate_email,
                          color: Colors.grey,
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RepeatedTextField(
                            validator: (val) => val == ""
                                ? "Please enter an email address"
                                : null,
                            controller: _emailController,
                            hint: "Email ID",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 25,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RepeatedTextField(
                            validator: (val) =>
                                val == "" ? "Please enter a Password" : null,
                            isVisible: !isVisible,
                            controller: _passwordController,
                            hint: "Password",
                            sufix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                        onTap: () {
                          if (globalKey.currentState!.validate()) {
                            loginViewmodel.loginUser(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                        child: CustomButton(
                            color: Colors.blue.shade700,
                            item: Obx(
                              () => loginViewmodel.loading.value
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                            ))),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          " OR ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 150,
                          child: Divider(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                        onTap: () {},
                        child: CustomButton(
                          color: Colors.grey.shade300,
                          item: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 20),
                              Image.asset(
                                  "assets/images/google-removebg-preview.png"),
                              SizedBox(width: 60),
                              Center(
                                child: Text(
                                  "Login with Google",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New to Logistics?"),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
