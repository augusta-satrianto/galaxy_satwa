import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/appointment_model.dart';
import 'package:galaxy_satwa/services/appointment_service.dart';
import 'package:intl/intl.dart';

class DetailJanjiPage extends StatefulWidget {
  final AppointmentModel appointment;
  const DetailJanjiPage({super.key, required this.appointment});

  @override
  State<DetailJanjiPage> createState() => _DetailJanjiPageState();
}

class _DetailJanjiPageState extends State<DetailJanjiPage> {
  void _updateAppointment() async {
    ApiResponse response = await updateAppointment(
        appointmentId: widget.appointment.id.toString(), status: 'dibatalkan');

    if (response.error == null) {
      // ignore: use_build_context_synchronously
      customDialog(
          'Pembatalan Janji Temu',
          'Jadwal janji temu berhasil dibatalkan',
          'assets/ic_kalender_check.png', () {
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
      }, () async {
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
        return true;
      }, context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(widget.appointment.date!);
    String date = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(parsedDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Janji Temu'),
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
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img_grafis_kalender2.png',
                  width: 220,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Image.asset(
                  'assets/img_kal_janji.png',
                  width: 45,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Janji Temu Kamu Sudah Terjadwal',
                  style: plusJakartaSans.copyWith(
                      fontWeight: bold, fontSize: 12, color: neutral00),
                ),
              ],
            ),
            const SizedBox(
              height: 27,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanggal   : $date',
                  style: plusJakartaSans.copyWith(
                      fontWeight: medium, fontSize: 12, color: neutral00),
                ),
                Text(
                  'Jam              : ${widget.appointment.time}',
                  style: plusJakartaSans.copyWith(
                      fontWeight: medium, fontSize: 12, color: neutral00),
                ),
                Text(
                  'Dokter      : ${widget.appointment.doctor!.name}',
                  style: plusJakartaSans.copyWith(
                      fontWeight: medium, fontSize: 12, color: neutral00),
                ),
                Text(
                  'Hewan      : ${widget.appointment.pet!.name}',
                  style: plusJakartaSans.copyWith(
                      fontWeight: medium, fontSize: 12, color: neutral00),
                )
              ],
            ),
            const Spacer(),
            CustomFilledButton(
                title: 'Batalkan Jadwal Janji Temu',
                onPressed: () {
                  _updateAppointment();
                }),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
