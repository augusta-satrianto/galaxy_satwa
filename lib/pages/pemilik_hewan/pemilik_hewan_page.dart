import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/file_handle_api.dart';
import 'package:galaxy_satwa/components/search.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';
import 'package:galaxy_satwa/pages/pemilik_hewan/comp/detail_pemilik_hewan_page.dart';
import 'package:galaxy_satwa/pages/pemilik_hewan/comp/pdf_data_pemilik.dart';
import 'package:galaxy_satwa/services/auth_service.dart';

class DataPemilikHewanPage extends StatefulWidget {
  const DataPemilikHewanPage({super.key});

  @override
  State<DataPemilikHewanPage> createState() => _DataPemilikHewanPageState();
}

class _DataPemilikHewanPageState extends State<DataPemilikHewanPage> {
  final seacrhController = TextEditingController();

  List<dynamic> pemilikList = [];
  void _getPatient() async {
    ApiResponse response = await getUserAll();
    if (response.error == null) {
      pemilikList = response.data as List<dynamic>;
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
      }
    }
  }

  @override
  void initState() {
    _getPatient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    seacrhController.addListener(() {
      setState(() {});
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pemilik Hewan'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 100));
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    final pdfFile = await PdfDataPemilik.generate(pemilikList);
                    FileHandleApi.openFile(pdfFile);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: primaryGreen1,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Unduh Data Pemilik',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold, color: neutral100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomSearch(
                placeholder: 'Cari pemilik hewan',
                seacrhController: seacrhController),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
                itemCount: pemilikList.length,
                itemBuilder: (context, index) {
                  UserModel user = pemilikList[index];
                  if (user.role == 'pasien' &&
                      (seacrhController.text.isEmpty ||
                          (seacrhController.text.isNotEmpty &&
                              user.name!.toLowerCase().contains(
                                  seacrhController.text.toLowerCase())))) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailPemilikHewanPage(user: user)));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.25),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 57,
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    '${user.image}',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name!,
                                    style: inter.copyWith(
                                        fontWeight: semiBold, color: neutral00),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'No. tlpn : ${user.phone}',
                                    style: inter.copyWith(
                                        fontSize: 12,
                                        fontWeight: semiBold,
                                        color: const Color(0xFF94959A)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Email : ${user.email}',
                                    style: inter.copyWith(
                                        fontSize: 12,
                                        fontWeight: semiBold,
                                        color: const Color(0xFF94959A)),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              'assets/ic_arrow_right.png',
                              width: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
