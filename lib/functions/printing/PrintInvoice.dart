import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';

class PrintInvoice extends StatelessWidget {
  PrintInvoice({this.invoiceId, this.customerNames, Key key}) : super(key: key);

  final String customerNames;
  final String invoiceId;
  final pdf = pw.Document();
  QuerySnapshot sales;
  QuerySnapshot products;
  int grandTotal = 0;

  Future<Uint8List> _generatePdf(PdfPageFormat format){
    pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (pw.Context context){
            return pw.Container(
              child: pw.Column(
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: pw.Container(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            "Company Information"
                            "\nName"
                            "\nAddress"
                            "\nRegistration No."
                            "\nEmail"
                            "\nPhone"
                            "\nWebsite"
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.Divider(
                    thickness: 1.0,
                  ),

                  pw.Align(
                    alignment: pw.Alignment.topLeft,
                    child: pw.Row(
                      children: [
                        pw.Align(
                          alignment: pw.Alignment.topLeft,
                          child: pw.Text(
                              "Bill to:"
                          ),
                        ),

                        pw.SizedBox(width: 20.0,),

                        pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            "Customer Information"
                            "\n$customerNames"
                            "\nAddress"
                            "\nPhone"
                          ),
                        )
                      ],
                    ),
                  ),

                  pw.Divider(
                    thickness: 1.0,
                  ),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          "Description",
                        ),
                      ),

                      pw.VerticalDivider(
                        thickness: 1.0,
                      ),

                      pw.Expanded(
                        child: pw.Text(
                            "Quantity"
                        ),
                      ),

                      pw.VerticalDivider(
                        thickness: 1.0,
                      ),

                      pw.Expanded(
                        child: pw.Text(
                            "Unit"
                        ),
                      ),

                      pw.VerticalDivider(
                        thickness: 1.0,
                      ),

                      pw.Expanded(
                        child: pw.Text(
                            "Price"
                        ),
                      ),

                      pw.VerticalDivider(
                        thickness: 1.0,
                      ),

                      pw.Expanded(
                        child: pw.Text(
                            "Amount"
                        ),
                      ),
                    ],
                  ),

                  pw.Divider(
                    thickness: 1.0,
                  ),

                  pw.ListView(
                    children: sales.docs.map(
                            (sale) {
                              String description;
                              String price;
                              int amount;

                              products.docs.map((product) {
                                if(sale.get("product_id") == product.id){
                                  description = product.get("productDescription");
                                  price = product.get("price");
                                  amount = int.parse(product.get("price"))*int.parse(sale.get("quantity"));
                                  grandTotal += amount;
                                }
                              }).toList();

                              return pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                        description
                                    ),
                                  ),
                                  pw.VerticalDivider(
                                    thickness: 1.0,
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                        sale.get("quantity")
                                    ),
                                  ),
                                  pw.VerticalDivider(
                                    thickness: 1.0,
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                        "Piece(s)"
                                    ),
                                  ),
                                  pw.VerticalDivider(
                                    thickness: 1.0,
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                        price
                                    ),
                                  ),
                                  pw.VerticalDivider(
                                    thickness: 1.0,
                                  ),
                                  pw.Expanded(
                                    child: pw.Text(
                                        amount.toString()
                                    ),
                                  ),
                                ],
                              );
                            }
                    ).toList(),
                  ),

                  pw.SizedBox(height: 10.0),

                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text(
                        "Grand total: $grandTotal TZS"
                    ),
                  ),
                ],
              ),
            );
          },
        )
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    sales = Provider.of<QuerySnapshot>(context);

    DatabaseService().store.listen((event) {products = event;});

    if(sales == null){
      return LoadingWidget("Please wait...");
    }

    return StreamProvider<QuerySnapshot>.value(
      initialData: null,
      value: DatabaseService(query: invoiceId,).store,
      builder: (context, productsWidget){
        products = Provider.of<QuerySnapshot>(context);

        return Scaffold(
          appBar: AppBar(
              title: Text(
                "Invoice for $customerNames",
              )
          ),
          body: (products == null)?LoadingWidget("Please wait..."):
          PdfPreview(
            build: (format) => _generatePdf(format),
          ),
        );
      },
    );
  }
}