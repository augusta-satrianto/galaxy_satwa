import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/correspondence_model.dart';
import 'package:galaxy_satwa/pages/persuratan/balas_surat_page.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailSuratPage extends StatefulWidget {
  final CorrespondenceModel correspondence;
  final String pdfPath;
  final String? pdfPathBalasan;
  final String role;
  const DetailSuratPage(
      {super.key,
      required this.correspondence,
      required this.pdfPath,
      this.pdfPathBalasan = '',
      required this.role});

  @override
  State<DetailSuratPage> createState() => _DetailSuratPageState();
}

class _DetailSuratPageState extends State<DetailSuratPage> {
  _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle the case where the user denied permission
      print('Storage permission is required to download and view the PDF.');
    }
  }

  File? pdfFile;
  Future<void> _downloadPDF(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        String name =
            url.toString().replaceAll('/', '_').replaceAll('%20', '_');
        List<String> parts = name.split('_');
        String lastPart = parts.last;

        final path = '${directory.path}/$lastPart';
        // Check if the file already exists
        if (!File(path).existsSync()) {
          // Save the PDF file to local storage
          File(path).writeAsBytesSync(response.bodyBytes);
        }
        setState(() {
          pdfFile = File(path);
        });
        print('PDF downloaded and saved to: $path');
        OpenFile.open(pdfFile!.path);
      } else {
        print('Failed to access external storage.');
      }
    } else {
      print('Failed to download PDF. Status Code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    _requestStoragePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Surat'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/img_surat_masuk.png',
                  width: 45,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surat ${widget.correspondence.category!}',
                      style: plusJakartaSans.copyWith(
                          fontWeight: medium, fontSize: 12, color: neutral00),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                            DateFormat('dd/MM/yyyy')
                                .format(widget.correspondence.createdAt!),
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: const Color(0xFF83858A))),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                            widget.correspondence.createdAt!
                                .toString()
                                .substring(10, 16),
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: const Color(0xFF83858A)))
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unggah dokumen yang sudah bertandatangan untuk persetujuan tindakan medis dengan mengunduh dokumen yang terlampir',
                    style: plusJakartaSans.copyWith(
                        fontSize: 12,
                        fontWeight: medium,
                        color: const Color(0xFF6C6D72)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _downloadPDF(widget.correspondence.file);
                    },
                    child: Container(
                      height: 150,
                      width: 227,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEDF1F7),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 100,
                                  width: 200,
                                  child: PDFView(
                                    filePath: widget.pdfPath,
                                    autoSpacing: false,
                                    enableSwipe: false,
                                    pageFling: false,
                                    pageSnap: false,
                                    onViewCreated: (PDFViewController vc) {},
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 200,
                                  color: Colors.amber.withOpacity(0),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/ic_pdf.png',
                                  width: 14,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${widget.correspondence.category!}.pdf',
                                  style: inter.copyWith(
                                      fontSize: 10,
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.7)),
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/ic_download.png',
                                  width: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.pdfPathBalasan != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFD2D4DA),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/img_surat_balasan.png',
                            width: 45,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Balasan Surat ${widget.correspondence.category!}',
                                style: plusJakartaSans.copyWith(
                                    fontWeight: medium,
                                    fontSize: 12,
                                    color: neutral00),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                      DateFormat('dd/MM/yyyy').format(
                                          widget.correspondence.updatedAt!),
                                      style: plusJakartaSans.copyWith(
                                          fontSize: 10,
                                          color: const Color(0xFF83858A))),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                      widget.correspondence.updatedAt!
                                          .toString()
                                          .substring(10, 16),
                                      style: plusJakartaSans.copyWith(
                                          fontSize: 10,
                                          color: const Color(0xFF83858A)))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            _downloadPDF(widget.correspondence.replyFile);
                          },
                          child: Container(
                            height: 150,
                            width: 227,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                                color: const Color(0xFFEDF1F7),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 200,
                                        child: PDFView(
                                          filePath: widget.pdfPathBalasan,
                                          autoSpacing: false,
                                          enableSwipe: false,
                                          pageFling: false,
                                          pageSnap: false,
                                          onViewCreated:
                                              (PDFViewController vc) {},
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        width: 200,
                                        color: Colors.amber.withOpacity(0),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ic_pdf.png',
                                        width: 14,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Surat balasan.pdf',
                                        style: inter.copyWith(
                                            fontSize: 10,
                                            color: const Color(0xFF000000)
                                                .withOpacity(0.7)),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        'assets/ic_download.png',
                                        width: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.correspondence.replyFile == null && widget.role == 'pasien'
                ? const Spacer()
                : const SizedBox(
                    height: 30,
                  ),
            widget.correspondence.replyFile == null && widget.role == 'pasien'
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: CustomFilledButton(
                        title: 'Unggah Surat Balasan',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BalasSuratPage(
                                        id: widget.correspondence.id.toString(),
                                      )));
                        }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
