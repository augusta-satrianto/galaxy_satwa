import 'package:flutter/material.dart';
import 'package:galaxy_satwa/pages/akun/akun_page.dart';
import 'package:galaxy_satwa/pages/beranda/beranda_page.dart';
import 'package:galaxy_satwa/pages/janji_temu/janji_temu_page.dart';
import 'package:galaxy_satwa/pages/persuratan/persuratan_page.dart';
import 'package:galaxy_satwa/pages/rekam_medis/rekam_medis_page.dart';

import '../../config/theme.dart';

class BasePage extends StatefulWidget {
  final int selectedIndex;
  final String role;
  final String name;
  final String image;
  const BasePage({
    super.key,
    this.selectedIndex = 0,
    required this.role,
    required this.name,
    required this.image,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int currentIndex = 0;
  List tabs = [];
  List<BottomNavigationBarItem> items = [];

  void getPrev() async {
    if (widget.role == 'pasien') {
      tabs = [
        BerandaPage(
          role: 'pasien',
          name: widget.name,
          urlImage: widget.image,
        ),
        const JanjiTemuPage(),
        const PersuratanPage(),
        AkunPage(
          role: 'pasien',
          name: widget.name,
          urlImage: widget.image,
        )
      ];
      items = [
        _mBottomNavItem(
          label: 'Beranda',
          icon: 'assets/ic_home.png',
        ),
        _mBottomNavItem(
          label: 'Janji Temu',
          icon: 'assets/ic_janji.png',
        ),
        _mBottomNavItem(
          label: 'Persuratan',
          icon: 'assets/ic_surat.png',
        ),
        _mBottomNavItem(
          label: 'Profil',
          icon: 'assets/ic_akun.png',
        ),
      ];
    } else if (widget.role == 'dokter') {
      tabs = [
        BerandaPage(
          role: 'dokter',
          name: widget.name,
          urlImage: widget.image,
        ),
        const PersuratanPage(),
        const JanjiTemuPage(),
        const RekamMedisPage(),
        AkunPage(
          role: 'dokter',
          name: widget.name,
          urlImage: widget.image,
        )
      ];
      items = [
        _mBottomNavItem(
          label: 'Beranda',
          icon: 'assets/ic_home.png',
        ),
        _mBottomNavItem(
          label: 'Persuratan',
          icon: 'assets/ic_surat.png',
        ),
        _mBottomNavItem(
          label: 'Jadwal',
          icon: 'assets/ic_janji.png',
        ),
        _mBottomNavItem(
          label: 'Rekam Medis',
          icon: 'assets/ic_rekam_medis.png',
        ),
        _mBottomNavItem(
          label: 'Profil',
          icon: 'assets/ic_akun.png',
        ),
      ];
    } else if (widget.role == 'paramedis') {
      tabs = [
        BerandaPage(
          role: 'paramedis',
          name: widget.name,
          urlImage: widget.image,
        ),
        const PersuratanPage(),
        const JanjiTemuPage(),
        const RekamMedisPage(),
        AkunPage(
          role: 'paramedis',
          name: widget.name,
          urlImage: widget.image,
        )
      ];
      items = [
        _mBottomNavItem(
          label: 'Beranda',
          icon: 'assets/ic_home.png',
        ),
        _mBottomNavItem(
          label: 'Persuratan',
          icon: 'assets/ic_surat.png',
        ),
        _mBottomNavItem(
          label: 'Jadwal',
          icon: 'assets/ic_janji.png',
        ),
        _mBottomNavItem(
          label: 'Rekam Medis',
          icon: 'assets/ic_rekam_medis.png',
        ),
        _mBottomNavItem(
          label: 'Profil',
          icon: 'assets/ic_akun.png',
        ),
      ];
    }

    setState(() {});
  }

  changeScreen(int selectedIndex) {
    setState(() {
      currentIndex = selectedIndex;
    });
  }

  @override
  void initState() {
    currentIndex = widget.selectedIndex;
    getPrev();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: primaryBlue1,
        unselectedItemColor: neutral02,
        selectedLabelStyle: inter.copyWith(fontWeight: medium, fontSize: 10),
        unselectedLabelStyle: inter.copyWith(fontWeight: medium, fontSize: 10),
        items: items,
        onTap: changeScreen,
      ),
    );
  }
}

_mBottomNavItem({required String label, required String icon}) {
  return BottomNavigationBarItem(
    label: label,
    icon: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Image.asset(
        icon,
        color: neutral02,
        width: 24,
      ),
    ),
    activeIcon: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Image.asset(
        icon,
        color: primaryBlue1,
        width: 24,
      ),
    ),
  );
}

class CustomListMenu extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  const CustomListMenu(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        color: Colors.white,
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 26,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: plusJakartaSans.copyWith(color: neutral00, fontSize: 16),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/ic_arrow_right.png',
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
