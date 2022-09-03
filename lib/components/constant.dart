import 'package:flutter/material.dart';
import 'package:invoice_generator/db/database_helper.dart';
import 'package:pdf/pdf.dart';

import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/main_card.dart';
import '../model/note.dart';
import '../model/supplier.dart';

const xAppBarColor = Colors.teal;
var xCardBackgroundColor = Colors.teal.shade50;
const xAppBarTextColor = Colors.white;
final date = DateTime.now();
final dueDate = date.add(Duration(days: 7));
PdfColor xHeaderColor = PdfColors.deepPurple;
PdfColor xHeaderFontColor = PdfColors.white;
final List<InvoiceItem> itemlist = [];
late List<Item> itemList;
List<String> itemNameList = [];
List<String> autoComplateData = [];
final List<MainCard> cards = [];
late TextEditingController txtcontroller;

var invYear;
var invNumber;
