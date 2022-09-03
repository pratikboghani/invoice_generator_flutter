import 'package:flutter/material.dart';
import 'package:invoice_generator/components/constant.dart';
import 'package:invoice_generator/screen/entry_tab_screen.dart';

import 'item_tab_screen.dart';

class MainTabScr extends StatefulWidget {
  static String id = 'MainTabScr';

  @override
  State<MainTabScr> createState() => _MainTabScrState();
}

class _MainTabScrState extends State<MainTabScr> {
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
            title: Hero(tag: 'excel', child: Text('EXCEL INFOSYS')),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Items',
                ),
                Tab(text: 'Entry')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ItemTab(),
              EntryTab(),
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
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
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
