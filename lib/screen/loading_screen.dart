import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:invoice_generator/db/database_helper.dart';

import '../components/constant.dart';
import 'home_screen.dart';
import 'main_screen.dart';

class LoadinScreen extends StatefulWidget {
  static String id = 'LoadingScreen';

  @override
  State<LoadinScreen> createState() => _LoadinScreenState();
}

class _LoadinScreenState extends State<LoadinScreen> {
  @override
  void initState() {
    timer();
    fetchdata();

    super.initState();
  }

  Future fetchdata() async {
    final String strData = await rootBundle.loadString("assets/data.json");
    final List<dynamic> json = jsonDecode(strData);
    final List<String> jsonStrData = json.cast<String>();
    // setState(() {
    //   autoComplateData = jsonStrData;
    // });
  }

  void timer() async {
    try {
      await Future.delayed(const Duration(seconds: 2), () {
        print('22222');
      });

      Navigator.pushReplacementNamed(
          context,
          //HomeScreen.id,
          MainTabScr.id);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCubeGrid(
              color: xAppBarColor,
              size: 30,
            ),
            Hero(
              tag: 'excel',
              child: Text(
                'EXCEL INFOSYS',
                style: TextStyle(color: xAppBarColor, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
