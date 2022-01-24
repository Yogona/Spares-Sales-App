import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintInvoice extends StatelessWidget {
  PrintInvoice({this.title, Key key}) : super(key: key);

  final String title;
  final pdf = pw.Document();

  Future<Uint8List> _generatePdf(PdfPageFormat format){
    pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (pw.Context context){
            return pw.Text("hello");
          },
        )
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }
}