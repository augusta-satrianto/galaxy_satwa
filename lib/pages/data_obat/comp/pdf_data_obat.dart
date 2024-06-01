import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:galaxy_satwa/components/file_handle_api.dart';
import 'package:galaxy_satwa/models/medicine_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfDataObat {
  static Future<File> generate(List<dynamic> items) async {
    final pdf = pw.Document();

    Future<Uint8List> loadFontData() async {
      final ByteData data =
          await rootBundle.load('assets/fonts/Times New Roman.ttf');
      return data.buffer.asUint8List();
    }

// Usage
    final Uint8List fontData = await loadFontData();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final tableHeaders = [
      'Kode Obat',
      'Nama Obat',
      'Tanggal Kadaluarsa',
      'Stok Obat',
    ];

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Data Obat',
                  style: pw.TextStyle(font: ttf, fontSize: 16),
                ),
              ],
            ),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: items.map((item) {
                return [
                  item.code,
                  item.name,
                  item.formattedExpiryDate,
                  item.stock.toString(),
                ];
              }).toList(),
              border: pw.TableBorder.all(
                width: 1,
                color: const PdfColor.fromInt(0xFFDDDDDD),
              ),
              headerStyle: pw.TextStyle(
                font: ttf,
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFf2f2f2),
              ),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
              },
              cellStyle: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
            ),
          ];
        },
      ),
    );
    Random random = Random();
    int randomNumber = 100000 + random.nextInt(900000);

    return FileHandleApi.saveDocument(
        name: 'Data Obat_$randomNumber.pdf', pdf: pdf);
  }
}
