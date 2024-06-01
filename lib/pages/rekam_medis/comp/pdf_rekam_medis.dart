import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_satwa/components/file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfRekamMedis {
  static Future<File> generate(String name, String type, String gender,
      String color, String old, String tatto, List<dynamic> items) async {
    final pdf = pw.Document();

    Future<Uint8List> loadFontData() async {
      final ByteData data =
          await rootBundle.load('assets/fonts/Times New Roman.ttf');
      return data.buffer.asUint8List();
    }

    final iconImage =
        (await rootBundle.load('assets/logo-klinik.png')).buffer.asUint8List();

// Usage
    final Uint8List fontData = await loadFontData();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final tableHeaders = [
      'Tanggal',
      'Gejala Klinis',
      'Diagnosa',
      'Tindakan',
      'Resep'
    ];

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Row(
              children: [
                pw.Image(
                  pw.MemoryImage(iconImage),
                  height: 60,
                  width: 60,
                ),
                pw.SizedBox(width: 20),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'KLINIK HEWAN GALAXY SATWA',
                      style: pw.TextStyle(
                        fontSize: 15.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                        'Perumahan Menganti Permai Blok A6 / No.09\nTlogo Bedah, Hulaan Kec. Menganti Kab. Gresik, Jawa Timur',
                        textAlign: pw.TextAlign.center),
                    pw.RichText(
                      text: const pw.TextSpan(
                        text: 'Telp : (085) 730 3 69 063 email : ',
                        style: pw.TextStyle(fontSize: 12),
                        children: [
                          pw.TextSpan(
                            text: 'klinikhewan.galaxysatwa@gmail.com',
                            style: pw.TextStyle(
                              color: PdfColors.blue,
                              decoration: pw.TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(children: [
              pw.Container(
                padding: const pw.EdgeInsets.fromLTRB(15, 15, 80, 15),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColor.fromInt(0xFFDDDDDD))),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                            width: 80,
                            child: pw.Text('Nama Hewan',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(' : ', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text(name, style: const pw.TextStyle(fontSize: 10))
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                            width: 80,
                            child: pw.Text('Jenis Hewan',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(' : ', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text(type, style: const pw.TextStyle(fontSize: 10))
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                            width: 80,
                            child: pw.Text('Jenis Kelamin',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(' : ', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text(gender, style: const pw.TextStyle(fontSize: 10))
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                            width: 80,
                            child: pw.Text('Warna',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(' : ', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text(color, style: const pw.TextStyle(fontSize: 10))
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                            width: 80,
                            child: pw.Text('Umur',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(' : ', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text(old, style: const pw.TextStyle(fontSize: 10))
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                            width: 80,
                            child: pw.Text('Tatto',
                                style: const pw.TextStyle(fontSize: 10))),
                        pw.Text(' : ', style: const pw.TextStyle(fontSize: 10)),
                        pw.Text(tatto, style: const pw.TextStyle(fontSize: 10))
                      ],
                    )
                  ],
                ),
              ),
            ]),

            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: items.map((item) {
                return [
                  item.formattedDate,
                  item.symptom,
                  item.diagnosis,
                  item.action,
                  item.recipe,
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
        name: 'Rekam Medis_$randomNumber.pdf', pdf: pdf);
  }
}
