import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:pos01/Screen/Login.dart';
import 'package:pos01/db/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/MyHome.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  State createState() => _SplashScreen();
  }

class _SplashScreen extends State<SplashScreen>{
  bool isLogin = false;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs){
      isLogin = prefs.getBool('isLogin') ?? false;
      print('Trạng thái của isLogin: $isLogin');
    });

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Image.asset(
              'assets/images/Logo3.png',
              width: 300,
              height: 160,
            ),
          ],
        ),
        nextScreen: isLogin == true ? MyApp() : LoginPage());
  }
}
class MyApp extends StatefulWidget {
  @override
  State createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RepositoryProvider(
          create: (context) => Repository(),
          child: MyHome(),
        ));
  }
}
