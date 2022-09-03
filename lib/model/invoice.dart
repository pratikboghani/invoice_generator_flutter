import 'package:invoice_generator/model/customer.dart';
import 'package:invoice_generator/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  //final String description; //Estimate Description below heading ESTIMATE
  final String number; //Estimate number
  final DateTime date; // Estimate Date
  //final DateTime dueDate;

  const InvoiceInfo({
    //required this.description,
    required this.number,
    required this.date,
    //required this.dueDate,
  });
}

class InvoiceItem {
  final int no;
  final String ItemName;
  final String ItemCode;
  final int quantity;
  //final double gst;
  final double unitPrice;

  const InvoiceItem({
    required this.no,
    required this.ItemName,
    required this.ItemCode,
    required this.quantity,
    //required this.gst,
    required this.unitPrice,
  });
}
