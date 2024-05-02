import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';
import 'package:galaxy_satwa/pages/akun/comp/detail_konsultasi_page.dart';
import 'package:galaxy_satwa/services/auth_service.dart';

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({super.key});

  @override
  State<KonsultasiPage> createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage> {
  List<dynamic> dokterList = [];
  void _getDoctor() async {
    ApiResponse response = await getAllDokter();
    if (response.error == null) {
      dokterList = response.data as List<dynamic>;
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
    _getDoctor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konsultasi'),
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Column(
            children: List.generate(dokterList.length, (index) {
              UserModel dokter = dokterList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KonsultasiDetailPage(
                                dokter: dokter,
                              )));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 14),
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
                        width: 55,
                        height: 56,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              '${dokter.image}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dokter.name!,
                            style: plusJakartaSans.copyWith(
                                fontWeight: bold, color: neutral00),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Position',
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: const Color(0xFF4F4F4F)),
                          )
                        ],
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/ic_arrow_right.png',
                        width: 24,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/img_grafis_chat.png',
              width: 145,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Pilih dokter untuk informasi\nkonsultasi',
              style: plusJakartaSans.copyWith(fontSize: 12, color: neutral02),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
