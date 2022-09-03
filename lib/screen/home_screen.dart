import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice_generator/components/constant.dart';
import 'package:invoice_generator/model/note.dart';

import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../components/pdf_maker.dart';
import '../model/customer.dart';
import '../model/data_card.dart';
import '../model/invoice.dart';
import '../model/main_card.dart';
import '../model/supplier.dart';
import '../db/database_helper.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final tev = TextEditingValue();
  final QntController = TextEditingController();
  final PriceController = TextEditingController();
  final itemController = TextEditingController();
  List<TextEditingValue> _tev = [];
  List<TextEditingController> _qntControllers = [];
  List<TextEditingController> _priceControllers = [];

  late DatabaseHelper dbHelper;

  void addCards() {
    setState(() {
      _tev.add(new TextEditingValue());

      _qntControllers.add(new TextEditingController());
      _priceControllers.add(new TextEditingController());
      cards.add(
        MainCard(
            tev: _tev[cards.length],
            QntController: _qntControllers[cards.length],
            PriceController: _priceControllers[cards.length]),
      );
    });
  }

  void disposeController() {
    for (int i = 0; i < _qntControllers.length; i++) {
      // _nameControllers[i].dispose();
      itemNameList.removeAt(i);
      _tev.removeAt(i);
      _qntControllers[i].dispose();
      _priceControllers[i].dispose();
    }
  }

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
    addCards();

    super.initState();
    setState(() {
      dbHelper = DatabaseHelper.instance;
      _refreshItems();
    });
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          drawer: Column(
            children: [
              Expanded(
                child: Drawer(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: xAppBarColor,
                      height: kBottomNavigationBarHeight,
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: kBottomNavigationBarHeight / 4),
                        child: Text(
                          'EXCEL INFOSYS',
                          style: TextStyle(
                              color: xAppBarTextColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: xAppBarColor),
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
                                await dbHelper
                                    .insert(Item(iName: itemController.text));
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
                )),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
          appBar: AppBar(
            backgroundColor: xAppBarColor,
            title: Text('EXCEL INFOSYS'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      cards.clear();
                      itemNameList.clear();
                      _tev.clear();
                      _priceControllers.clear();
                      _qntControllers.clear();
                      disposeController();
                      //addCards();
                    });
                  },
                  child: Icon(Icons.replay_sharp),
                ),
              )
            ],
          ),
          body: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return cards[index];
            },
          ),
          bottomNavigationBar: Material(
              color: xAppBarColor,
              child: InkWell(
                onTap: () async {
                  itemlist.clear();
                  int cnt = 1;
                  for (var i in cards) {
                    itemlist.add(InvoiceItem(
                      no: cnt,
                      ItemCode: '',
                      ItemName: itemNameList[cards.indexOf(i)].toString(),
                      quantity: int.parse(i.QntController.text),
                      //gst: 0.19,
                      unitPrice: double.parse(i.PriceController.text),
                    ));
                    cnt++;
                  }
                  //final pdfFile = await PdfInvoiceApi.generate(invoice);
                  //PdfApi.openFile(pdfFile);
                },
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: xAppBarTextColor,
                          fontSize: kToolbarHeight / 2,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )),
          floatingActionButton: FloatingActionButton(
            backgroundColor: xAppBarColor,
            onPressed: () {
              addCards();
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
