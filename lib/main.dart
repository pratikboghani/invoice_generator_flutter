import 'package:flutter/material.dart';
import 'package:invoice_generator/screen/home_screen.dart';
import 'package:invoice_generator/screen/loading_screen.dart';
import 'package:invoice_generator/screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoadinScreen.id,
      routes: {
        LoadinScreen.id: (context) => LoadinScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        MainTabScr.id: (context) => MainTabScr(),
      },
    );
  }
}
