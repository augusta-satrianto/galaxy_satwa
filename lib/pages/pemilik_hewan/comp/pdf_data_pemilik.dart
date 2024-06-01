import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:galaxy_satwa/models/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:galaxy_satwa/components/file_handle_api.dart';

class PdfDataPemilik {
  static Future<Uint8List> _fetchNetworkImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load image');
    }
    return response.bodyBytes;
  }

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
      'Gambar',
      'Nama',
      'Email',
      'Tanggal Lahir',
      'Jenis Kelamin',
      'Alamat',
      'Telepon'
    ];
    List<Uint8List> gambar = [];
    // Fetch the network image asynchronously
    for (int i = 0; i < items.length; i++) {
      UserModel user = items[i];
      final Uint8List netImageBytes = await _fetchNetworkImage(user.image!);
      gambar.add(netImageBytes);
    }
    int iterasi = -1;

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Data Hewan',
                  style: pw.TextStyle(font: ttf, fontSize: 16),
                ),
              ],
            ),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
            pw.Table(
              border: pw.TableBorder.all(
                width: 1,
                color: const PdfColor.fromInt(0xFFDDDDDD),
              ),
              children: [
                // Table headers
                pw.TableRow(
                  children: tableHeaders.map((header) {
                    return pw.Container(
                      width: header == 'Gambar' ? 60 : 100,
                      alignment: pw.Alignment.topLeft,
                      margin: const pw.EdgeInsets.all(0),
                      padding: const pw.EdgeInsets.all(5),
                      decoration: const pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFf2f2f2),
                      ),
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
                // Table data
                ...items.map((item) {
                  iterasi++;
                  return pw.TableRow(
                    children: [
                      // Custom cell for image
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        margin: const pw.EdgeInsets.all(5),
                        child: pw.ClipOval(
                          child: pw.Image(pw.MemoryImage(gambar[iterasi]),
                              width: 30, height: 30),
                        ),
                      ),
                      // Text cells
                      ...[
                        item.name,
                        item.email,
                        item.formattedDateOfBirth,
                        item.gender,
                        item.address,
                        item.phone
                      ].map((text) {
                        return pw.Container(
                          alignment: pw.Alignment.topLeft,
                          margin: const pw.EdgeInsets.all(0),
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            text.toString(),
                            style: pw.TextStyle(font: ttf, fontSize: 10),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ],
            ),
          ];
        },
      ),
    );

    Random random = Random();
    int randomNumber = 100000 + random.nextInt(900000);

    return FileHandleApi.saveDocument(
      name: 'Data Pemilik_$randomNumber.pdf',
      pdf: pdf,
    );
  }
}
