import 'package:flutter/material.dart';
import 'package:invoice_generator/components/utils.dart';
import 'package:invoice_generator/model/note.dart';

import '../components/constant.dart';
import '../components/pdf_maker.dart';
import '../db/database_helper.dart';
import '../model/data_card.dart';

class EntryTab extends StatefulWidget {
  @override
  State<EntryTab> createState() => _EntryTabState();
}

class _EntryTabState extends State<EntryTab> {
  late DatabaseHelper dbHelper;

  late var itemNameController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemQuantityController = TextEditingController();
  final CustomerNameController = TextEditingController();
  final CustomerAddressController = TextEditingController();
  List<String> iname = [];
  List<String> iprice = [];
  List<String> iquantity = [];
  void addToList() {
    setState(() {
      iname.add(itemNameController.text);
      iquantity.add(itemQuantityController.text);
      iprice.add(itemPriceController.text);
    });
  }

  void clearController() {
    setState(() {
      itemNameController.clear();
      itemPriceController.clear();
      itemQuantityController.clear();
      CustomerNameController.clear();
      CustomerAddressController.clear();
    });
  }

  void deleteitem(int index) {
    iname.removeAt(index);
    iquantity.removeAt(index);
    iprice.removeAt(index);
  }

  void clearList() {
    setState(() {
      iname.clear();
      iquantity.clear();
      iprice.clear();
    });
  }

  _getInvData() async {
    List<InvoiceData> x = await dbHelper.fetchInvoice();
    for (var i in x) {
      invYear = int.parse(i.iYear);
      invNumber = int.parse(i.iNumber);
      print('inv year::::::::::::::::: $invYear');
    }
  }

  _updateInvData() async {
    await _getInvData();
    // if (int.parse(invYear) < int.parse(DateTime.now().year.toString())) {
    //   invNumber = 1;
    // } else {
    //   invNumber = invNumber + 1;
    // }

    await dbHelper.updateInvoice(InvoiceData(
        iNumber: invNumber.toString(), iYear: DateTime.now().year.toString()));
  }

  @override
  void initState() {
    setState(() {
      dbHelper = DatabaseHelper.instance;
      _getInvData();
      //_updateInvData();
    });
    super.initState();
  }

  void showPopUp() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      elevation: 10,
      enableDrag: true,
      isDismissible: false,
      isScrollControlled: true,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(35.0),
      // ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.5,
          decoration: BoxDecoration(
              borderRadius:
                  new BorderRadius.vertical(top: const Radius.circular(35.0)),
              color: xCardBackgroundColor),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DataCard(
                        myController: CustomerNameController,
                        labelText: 'Customer',
                        hintText: 'Estimate for',
                        keyboardType: TextInputType.text,
                        inputFormate: [],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FloatingActionButton(
                        heroTag: 'go',
                        backgroundColor: xAppBarColor,
                        onPressed: () async {
                          //addCards();
                          //showPopUp();

                          await _updateInvData();

                          generatePDF(
                              iname,
                              iprice,
                              iquantity,
                              CustomerNameController.text,
                              CustomerAddressController.text);
                          Navigator.pop(context);
                        },
                        child: Text('GO'),
                      ),
                    ),
                  ],
                ),
              ),
              DataCard(
                myController: CustomerAddressController,
                labelText: 'Address',
                hintText: 'Customer address',
                keyboardType: TextInputType.text,
                inputFormate: [],
              ),

              // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Autocomplete(
            onSelected: (String Selection) {
              //itemNameList.insert(cards.length - 1, Selection);

              print('---------------------------');
              print(Selection);
            },
            optionsBuilder: (tev) {
              if (tev.text.isEmpty) {
                return const Iterable<String>.empty();
              } else {
                return autoComplateData.where((word) =>
                    word.toLowerCase().contains(tev.text.toLowerCase()));
              }
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
              itemNameController = controller;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  controller: itemNameController,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: xAppBarColor),
                    ),
                    labelText: 'Item Name',
                    hintText: "Enter item name",
                    counterText: '',
                    hintStyle: TextStyle(fontSize: 15),
                    labelStyle: TextStyle(color: xAppBarColor),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DataCard(
                    myController: itemQuantityController,
                    labelText: 'Quantity',
                    hintText: 'Enter quantity.',
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    inputFormate: [],
                  ),
                ),
                Expanded(
                  child: DataCard(
                    myController: itemPriceController,
                    labelText: 'Price',
                    hintText: 'Enter price.',
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    inputFormate: [],
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'go',
                  backgroundColor: xAppBarColor,
                  onPressed: () {
                    //addCards();
                    if (iname.isEmpty) {
                      final snackBar = SnackBar(
                        content: Text('Item List is Empty'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      showPopUp();
                    }
                    //generatePDF(iname, iprice, iquantity);
                  },
                  child: Text('GO'),
                ),
                SizedBox(
                  width: 8,
                ),
                FloatingActionButton(
                  backgroundColor: xAppBarColor,
                  onPressed: () {
                    //addCards();
                    if (itemNameController.text.isEmpty ||
                        itemQuantityController.text.isEmpty ||
                        itemPriceController.text.isEmpty) {
                      final snackBar = SnackBar(
                        content: Text('Enter Valid Inputs'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      addToList();
                    }
                    clearController();
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            //child: Text('Hekk'),
            child: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: iname.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      //elevation: 2,

                      title: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(iname[index]),
                      ),

                      onTap: () {
                        setState(() {
                          //print(iname[index].toString());
                          // itemController.text = itemList[index].iName;
                          //dbHelper.delete(itemList[index].iName);
                          //_refreshItems();
                        });
                      },

                      trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              // dbHelper.delete(itemList[index].iName);
                              // _refreshItems();
                              deleteitem(index);
                            });
                          }),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            '${iquantity[index]} * ₹${iprice[index]} = ₹${int.parse(iquantity[index]) * int.parse(iprice[index])}'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: xAppBarColor,
        onPressed: () {
          clearList();
          clearController();
        },
        child: Icon(Icons.cleaning_services),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
