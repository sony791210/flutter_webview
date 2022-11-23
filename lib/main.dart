import 'package:flutter/material.dart';

// import 'package:flutter_app/screen/Home.dart';
// import 'package:flutter_app/screen/LoginScreen.dart';
import "controller/login.dart";
import "controller/webview.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp
    (
        debugShowCheckedModeBanner: false,
        title: 'Qlinx智慧雲霧平台',
        theme: new ThemeData(
        primarySwatch: Colors.blue,
    ),

      routes: {
    /**
     * 命名导航路由，启动程序默认打开的是以'/'对应的界面LoginScreen()
     * 凡是后面使用Navigator.of(context).pushNamed('/Home')，都会跳转到Home()，
     */
        '/': (BuildContext context) => new LoginScreen(),
        '/Home': (BuildContext context) => new WebviewScreen(),

    },
    );
  }
}