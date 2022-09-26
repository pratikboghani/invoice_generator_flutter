import 'package:flutter/material.dart';
import 'package:invoice_generator/db/database_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:async';
import 'dart:io';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/main_card.dart';
import '../model/note.dart';
import '../model/supplier.dart';

var xAppBarColor = Color(0xff008080);
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
List<String> jsonStrData = [];
int invYear = 2022;
int invNumber = 0;
final image = pw.MemoryImage(
  File('assets/images/logo.jpg').readAsBytesSync(),
);
var data = {
  "2.MP 4B08 8 CH DAHUVA DVR",
  "2.MP 4A08 8 CH DAHUVA DVR",
  "2 TB WD HDD",
  "1 TB WD HDD",
  "4 TB WD & TOSHIBA HDD",
  "8 CH POWER SUPPLY",
  "4 CH POWER SUPPLY",
  "16 CH POWER SUPPLY",
  "BNC+DC PIN",
  "SOLID 3+1 CABLE/MTR",
  "IMSTALLATION CHARGE"
};
