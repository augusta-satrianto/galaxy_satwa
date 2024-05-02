import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/appointment_model.dart';
import 'package:galaxy_satwa/pages/janji_temu/comp/buat_janji_page.dart';
import 'package:galaxy_satwa/pages/janji_temu/comp/detail_janji_page.dart';
import 'package:galaxy_satwa/pages/janji_temu/comp/riwayat_janji_page.dart';
import 'package:galaxy_satwa/services/appointment_service.dart';
import 'package:intl/intl.dart';

class JanjiTemuPage extends StatefulWidget {
  const JanjiTemuPage({
    super.key,
  });

  @override
  State<JanjiTemuPage> createState() => _JanjiTemuPageState();
}

class _JanjiTemuPageState extends State<JanjiTemuPage> {
  List<dynamic> appointmentList = [];
  bool hasData = true;
  void _getAppointment() async {
    ApiResponse response = await getAppointmentByUserLogin();
    if (response.error == null) {
      appointmentList = response.data as List<dynamic>;
      for (int i = 0; i < appointmentList.length; i++) {
        AppointmentModel appointment = appointmentList[i];
        if (appointment.status == 'dibuat') {
          hasData = true;
          break;
        }
      }
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
    _getAppointment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Janji Temu'),
          titleSpacing: 24,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Image.asset(
                  'assets/ic_history.png',
                  width: 24,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RiwayatJanjiPage(
                                appointmentList: appointmentList,
                              )));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BuatJanjiPage()))
                .then((receivedData) {
              if (receivedData == 'retrive') {
                _getAppointment();
              }
            });
          },
          child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(bottom: 24, right: 10),
              decoration: BoxDecoration(
                  color: primaryGreen1, borderRadius: BorderRadius.circular(5)),
              child: const Center(
                  child: Icon(
                Icons.add,
                color: Colors.white,
              ))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: !hasData
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img_grafis_kalender.png',
                      width: 170,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Kamu belum membuat janji\ntemu dengan dokter',
                      textAlign: TextAlign.center,
                      style: plusJakartaSans.copyWith(
                          fontSize: 12, color: neutral02),
                    )
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                itemCount: appointmentList.length,
                itemBuilder: (context, index) {
                  AppointmentModel appointment = appointmentList[index];
                  DateTime parsedDate = DateTime.parse(appointment.date!);
                  String date = DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                      .format(parsedDate);
                  String dateNow = DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                      .format(DateTime.now());
                  DateTime parsedDateObject =
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').parse(date);
                  DateTime dateNowObject =
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').parse(dateNow);

                  return appointment.status == 'dibuat' &&
                          parsedDateObject.isAfter(dateNowObject)
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: neutral07,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFE0E0E0),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/img_kal_janji.png',
                                    width: 44,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Janji Temu Kamu Sudah Terjadwal\n',
                                          style: plusJakartaSans.copyWith(
                                              fontWeight: medium,
                                              fontSize: 12,
                                              color: neutral00),
                                        ),
                                        Text(
                                          'Tanggal   : $date',
                                          style: plusJakartaSans.copyWith(
                                              fontWeight: medium,
                                              fontSize: 12,
                                              color: neutral00),
                                        ),
                                        Text(
                                          'Jam              : ${appointment.time}',
                                          style: plusJakartaSans.copyWith(
                                              fontWeight: medium,
                                              fontSize: 12,
                                              color: neutral00),
                                        ),
                                        Text(
                                          'Dokter      : ${appointment.doctor!.name}',
                                          style: plusJakartaSans.copyWith(
                                              fontWeight: medium,
                                              fontSize: 12,
                                              color: neutral00),
                                        ),
                                        Text(
                                          'Hewan      : ${appointment.pet!.name}',
                                          style: plusJakartaSans.copyWith(
                                              fontWeight: medium,
                                              fontSize: 12,
                                              color: neutral00),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailJanjiPage(
                                                  appointment: appointment,
                                                ))).then((receivedData) {
                                      if (receivedData == 'retrive') {
                                        _getAppointment();
                                      }
                                    }),
                                    child: Container(
                                      color: neutral07,
                                      padding: const EdgeInsets.all(4),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Lihat Detail',
                                            style: plusJakartaSans.copyWith(
                                                fontWeight: medium,
                                                fontSize: 12,
                                                color: const Color(0xFFB0DA43)),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Image.asset(
                                            'assets/ic_arrow_right.png',
                                            width: 24,
                                            color: const Color(0xFFB0DA43),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      : Container();
                },
              ));
  }
}
