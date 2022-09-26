import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:invoice_generator/components/constant.dart';
import 'package:invoice_generator/screen/entry_tab_screen.dart';

import 'item_tab_screen.dart';

class MainTabScr extends StatefulWidget {
  static String id = 'MainTabScr';

  @override
  State<MainTabScr> createState() => _MainTabScrState();
}

class _MainTabScrState extends State<MainTabScr> {
  void changeColor(Color color) {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: xAppBarColor,
            title: Text('EXCEL INFOSYS'),
            bottom: TabBar(
              indicatorColor: xAppBarColor,
              tabs: [
                Tab(
                  text: 'Entry',
                ),
                Tab(text: 'Items')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              EntryTab(),
              ItemTab(),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: xAppBarColor,
                  ),
                  accountName: Text('Jeet Boghani'),
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    child: Text(
                      'J',
                      style: TextStyle(fontSize: 45, color: xAppBarColor),
                    ),
                    backgroundColor: xCardBackgroundColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Theme'),
                            content: SingleChildScrollView(
                              child: MaterialColorPicker(
                                  selectedColor: xAppBarColor,
                                  onColorChange: (Color color) {
                                    setState(() => xAppBarColor = color);
                                  }),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'OK',
                                  ))
                            ],
                          );
                        });
                  },
                  leading: Icon(Icons.color_lens_rounded),
                  title: Text('Theme'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.info),
                  title: Text('About'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
