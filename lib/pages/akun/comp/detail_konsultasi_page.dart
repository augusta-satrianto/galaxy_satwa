import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class KonsultasiDetailPage extends StatefulWidget {
  final UserModel dokter;
  const KonsultasiDetailPage({super.key, required this.dokter});

  @override
  State<KonsultasiDetailPage> createState() => _KonsultasiDetailPageState();
}

class _KonsultasiDetailPageState extends State<KonsultasiDetailPage> {
  void _launchWhatsApp() async {
    String phoneNumber = widget.dokter.phone!;
    String message = 'Halo Dokter, saya ingin melakukan konsultasi.';
    String uri =
        'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeFull(message)}';

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print('Could not launch $uri');
    }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                        '${widget.dokter.image}',
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
                      widget.dokter.name!,
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
              ],
            ),
            const SizedBox(
              height: 27,
            ),
            CustomFilledButton(
                title: 'Chat Dokter',
                onPressed: () {
                  _launchWhatsApp();
                }),
            const SizedBox(
              height: 27,
            ),
            Text(
              'Klik tombol “Chat Dokter untuk memulai konsultasi',
              style: plusJakartaSans.copyWith(
                  fontWeight: semiBold, fontSize: 12, color: neutral01),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Waktu Konsultasi : 07.00 - 20.00',
              style: plusJakartaSans.copyWith(
                  fontWeight: semiBold, fontSize: 12, color: primaryBlue1),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '* Konsultasi hanya diperbolehkan pada jam yang telah ditentukan.',
              style: plusJakartaSans.copyWith(
                  fontWeight: semiBold, fontSize: 12, color: neutral01),
            )
          ],
        ),
      ),
    );
  }
}
