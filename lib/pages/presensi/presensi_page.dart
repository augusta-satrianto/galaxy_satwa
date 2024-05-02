import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
// import 'package:galaxy_satwa/config/aa.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/attendance_model.dart';
import 'package:galaxy_satwa/pages/presensi/comp/rincian_gaji_page.dart';
import 'package:galaxy_satwa/pages/presensi/comp/riwayat_kehadiran_page.dart';
import 'package:galaxy_satwa/pages/tahap_presensi/tahap_lokasi_page.dart';
import 'package:galaxy_satwa/services/attendance_service.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../config/theme.dart';

class PresensiPage extends StatefulWidget {
  const PresensiPage({super.key});

  @override
  State<PresensiPage> createState() => _PresensiPageState();
}

class _PresensiPageState extends State<PresensiPage> {
  String? currentTime;
  String? currentDate;
  int? countDay;
  DateTime selectedDate = DateTime.now();

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("HH:mm a").format(now);
  }

  String getSystemDate() {
    var now = DateTime.now();
    return DateFormat("EEEE, d MMMM yyyy").format(now);
  }

  int countWeekdaysInMonth(int year, int month) {
    int count = 0;
    for (int day = 1; day <= DateTime.utc(year, month + 1, 0).day; day++) {
      DateTime date = DateTime(year, month, day);
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        count++;
      }
    }
    return count;
  }

  int countTelat = 0;
  List<dynamic> attendanceList = [];
  void _getAttendance({required String yearmonth}) async {
    countTelat = 0;
    ApiResponse response = await getAttendanceMonthly(yearmonth: yearmonth);
    if (response.error == null) {
      attendanceList = response.data as List<dynamic>;
      for (int i = 0; i < attendanceList.length; i++) {
        AttendanceModel attendance = attendanceList[i];
        List<String> checkInParts = attendance.checkIn!.split(':');
        int hour = int.parse(checkInParts[0]);
        int minute = int.parse(checkInParts[1]);
        if (hour > 8 || (hour == 8 && minute > 1)) {
          countTelat++;
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

  String attendanceToday = '';
  void _getAttendanceToday() async {
    attendanceToday = await getAttendanceToday();
    if (attendanceToday != 'Error') {
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$attendanceToday')),
        );
      }
    }
  }

  @override
  void initState() {
    _getAttendanceToday();
    var now = DateTime.now();
    month = int.parse(DateFormat("MM").format(now));
    year = int.parse(DateFormat("yyyy").format(now));
    _getAttendance(yearmonth: DateFormat("yyyy-MM").format(now));
    currentTime = getSystemTime();
    currentDate = getSystemDate();
    countDay = countWeekdaysInMonth(int.parse(DateFormat("yyyy").format(now)),
        int.parse(DateFormat("MM").format(now)));
    super.initState();
  }

  int month = 1, year = 2024;
  @override
  Widget build(BuildContext context) {
    String monthName = DateFormat.MMMM().format(DateTime(year, month));
    return TimerBuilder.periodic(const Duration(seconds: 1),
        builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const SizedBox(
                  width: 24,
                ),
                const Text('Kehadiran'),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RiwayatKehadiranPage())),
                  icon: Image.asset(
                    'assets/ic_history.png',
                    width: 24,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    getSystemTime(),
                    style: plusJakartaSans.copyWith(
                        fontWeight: semiBold, fontSize: 36, color: neutral00),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    getSystemDate(),
                    style: plusJakartaSans.copyWith(
                        fontSize: 12, color: neutral200),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/ic_kalender_rounded.png',
                    width: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(currentDate.toString().split(', ')[1],
                      style: plusJakartaSans.copyWith(
                          fontSize: 12, color: neutral00)),
                  const Spacer(),
                  Image.asset(
                    'assets/ic_jam_rounded.png',
                    width: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text('08:00 - 22:00',
                      style: plusJakartaSans.copyWith(
                          fontSize: 12, color: neutral00)),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
              const SizedBox(
                height: 9,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (attendanceToday == 'Kosong') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TahapLokasiPage(
                                      jenisAbsen: 'Absen Masuk',
                                      tanggal: DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()),
                                    )));
                      }
                    },
                    child: Container(
                      height: 55,
                      width: (MediaQuery.of(context).size.width / 2) - 24 - 1,
                      decoration: BoxDecoration(
                          color: primaryGreen1,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              topLeft: Radius.circular(4))),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/ic_masuk.png',
                              width: 32,
                              color: attendanceToday == 'Kosong'
                                  ? neutral100
                                  : const Color(0xFF94959A),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Absen Masuk',
                              style: plusJakartaSans.copyWith(
                                  fontWeight: medium,
                                  fontSize: 12,
                                  color: attendanceToday == 'Kosong'
                                      ? neutral100
                                      : const Color(0xFF94959A)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    width: 2,
                    decoration: BoxDecoration(color: primaryGreen1),
                    child: Center(
                      child: Container(
                        height: 47,
                        width: 1,
                        color: neutral100,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (attendanceToday != 'Kosong' &&
                          attendanceToday.contains('null')) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TahapLokasiPage(
                                      idAttendance:
                                          attendanceToday.split('||').first,
                                      jenisAbsen: 'Absen Keluar',
                                      tanggal: DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()),
                                    )));
                      }
                    },
                    child: Container(
                      height: 55,
                      width: (MediaQuery.of(context).size.width / 2) - 24 - 1,
                      decoration: BoxDecoration(
                          color: primaryGreen1,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(4),
                              topRight: Radius.circular(4))),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/ic_keluar.png',
                              width: 32,
                              color: attendanceToday != 'Kosong' &&
                                      attendanceToday.contains('null')
                                  ? neutral100
                                  : const Color(0xFF94959A),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Absen Keluar',
                              style: plusJakartaSans.copyWith(
                                  fontWeight: medium,
                                  fontSize: 12,
                                  color: attendanceToday != 'Kosong' &&
                                          attendanceToday.contains('null')
                                      ? neutral100
                                      : const Color(0xFF94959A)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Penuhi presensimu setiap bulannya dan lihat',
                  style: plusJakartaSans.copyWith(
                      fontSize: 11, color: const Color(0xFF45484F)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RincianGajiPage()));
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 4),
                      child: Text(
                        'Rincian Keterangan Gaji',
                        style: plusJakartaSans.copyWith(
                            fontSize: 11, color: primaryBlue1),
                      ),
                    ),
                  ),
                  Text(
                    'sesuai jumlah presensimu.',
                    style: plusJakartaSans.copyWith(
                        fontSize: 11, color: const Color(0xFF45484F)),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () async {
                  showMonthPicker(context, onSelected: (month, year) {
                    setState(() {
                      this.month = month;
                      this.year = year;
                      _getAttendance(
                          yearmonth:
                              month < 10 ? '$year-0$month' : '$year-$month');
                    });
                  },
                      initialSelectedMonth: month,
                      initialSelectedYear: year,
                      firstEnabledMonth: 3,
                      lastEnabledMonth: 10,
                      firstYear: 2020,
                      lastYear: 2030,
                      selectButtonText: 'OK',
                      cancelButtonText: 'Cancel',
                      highlightColor: primaryBlue1,
                      textColor: Colors.black,
                      contentBackgroundColor: Colors.white,
                      dialogBackgroundColor: Colors.grey[200]);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: neutral200)),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/ic_kalender_rounded.png',
                        width: 24,
                        color: neutral02,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        '$monthName $year',
                        style: plusJakartaSans.copyWith(color: neutral01),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xFFC1C2C4).withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Daftar Presensi Bulan Maret',
                          style: plusJakartaSans.copyWith(
                              fontSize: 16, color: neutral00),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          'assets/ic_hadir.png',
                          width: 23,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5.5,
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '${attendanceList.length} ',
                            style: plusJakartaSans.copyWith(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: neutral00),
                          ),
                          TextSpan(
                            text: '/ $countDay Kehadiran',
                            style: plusJakartaSans.copyWith(
                                fontSize: 11, color: neutral00),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 6.5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: LinearProgressIndicator(
                              value: attendanceList.length / countDay!,
                              minHeight: 5,
                              valueColor: AlwaysStoppedAnimation(success),
                              backgroundColor:
                                  const Color(0xFFC1C2C4).withOpacity(0.5),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          (attendanceList.length * 100 / countDay!)
                                  .toStringAsFixed(1)
                                  .contains('.0')
                              ? '${(attendanceList.length * 100 / countDay!).toStringAsFixed(1).split('.').first}%'
                              : '${(attendanceList.length * 100 / countDay!).toStringAsFixed(1)}%',
                          style: plusJakartaSans.copyWith(
                              fontSize: 10,
                              color: neutral200,
                              fontWeight: medium),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: 142,
                height: 131,
                child: CustomPelanggaran(
                  body: 'Terlambat\nabsen masuk',
                  iconUrl: 'assets/ic_terlambat.png',
                  countP: countTelat.toString(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ));
    });
  }
}

class CustomPelanggaran extends StatelessWidget {
  final String body;
  final String iconUrl;
  final String countP;
  const CustomPelanggaran(
      {super.key,
      required this.body,
      required this.iconUrl,
      required this.countP});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/img_bg_pelanggaran.png'),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: '$countP ',
                          style: plusJakartaSans.copyWith(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: neutral00),
                        ),
                        TextSpan(
                          text: 'Kali',
                          style: plusJakartaSans.copyWith(
                              fontSize: 11, color: neutral00),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    body,
                    style: plusJakartaSans.copyWith(color: neutral00),
                  )
                ],
              ),
              Image.asset(
                iconUrl,
                width: 23,
              )
            ],
          ),
        )
      ],
    );
  }
}
