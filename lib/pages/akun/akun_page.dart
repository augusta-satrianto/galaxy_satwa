import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';
import 'package:galaxy_satwa/pages/akun/comp/faq_page.dart';
import 'package:galaxy_satwa/pages/akun/comp/info_personal_page.dart';
import 'package:galaxy_satwa/pages/akun/comp/konsultasi_page.dart';
import 'package:galaxy_satwa/pages/akun/comp/ubah_kata_sandi_page.dart';
import 'package:galaxy_satwa/pages/auth/login_page.dart';
import 'package:galaxy_satwa/pages/data_hewan/data_hewan_page.dart';
import 'package:galaxy_satwa/pages/data_master/data_master_page.dart';
import 'package:galaxy_satwa/pages/data_obat/data_obat_page.dart';
import 'package:galaxy_satwa/pages/hewanku/hewanku_page.dart';
import 'package:galaxy_satwa/pages/pemilik_hewan/pemilik_hewan_page.dart';
import 'package:galaxy_satwa/pages/presensi/presensi_page.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunPage extends StatefulWidget {
  final String role;
  final String name;
  final String urlImage;
  const AkunPage(
      {super.key,
      required this.role,
      required this.name,
      required this.urlImage});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  UserModel? userModel;
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      userModel = response.data as UserModel;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
        titleSpacing: 24,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 6,
            ),
            ClipOval(
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    widget.urlImage,
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.name,
              style: plusJakartaSans.copyWith(
                  fontWeight: semiBold, fontSize: 20, color: neutral00),
            ),
            const SizedBox(
              height: 28,
            ),
            ListItem(
                iconUrl: 'assets/ic_personal.png',
                title: 'Info Personal',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfoPersonalPage(
                              user: userModel!,
                            )))),
            widget.role == 'pasien'
                ? _listMenuPasien(context)
                : _listMenuDokterParamedis(context),
            ListItem(
                iconUrl: 'assets/ic_keluar.png',
                title: 'Keluar',
                onTap: () {
                  showMyDialog(context);
                }),
          ],
        ),
      ),
    );
  }
}

_listMenuPasien(BuildContext context) {
  return Column(
    children: [
      ListItem(
          iconUrl: 'assets/ic_hewanku.png',
          title: 'Hewanku',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HewankuPage()))),
      ListItem(
          iconUrl: 'assets/ic_konsultasi.png',
          title: 'Konsultasi',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const KonsultasiPage()))),
      ListItem(
          iconUrl: 'assets/ic_ganti_password.png',
          title: 'Ganti Password',
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UbahKataSandiPage()))),
      ListItem(
          iconUrl: 'assets/ic_faq.png',
          title: 'FAQ',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FaqPage()))),
    ],
  );
}

_listMenuDokterParamedis(BuildContext context) {
  return Column(
    children: [
      ListItem(
          iconUrl: 'assets/ic_presensi.png',
          title: 'Prensesi',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PresensiPage()))),
      ListItem(
          iconUrl: 'assets/ic_hewanku.png',
          title: 'Data Hewan',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DataHewanPage()))),
      ListItem(
          iconUrl: 'assets/ic_pemilik_hewan.png',
          title: 'Data Pemilik Hewan',
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DataPemilikHewanPage()))),
      ListItem(
          iconUrl: 'assets/ic_obat.png',
          title: 'Data Obat',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DataObatPage()))),
      ListItem(
          iconUrl: 'assets/ic_konsultasi.png',
          title: 'Master Data',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DataMasterPage()))),
    ],
  );
}

void showMyDialog(BuildContext context) {
  removePred() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
    // ignore: deprecated_member_use
    preferences.commit();
  }

  showDialog(
      barrierDismissible: false,
      // barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: neutral07,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: neutral07,
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/ic_close.png',
                        width: 25,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 42,
                      ),
                      Image.asset(
                        'assets/img_grafis_ask.png',
                        width: 200,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Apakah kamu yakin ingin keluar?',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold,
                            fontSize: 16,
                            color: neutral00),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    BorderSide(color: danger)),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(100, 40)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Tidak',
                                style: plusJakartaSans.copyWith(
                                    fontWeight: semiBold,
                                    fontSize: 16,
                                    color: danger),
                              )),
                          const SizedBox(
                            width: 40,
                          ),
                          OutlinedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                  color: primaryBlue1,
                                )),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(100, 40)),
                              ),
                              onPressed: () {
                                removePred();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                              },
                              child: Text(
                                'Ya',
                                style: plusJakartaSans.copyWith(
                                    fontWeight: semiBold,
                                    fontSize: 16,
                                    color: primaryBlue1),
                              )),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}

class ListItem extends StatelessWidget {
  final String iconUrl;
  final String title;
  final VoidCallback onTap;
  const ListItem(
      {super.key,
      required this.iconUrl,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: neutral07,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Image.asset(
                  iconUrl,
                  width: 24,
                ),
                const SizedBox(
                  width: 22,
                ),
                Text(
                  title,
                  style: plusJakartaSans.copyWith(
                      fontWeight: semiBold,
                      fontSize: 12,
                      color: title == 'Keluar' ? danger : neutral00),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
