import 'package:flutter/services.dart';

class Item {
  static const iname = 'iName';
  static const tblname = 'itemName';

  Item({required this.iName});
  late String iName;

  Item.fromMap(Map<String, dynamic> map) {
    iName = map[iname];
  }
  Map<String, dynamic> toMap() {
    var map = <String, String>{'iName': iName};
    return map;
  }
}

class InvoiceData {
  static const tblname = 'invoiceData';
  static const year = 'year';
  static const invoiceNumber = 'invNo';
  InvoiceData({required this.iNumber, required this.iYear});
  late String iYear;
  late String iNumber;

  InvoiceData.fromMap(Map<String, dynamic> map) {
    iYear = map[year];
    iNumber = map[invoiceNumber];
  }

  Map<String, dynamic> toMap() {
    var map = <String, String>{'year': iYear, 'invNo': iNumber};
    return map;
  }
}
