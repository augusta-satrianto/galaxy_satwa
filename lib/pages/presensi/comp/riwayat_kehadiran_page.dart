import 'package:flutter/material.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/attendance_model.dart';
import 'package:galaxy_satwa/services/attendance_service.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../config/theme.dart';

class RiwayatKehadiranPage extends StatefulWidget {
  const RiwayatKehadiranPage({super.key});

  @override
  State<RiwayatKehadiranPage> createState() => _RiwayatKehadiranPageState();
}

class _RiwayatKehadiranPageState extends State<RiwayatKehadiranPage> {
  List<dynamic> attendanceList = [];
  List<String> hadirList = [];
  List<String> terlambatList = [];
  void _getAttendance() async {
    ApiResponse response = await getAttendanceByUserLogin();
    if (response.error == null) {
      attendanceList = response.data as List<dynamic>;
      for (int i = 0; i < attendanceList.length; i++) {
        AttendanceModel attendance = attendanceList[i];
        DateTime checkInDateTime =
            DateFormat('HH:mm:ss').parse(attendance.checkIn!);
        DateTime eightAM = DateFormat('HH:mm:ss').parse('08:00:01');

        if (checkInDateTime.isBefore(eightAM)) {
          hadirList.add(attendance.date!);
        } else {
          terlambatList.add(attendance.date!);
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
    _getAttendance();
    super.initState();
  }

  String? selectDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kehadiran'),
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
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 28.17),
            // padding: const EdgeInsets.fromLTRB(39, 10, 39, 29),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFC1C2C4)),
                borderRadius: BorderRadius.circular(6.528)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  weekendDays: const [6, 7],
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: inter.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333)),
                      weekendStyle: inter.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333))),
                  firstDay: DateTime.utc(2024, 6, 1),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  calendarStyle: CalendarStyle(
                    cellMargin: const EdgeInsets.all(3),
                    todayTextStyle: inter.copyWith(
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                    todayDecoration: const BoxDecoration(
                        color: Color(0xFFE2313D), shape: BoxShape.circle),
                    weekendTextStyle: inter.copyWith(
                        color: const Color(0xFFE2313D),
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                    defaultTextStyle: inter.copyWith(
                        color: const Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                    tablePadding: const EdgeInsets.fromLTRB(39, 0, 39, 29),
                  ),
                  rowHeight: 40,
                  daysOfWeekHeight: 20,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectDate = DateFormat('yyyy-MM-dd').format(selectedDay);
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, date, events) {
                      return Container(
                        width: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryBlue1,
                        ),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      );
                    },
                    defaultBuilder: (context, date, events) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(date);
                      if (date.weekday == DateTime.saturday ||
                          date.weekday == DateTime.sunday ||
                          date.isAfter(DateTime.now())) {
                        return null;
                      } else if (hadirList.contains(formattedDate)) {
                        return Container(
                          width: 22,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF34BD32),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        );
                      } else if (terlambatList.contains(formattedDate)) {
                        return Container(
                          width: 22,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFAE00),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        );
                      } else {
                        return Container(
                          width: 22,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF44336),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keterangan',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold,
                            fontSize: 12,
                            color: const Color(0xFF19213D)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: primaryBlue1),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(
                              'Hari Ini',
                              style: plusJakartaSans.copyWith(
                                  fontWeight: medium,
                                  fontSize: 11,
                                  color: const Color(0xFF19213D)),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.only(
                              right: 5,
                            ),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF34BD32)),
                          ),
                          Text(
                            'Sudah Presensi',
                            style: plusJakartaSans.copyWith(
                                fontWeight: medium,
                                fontSize: 11,
                                color: const Color(0xFF19213D)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFAE00)),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(
                              'Terlambat  Presensi',
                              style: plusJakartaSans.copyWith(
                                  fontWeight: medium,
                                  fontSize: 11,
                                  color: const Color(0xFF19213D)),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.only(
                              right: 5,
                            ),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF44336)),
                          ),
                          Text(
                            'Tidak Presensi',
                            style: plusJakartaSans.copyWith(
                                fontWeight: medium,
                                fontSize: 11,
                                color: const Color(0xFF19213D)),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          if (selectDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color(0xFFC1C2C4),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy')
                              .format(DateTime.parse(selectDate!)),
                          style: plusJakartaSans.copyWith(
                              color: neutral00, fontWeight: bold),
                        ),
                        Image.asset(
                          'assets/ic_kalender_rounded.png',
                          width: 25,
                          color: neutral02,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: List.generate(attendanceList.length, (index) {
                      AttendanceModel attendance = attendanceList[index];
                      DateTime checkInDateTime =
                          DateTime.parse('1970-01-01 ${attendance.checkIn!}');
                      DateTime comparisonTime =
                          DateTime.parse('1970-01-01 08:00:00');
                      if (attendance.date == selectDate) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width - 60) / 2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 30),
                              decoration: BoxDecoration(
                                color: neutral06,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF000000)
                                        .withOpacity(0.24),
                                    spreadRadius: 0,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Waktu absen masuk',
                                    style: plusJakartaSans.copyWith(
                                        fontWeight: bold,
                                        fontSize: 12,
                                        color: neutral00),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    attendance.checkIn!.substring(0, 5),
                                    style: plusJakartaSans.copyWith(
                                        fontWeight: bold,
                                        fontSize: 28,
                                        color: attendance.date! ==
                                                DateTime.now()
                                                    .toString()
                                                    .substring(0, 10)
                                            ? primaryBlue1
                                            : checkInDateTime
                                                    .isAfter(comparisonTime)
                                                ? const Color(0xFFFFAE00)
                                                : const Color(0xFF34BD32)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 30),
                              width:
                                  (MediaQuery.of(context).size.width - 60) / 2,
                              decoration: BoxDecoration(
                                color: neutral06,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF000000)
                                        .withOpacity(0.24),
                                    spreadRadius: 0,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Waktu absen pulang',
                                    style: plusJakartaSans.copyWith(
                                        fontWeight: bold,
                                        fontSize: 12,
                                        color: neutral00),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    attendance.checkOut != null
                                        ? attendance.checkOut!.substring(0, 5)
                                        : '-',
                                    style: plusJakartaSans.copyWith(
                                      fontWeight: bold,
                                      fontSize: 28,
                                      color: attendance.date! ==
                                              DateTime.now()
                                                  .toString()
                                                  .substring(0, 10)
                                          ? primaryBlue1
                                          : checkInDateTime
                                                  .isAfter(comparisonTime)
                                              ? const Color(0xFFFFAE00)
                                              : const Color(0xFF34BD32),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
