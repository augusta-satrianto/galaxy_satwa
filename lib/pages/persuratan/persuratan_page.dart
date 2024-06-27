import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/material_design_indicator.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/correspondence_model.dart';
import 'package:galaxy_satwa/pages/persuratan/detail_surat_page.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:galaxy_satwa/services/correspondence_service.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class PersuratanPage extends StatefulWidget {
  const PersuratanPage({super.key});

  @override
  State<PersuratanPage> createState() => _PersuratanPageState();
}

class _PersuratanPageState extends State<PersuratanPage> {
  List<dynamic> correspondenceList = [];
  bool hasDataSurat = false;
  bool hasDataRiwayat = false;
  bool isLoading = true;
  String? role;
  void _getCorrespondence() async {
    role = await getRole();
    ApiResponse response;
    if (role == 'pasien') {
      response = await getCorrespondenceByUserLogin();
    } else {
      response = await getCorrespondenceAll();
    }

    if (response.error == null) {
      correspondenceList = response.data as List<dynamic>;
      for (int i = 0; i < correspondenceList.length; i++) {
        CorrespondenceModel correspondance = correspondenceList[i];
        if (correspondance.replyFile == null) {
          hasDataSurat = true;
        } else {
          hasDataRiwayat = true;
        }
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getCorrespondence();
    super.initState();
  }

  Future<File> createFileOfPzdfUrl({required String url}) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  bool showNoDataSurat = false;
  bool showNoDataRiwayat = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persuratan'),
        titleSpacing: 24,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: neutral07,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    TabBar(
                      labelPadding: EdgeInsets.zero,
                      indicator: MaterialDesignIndicator(
                          indicatorHeight: 4, indicatorColor: primaryBlue1),
                      labelColor: neutral00,
                      labelStyle: plusJakartaSans.copyWith(
                          fontWeight: bold, fontSize: 12),
                      unselectedLabelColor: neutral00,
                      unselectedLabelStyle: plusJakartaSans.copyWith(
                          fontSize: 12, fontWeight: medium),
                      tabs: const [
                        Tab(
                          text: 'Surat',
                        ),
                        Tab(
                          text: 'Riwayat Surat',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    //Surat
                    if (!isLoading)
                      !hasDataSurat
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/img_grafis_email.png',
                                  width: 170,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Belum ada surat persetujuan\ntindakan medis untukmu',
                                  textAlign: TextAlign.center,
                                  style: plusJakartaSans.copyWith(
                                      fontSize: 12, color: neutral02),
                                )
                              ],
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                    children: List.generate(
                                        correspondenceList.length, (index) {
                                  CorrespondenceModel correspondence =
                                      correspondenceList[index];
                                  if (correspondence.replyFile == null) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            var file =
                                                await createFileOfPzdfUrl(
                                                    url: correspondence.file!);
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailSuratPage(
                                                          correspondence:
                                                              correspondence,
                                                          pdfPath: file.path,
                                                          role: role!,
                                                        ))).then(
                                                (receivedData) {
                                              if (receivedData == 'retrive') {
                                                _getCorrespondence();
                                              }
                                            });
                                          },
                                          child: Container(
                                            color: neutral07,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  'assets/img_surat_masuk.png',
                                                  width: 45,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Surat ${correspondence.category!}',
                                                        style: plusJakartaSans
                                                            .copyWith(
                                                                fontWeight:
                                                                    medium,
                                                                fontSize: 12,
                                                                color:
                                                                    neutral00),
                                                      ),
                                                      const SizedBox(
                                                        height: 11,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(correspondence
                                                                      .createdAt!),
                                                              style: plusJakartaSans
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      color: const Color(
                                                                          0xFF83858A))),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Text(
                                                              correspondence
                                                                  .createdAt!
                                                                  .toString()
                                                                  .substring(
                                                                      10, 16),
                                                              style: plusJakartaSans
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      color: const Color(
                                                                          0xFF83858A)))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        11,
                                                                    vertical:
                                                                        4),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: const Color(
                                                                        0xFF000000)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child: Row(
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/ic_pdf.png',
                                                                    width: 14,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    '${correspondence.category}.pdf',
                                                                    style: inter.copyWith(
                                                                        fontSize:
                                                                            10,
                                                                        color: const Color(0xFF000000)
                                                                            .withOpacity(0.7)),
                                                                  )
                                                                ]),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Image.asset(
                                                  'assets/ic_menunggu.png',
                                                  width: 18,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              top: 12, bottom: 20),
                                          color: const Color(0xFFD2D4DA),
                                        )
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }))
                              ],
                            ),

                    //Riwayat Surat
                    if (!isLoading)
                      !hasDataRiwayat
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/img_grafis_email.png',
                                  width: 170,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Belum ada surat persetujuan\ntindakan medis untukmu',
                                  textAlign: TextAlign.center,
                                  style: plusJakartaSans.copyWith(
                                      fontSize: 12, color: neutral02),
                                )
                              ],
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                    children: List.generate(
                                        correspondenceList.length, (index) {
                                  CorrespondenceModel correspondence =
                                      correspondenceList[index];
                                  if (correspondence.replyFile != null) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            var file =
                                                await createFileOfPzdfUrl(
                                                    url: correspondence.file!);
                                            var fileBalasan =
                                                await createFileOfPzdfUrl(
                                                    url: correspondence
                                                        .replyFile!);
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailSuratPage(
                                                          correspondence:
                                                              correspondence,
                                                          pdfPath: file.path,
                                                          pdfPathBalasan:
                                                              fileBalasan.path,
                                                          role: role!,
                                                        )));
                                          },
                                          child: Container(
                                            color: neutral07,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  'assets/img_surat_masuk.png',
                                                  width: 45,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Surat ${correspondence.category!}',
                                                        style: plusJakartaSans
                                                            .copyWith(
                                                                fontWeight:
                                                                    medium,
                                                                fontSize: 12,
                                                                color:
                                                                    neutral00),
                                                      ),
                                                      const SizedBox(
                                                        height: 11,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(correspondence
                                                                      .createdAt!),
                                                              style: plusJakartaSans
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      color: const Color(
                                                                          0xFF83858A))),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Text(
                                                              correspondence
                                                                  .createdAt!
                                                                  .toString()
                                                                  .substring(
                                                                      10, 16),
                                                              style: plusJakartaSans
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      color: const Color(
                                                                          0xFF83858A)))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        11,
                                                                    vertical:
                                                                        4),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: const Color(
                                                                        0xFF000000)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child: Row(
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/ic_pdf.png',
                                                                    width: 14,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    '${correspondence.category}.pdf',
                                                                    style: inter.copyWith(
                                                                        fontSize:
                                                                            10,
                                                                        color: const Color(0xFF000000)
                                                                            .withOpacity(0.7)),
                                                                  )
                                                                ]),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Selesai',
                                                  style:
                                                      plusJakartaSans.copyWith(
                                                          fontSize: 12,
                                                          color: const Color(
                                                              0xFF22C55E)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              top: 12, bottom: 20),
                                          color: const Color(0xFFD2D4DA),
                                        )
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }))
                              ],
                            )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
