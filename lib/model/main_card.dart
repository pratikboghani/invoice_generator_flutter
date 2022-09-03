import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/components/constant.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'data_card.dart';

class MainCard extends StatelessWidget {
  const MainCard({
    Key? key,
    required this.tev,
    required this.QntController,
    required this.PriceController,
  }) : super(key: key);

  final TextEditingValue tev;
  final TextEditingController QntController;
  final TextEditingController PriceController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: xCardBackgroundColor,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Autocomplete(
            onSelected: (String Selection) {
              itemNameList.insert(cards.length - 1, Selection);

              print('---------------------------');
              print('');
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
              txtcontroller = controller;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  controller: controller,
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
          Row(
            children: [
              Expanded(
                child: DataCard(
                  myController: QntController,
                  labelText: 'Quantity',
                  hintText: 'Enter quantity.',
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  inputFormate: [],
                ),
              ),
              Expanded(
                child: DataCard(
                  myController: PriceController,
                  labelText: 'Price',
                  hintText: 'Enter price.',
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  inputFormate: [],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
