import 'dart:io';

import 'package:invoice_generator/api/pdf_api.dart';
import 'package:invoice_generator/components/constant.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../components/utils.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        //buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Estimate.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildOwnerDetail(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: pw.Image(image),
                // color: xHeaderColor,
                // child: BarcodeWidget(
                //   barcode: Barcode.qrCode(),
                //   data: invoice.info.number,
                // ),
              ),
            ],
          ),
          //SizedBox(height: 1 * PdfPageFormat.cm),

          Center(
            child: buildTitle(invoice),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estimate For:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    //final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Estimate Number:',
      'Date:',
      // 'Payment Terms:',
      // 'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      //paymentTerms,
      //Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildOwnerDetail(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10 * PdfPageFormat.mm,
                  color: PdfColors.deepPurple)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.owner,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 5 * PdfPageFormat.mm)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.mobNo,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 4 * PdfPageFormat.mm)),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ESTIMATE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: PdfColors.deepPurple,
            ),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          //Text(invoice.info.description),
          //SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'No',
      'Item name',
      'Item Code',
      'Quantity',
      'Price/Unit',
      //'GST',
      'Total'
    ];
    final data = invoice.items.map((item) {
      //final gstAmt = (item.unitPrice * item.gst) / 100;
      final total =
          (item.unitPrice * item.quantity); //+ (item.quantity * gstAmt);
      return [
        item.no,
        item.ItemName,
        item.ItemCode,
        //Utils.formatDate(item.date),
        '${item.quantity}',
        '${item.unitPrice}',
        //'${gstAmt.toStringAsFixed(2)}(${item.gst}%)',
        '${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle:
          TextStyle(fontWeight: FontWeight.bold, color: xHeaderFontColor),
      headerDecoration: BoxDecoration(color: xHeaderColor),
      cellHeight: 25,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.center,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final subTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        //(item.quantity * ((item.unitPrice * item.gst) / 100)))
        .reduce((item1, item2) => item1 + item2);
    //final vatPercent = invoice.items.first.gst;
    //final vat = subTotal * vatPercent;
    //final total = subTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('ESTIMATE AMOUNT IN WORDS',
                //     style: TextStyle(
                //         color: PdfColors.grey500, fontWeight: FontWeight.bold)),
                // SizedBox(height: 2 * PdfPageFormat.mm),
                Text('TERMS AND CONDITIONS',
                    style: TextStyle(
                        color: PdfColors.grey500, fontWeight: FontWeight.bold)),
                Text(
                    '80% ADVANCE PAYMANT/NO BURNING WARRANTY ON CCTV&DVR&NVR/ONLY REPLACEMENT COMPANY CONSTITUTION',
                    style: TextStyle(color: PdfColors.grey500, fontSize: 10))
              ],
            ),
          ),

          //Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Sub total',
                  value: Utils.formatPrice(subTotal.toInt()),
                  unite: true,
                ),
                // buildText(
                //   title: 'Vat ${vatPercent * 100} %',
                //   value: Utils.formatPrice(vat),
                //   unite: true,
                // ),
                // Divider(),
                // buildText(
                //   title: 'Total amount due',
                //   titleStyle: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   value: Utils.formatPrice(total),
                //   unite: true,
                // ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),

                Text(
                    '${NumberToWord().convert('en-in', subTotal.toInt()).toUpperCase()}RUPEES ONLY',
                    style: TextStyle(
                      color: PdfColors.grey500,
                    ),
                    textAlign: TextAlign.right),

                Text('*GST NOT INCLUDED',
                    style: TextStyle(
                      color: PdfColors.grey500,
                    ),
                    textAlign: TextAlign.right),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          //buildSimpleText(title: '', value: invoice.supplier.owner),
          SizedBox(height: 1 * PdfPageFormat.mm),
          //buildSimpleText(title: '', value: invoice.supplier.mobNo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
