import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';

class RincianGajiPage extends StatefulWidget {
  const RincianGajiPage({super.key});

  @override
  State<RincianGajiPage> createState() => _RincianGajiPageState();
}

class _RincianGajiPageState extends State<RincianGajiPage> {
  int active = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Gaji'),
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Rincian Gaji',
                    style: plusJakartaSans.copyWith(
                        fontWeight: semiBold, color: const Color(0xFF45484F)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gaji Dokter',
                          style: plusJakartaSans.copyWith(
                              fontSize: 12,
                              fontWeight: semiBold,
                              color: const Color(0xFF45484F))),
                      Text('Rp. 15.000,000 /bln',
                          style: plusJakartaSans.copyWith(
                              fontSize: 12, color: const Color(0xFF45484F)))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gaji Paramedis',
                          style: plusJakartaSans.copyWith(
                              fontSize: 12,
                              fontWeight: semiBold,
                              color: const Color(0xFF45484F))),
                      Text('Rp. 10.000,000 /bln',
                          style: plusJakartaSans.copyWith(
                              fontSize: 12, color: const Color(0xFF45484F)))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gaji Admin',
                          style: plusJakartaSans.copyWith(
                              fontSize: 12,
                              fontWeight: semiBold,
                              color: const Color(0xFF45484F))),
                      Text('Rp. 5.000,000 /bln',
                          style: plusJakartaSans.copyWith(
                              fontSize: 12, color: const Color(0xFF45484F)))
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Keterangan :',
              style: plusJakartaSans.copyWith(
                  fontWeight: semiBold, color: const Color(0xFF45484F)),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (active == 1) {
                    active = 0;
                  } else {
                    active = 1;
                  }
                });
              },
              child: ListItem(
                  active: active,
                  index: 1,
                  title: 'Izin Cuti',
                  body:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis'),
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (active == 2) {
                    active = 0;
                  } else {
                    active = 2;
                  }
                });
              },
              child: ListItem(
                  active: active,
                  index: 2,
                  title: 'Absen tanpa keterangan',
                  body:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis'),
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (active == 3) {
                    active = 0;
                  } else {
                    active = 3;
                  }
                });
              },
              child: ListItem(
                  active: active,
                  index: 3,
                  title: 'Absen sakit',
                  body:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis'),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final int active;
  final int index;
  final String title;
  final String body;
  const ListItem(
      {super.key,
      required this.active,
      required this.index,
      required this.title,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.10),
            offset: const Offset(0, 5.86),
            blurRadius: 19.55,
            spreadRadius: -1.95,
          ),
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.04),
            offset: const Offset(0, -0.98),
            blurRadius: 29.32,
            spreadRadius: -5.95,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 19.55, vertical: 13.68),
            decoration: BoxDecoration(
                color: primaryBlue1,
                borderRadius: active == index
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))
                    : BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: plusJakartaSans.copyWith(
                      fontWeight: semiBold, fontSize: 12, color: neutral07),
                ),
                Image.asset(
                  active != index
                      ? 'assets/ic_arrow_down.png'
                      : 'assets/ic_arrow_up.png',
                  width: 16,
                  color: neutral07,
                )
              ],
            ),
          ),
          active == index
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 19, vertical: 13),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Text(
                    body,
                    style: plusJakartaSans.copyWith(
                        fontSize: 12, color: const Color(0xFF4D515B)),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
