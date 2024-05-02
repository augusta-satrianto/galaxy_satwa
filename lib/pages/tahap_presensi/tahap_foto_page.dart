import 'dart:io';

import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/config/methods.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/pages/base/base.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class TahapFotoPage extends StatefulWidget {
  const TahapFotoPage({super.key});

  @override
  State<TahapFotoPage> createState() => _TahapFotoPageState();
}

class _TahapFotoPageState extends State<TahapFotoPage> {
  XFile? selectedImage;
  void getSelfie() async {
    final image = await openCamera();

    setState(() {
      selectedImage = image;
    });
  }

  @override
  void initState() {
    getSelfie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                selectedImage != null
                    ? Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: FileImage(
                                File(selectedImage!.path),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 190,
                )
              ],
            ),
            Positioned(
              top: 30,
              left: 24,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 33,
                  height: 33,
                  decoration:
                      BoxDecoration(color: neutral100, shape: BoxShape.circle),
                  child: const Center(
                      child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 16,
                  )),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Column(
                children: [
                  Container(
                    height: 230,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                    decoration: BoxDecoration(
                        color: neutral100,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 4,
                            width: 85,
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                                color: neutral200,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        Text('Absen Masuk',
                            style: plusJakartaSans.copyWith(
                                fontWeight: semiBold,
                                fontSize: 28,
                                color: neutral00)),
                        const SizedBox(
                          height: 3.5,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/ic_kalender_rounded.png',
                              width: 16,
                              color: neutral00,
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Text('08 Okt 2023 (07.00 - 12.00)',
                                style: plusJakartaSans.copyWith(
                                    fontWeight: bold,
                                    fontSize: 12,
                                    color: neutral00)),
                          ],
                        ),
                        const SizedBox(
                          height: 26.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          child: CustomFilledButton(
                              title: 'Kirim',
                              onPressed: () async {
                                String role = await getRole();
                                String name = await getName();
                                String image = await getImage();
                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BasePage(
                                            role: role,
                                            name: name,
                                            image: image)),
                                    (route) => false);
                              }),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text('Langkah 2 dari 2',
                              style: plusJakartaSans.copyWith(
                                  fontSize: 11, color: neutral00)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
