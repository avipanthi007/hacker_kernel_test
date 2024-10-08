import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:hacker_kernel_test/core/localStorage/init_shared_pref.dart';
import 'package:hacker_kernel_test/core/localStorage/token.dart';
import 'package:hacker_kernel_test/core/utils/init_controllers.dart';
import 'package:hacker_kernel_test/features/auth/view/pages/login_screen.dart';
import 'package:hacker_kernel_test/features/home/view/pages/home-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPref.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    initControllers();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          cardColor: Colors.white,
          cardTheme: CardTheme(
            surfaceTintColor: Colors.white,
            color: Colors.grey.shade200,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
          )),
      home: FutureBuilder(
        future: SharedPrefToken().fetchToken(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return LoginScreen();
          } else if (snapshot.data != null) {
            return HomeScreen();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
