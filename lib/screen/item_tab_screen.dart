import 'package:flutter/material.dart';

import '../components/constant.dart';
import '../db/database_helper.dart';
import '../model/note.dart';

class ItemTab extends StatefulWidget {
  const ItemTab({Key? key}) : super(key: key);

  @override
  State<ItemTab> createState() => _ItemTabState();
}

class _ItemTabState extends State<ItemTab> {
  late DatabaseHelper dbHelper;
  final itemController = TextEditingController();

  _refreshItems() async {
    List<Item> x = await dbHelper.fetchItems();
    setState(() {
      itemList = x;
    });
    autoComplateData.clear();
    for (var i in x) {
      autoComplateData.add(i.iName);
    }
  }

  @override
  void initState() {
    itemList = [Item(iName: 'iName')];
    //addCards();

    super.initState();
    setState(() {
      dbHelper = DatabaseHelper.instance;
      _refreshItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    //elevation: 2,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(itemList[index].iName),
                    ),
                    onTap: () {
                      setState(() {
                        // itemController.text = itemList[index].iName;
                        //dbHelper.delete(itemList[index].iName);
                        _refreshItems();
                      });
                    },
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            dbHelper.delete(itemList[index].iName);
                            _refreshItems();
                          });
                        }),
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: itemController,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: xAppBarColor),
                    ),
                    labelText: 'Item Name',
                    hintText: 'Enter name',
                    counterText: '',
                    hintStyle: TextStyle(fontSize: 15),
                    labelStyle: TextStyle(color: xAppBarColor),
                  ),
                ),
              ),
              Expanded(
                child: FloatingActionButton(
                  onPressed: () async {
                    await dbHelper.insert(Item(iName: itemController.text));
                    // await dbHelper
                    //     .update(Item(iName: itemController.text));
                    _refreshItems();

                    setState(() {
                      //itemList.add(itemController.text);
                      itemController.clear();
                    });
                  },
                  backgroundColor: xAppBarColor,
                  child: Icon(Icons.add),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
