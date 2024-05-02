import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  int active = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
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
          children: [
            const SizedBox(
              height: 6,
            ),
            Text(
              'Jika anda memiliki pertanyaan, kamu bisa memilih pertanyaan di bawah ini',
              style: plusJakartaSans.copyWith(
                  fontSize: 12, color: const Color(0xFF676A73)),
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
                  title: 'Ganti Password',
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
                  title: 'Edit Profil',
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
                  title: 'Tambah Hewan',
                  body:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis'),
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (active == 4) {
                    active = 0;
                  } else {
                    active = 4;
                  }
                });
              },
              child: ListItem(
                  active: active,
                  index: 4,
                  title: 'Jadwal janji temu',
                  body:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis'),
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (active == 5) {
                    active = 0;
                  } else {
                    active = 5;
                  }
                });
              },
              child: ListItem(
                  active: active,
                  index: 5,
                  title: 'Tentang Klinik',
                  body:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis'),
            )
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
