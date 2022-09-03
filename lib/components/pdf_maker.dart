import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import 'constant.dart';

void generatePDF(
    List iname, List price, List qnt, String cusName, String cusAdd) async {
  itemlist.clear();
  int cnt = 1;
  for (int i = 0; i < iname.length; i++) {
    itemlist.add(InvoiceItem(
      no: cnt,
      ItemCode: '',
      ItemName: iname[i].toString(),
      quantity: int.parse(qnt[i].toString()),
      //gst: 0.19,
      unitPrice: double.parse(price[i].toString()),
    ));
    cnt++;
  }

  final pdfFile = await PdfInvoiceApi.generate(Invoice(
      supplier: Supplier(
        name: 'Excel Infosys',
        owner: 'Jeet Boghani',
        mobNo: '+91 97236 32934',
      ),
      customer: Customer(name: cusName, address: cusAdd),
      info: InvoiceInfo(
          date: date,
          //dueDate: dueDate,
          //description: '',
          number: '${DateTime.now().year}-$invNumber'), //Estimate number
      items: itemlist));
  PdfApi.openFile(pdfFile);
}
