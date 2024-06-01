import 'dart:async';

import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/appointment_model.dart';
import 'package:galaxy_satwa/models/notification_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/models/schedule_model.dart';
import 'package:galaxy_satwa/pages/hewanku/comp/create_hewan_page.dart';
import 'package:galaxy_satwa/pages/hewanku/comp/detail_hewan_page.dart';
import 'package:galaxy_satwa/pages/notifikasi/notifikasi_page.dart';
import 'package:galaxy_satwa/pages/tahap_presensi/tahap_lokasi_page.dart';
import 'package:galaxy_satwa/services/appointment_service.dart';
import 'package:galaxy_satwa/services/attendance_service.dart';
import 'package:galaxy_satwa/services/notification_service.dart';
import 'package:galaxy_satwa/services/pet_service.dart';
import 'package:galaxy_satwa/services/schedule_service.dart';
import 'package:intl/intl.dart';

class BerandaPage extends StatefulWidget {
  final String role;
  final String name;
  final String urlImage;

  const BerandaPage(
      {super.key,
      required this.role,
      required this.name,
      required this.urlImage});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  List<dynamic> notificationList = [];
  int countNotRead = 0;
  void _getNotification() async {
    countNotRead = 0;
    ApiResponse response = await getNotificationByUserLogin();
    if (response.error == null) {
      notificationList = response.data as List<dynamic>;
      for (int i = 0; i < notificationList.length; i++) {
        NotificationModel notif = notificationList[i];
        if (notif.isRead == 0) {
          countNotRead++;
        }
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('getNotification')),
        );
      }
    }
  }

  List<dynamic> petList = [];
  PetCountModel? petCountModel;
  void _getPet() async {
    if (widget.role == 'pasien') {
      ApiResponse response = await getPetByUserLogin();
      if (response.error == null) {
        petList = response.data as List<dynamic>;
        if (mounted) {
          setState(() {});
        }
      } else {
        // ignore: use_build_context_synchronously
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('getPetByUserLogin')),
          );
        }
      }
    } else {
      ApiResponse response = await getCountPet();
      if (response.error == null) {
        petCountModel = response.data as PetCountModel;
        if (mounted) {
          setState(() {});
        }
      } else {
        // ignore: use_build_context_synchronously
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${response.error}')),
          );
        }
      }
    }
  }

  String attendanceToday = '';
  void _getAttendanceToday() async {
    attendanceToday = await getAttendanceToday();
    if (attendanceToday != 'Error') {
      if (mounted) {
        setState(() {});
      }
    } else {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$attendanceToday')),
        );
      }
    }
  }

  List<dynamic> scheduleList = [];
  void _getSchedule() async {
    ApiResponse response = await getScheduleAll();
    if (response.error == null) {
      scheduleList = response.data as List<dynamic>;
      if (mounted) {
        setState(() {});
      }
    } else {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
      }
    }
  }

  List<dynamic> appointmentList = [];
  bool hasData = true;
  void _getAppointment() async {
    ApiResponse response = await getAppointmentWillCome();
    if (response.error == null) {
      appointmentList = response.data as List<dynamic>;
      if (mounted) {
        setState(() {});
      }
    } else {
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
      }
    }
  }

  Timer? _timer;
  @override
  void initState() {
    _getNotification();
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => _getNotification());
    _getPet();
    _getAttendanceToday();
    _getSchedule();
    _getAppointment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(children: [
          Stack(
            children: [
              Container(
                height: 143 + paddingTop,
                padding:
                    EdgeInsets.only(top: paddingTop + 23, right: 24, left: 24),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/img_bg_nav.png',
                        ),
                        fit: BoxFit.cover)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Halo ',
                                  style: plusJakartaSans.copyWith(
                                      fontWeight: bold,
                                      color: neutral07,
                                      fontSize: 18)),
                              Expanded(
                                child: Text(
                                  widget.name
                                          .split(' ')[0]
                                          .toLowerCase()
                                          .contains('dr')
                                      ? '${widget.name.split(' ')[0]} ${widget.name.split(' ')[1]},'
                                      : widget.name.split(' ')[0],
                                  style: plusJakartaSans.copyWith(
                                    fontWeight: bold,
                                    fontSize: 22,
                                    color: neutral07,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Have  a nice day !',
                            style: plusJakartaSans.copyWith(
                                fontSize: 14,
                                fontWeight: bold,
                                color: neutral07),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotifikasiPage()));
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6, right: 4),
                            child: Image.asset(
                              'assets/ic_notif.png',
                              width: 24,
                            ),
                          ),
                          if (countNotRead > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: danger, shape: BoxShape.circle),
                                child: Text(
                                  countNotRead.toString(),
                                  style: inter.copyWith(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    ClipOval(
                      child: SizedBox(
                          width: 38,
                          height: 38,
                          child: Image.network(
                            widget.urlImage,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
              ),
              widget.role == 'pasien'
                  ? Container(
                      margin: EdgeInsets.only(
                          top: paddingTop + 90, left: 24, right: 24),
                      height: 117,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEFDFF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 102,
                                    width: 127,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20)),
                                        image: DecorationImage(
                                            image: AssetImage(
                                              'assets/img_hospital.png',
                                            ),
                                            fit: BoxFit.fitHeight)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Klinik  Hewan Galaxy Satwa',
                                  style: plusJakartaSans.copyWith(
                                      fontWeight: semiBold,
                                      color: const Color(0xFF263238)),
                                ),
                                const SizedBox(
                                  height: 11,
                                ),
                                Text(
                                  'Jl. Perumahan Menganti Permai\nBlok D6 No.3 \n\nJam Buka : 08.00 - 21.00',
                                  style: plusJakartaSans.copyWith(
                                      fontSize: 12,
                                      fontWeight: medium,
                                      color: const Color(0xFF94959A)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                          top: paddingTop + 90, left: 24, right: 24),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 17),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: neutral07,
                        borderRadius: BorderRadius.circular(20),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Jangan lewatkan kehadiran hari ini!',
                            style: inter.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                                color: const Color(0xFF263238)),
                          ),
                          const SizedBox(
                            height: 13,
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
                              Text(
                                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                style: plusJakartaSans.copyWith(
                                    fontSize: 12, color: neutral00),
                              ),
                              const Spacer(),
                              Image.asset(
                                'assets/ic_jam_rounded.png',
                                width: 16,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '08:00 - 22:00',
                                style: plusJakartaSans.copyWith(
                                    fontSize: 12, color: neutral00),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (attendanceToday == 'Kosong') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TahapLokasiPage(
                                                  jenisAbsen: 'Absen Masuk',
                                                  tanggal: DateFormat(
                                                          'dd MMMM yyyy')
                                                      .format(DateTime.now()),
                                                )));
                                  }
                                },
                                child: Container(
                                  height: 32,
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          41 -
                                          1,
                                  decoration: BoxDecoration(
                                      color: primaryGreen1,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                          topLeft: Radius.circular(4))),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/ic_masuk.png',
                                          width: 20,
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
                                height: 32,
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
                                            builder: (context) =>
                                                TahapLokasiPage(
                                                  idAttendance: attendanceToday
                                                      .split('||')
                                                      .first,
                                                  jenisAbsen: 'Absen Keluar',
                                                  tanggal: DateFormat(
                                                          'dd MMMM yyyy')
                                                      .format(DateTime.now()),
                                                )));
                                  }
                                },
                                child: Container(
                                  height: 32,
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          41 -
                                          1,
                                  decoration: BoxDecoration(
                                      color: primaryGreen1,
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(4),
                                          topRight: Radius.circular(4))),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/ic_keluar.png',
                                          width: 20,
                                          color: attendanceToday != 'Kosong' &&
                                                  attendanceToday
                                                      .contains('null')
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
                                              color: attendanceToday !=
                                                          'Kosong' &&
                                                      attendanceToday
                                                          .contains('null')
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
                            height: 4,
                          ),
                        ],
                      ),
                    )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (widget.role == 'pasien' && petList.isEmpty) _tambahHewan(context),
          if (widget.role == 'pasien' && petList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    'Hewanku',
                    style: inter.copyWith(fontWeight: medium, color: neutral00),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 14,
                    ),
                    itemCount: petList.length,
                    itemBuilder: (context, index) {
                      PetModel pet = petList[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailHewankuPage(
                                              pet: pet,
                                            ))).then((receivedData) {
                                  if (receivedData == 'retrive') {
                                    _getPet();
                                  }
                                }),
                                child: Container(
                                  width: 63,
                                  height: 60,
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        '${pet.image}',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                pet.name!.split(' ').first,
                                style: inter.copyWith(
                                    fontSize: 12, color: Color(0xFF94959A)),
                              )
                            ],
                          ),
                          if (index + 1 == petList.length)
                            Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateHewanPage())),
                                child: Image.asset(
                                  'assets/ic_plus_circle.png',
                                  width: 63,
                                ),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          if (widget.role != 'pasien') _statistikHarian(role: widget.role),
          if (widget.role != 'pasien' && petCountModel != null)
            _jumlahHewan(petCount: petCountModel!),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Pemberitahuan',
              style: inter.copyWith(fontWeight: medium, color: neutral00),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Column(
            children: List.generate(scheduleList.length, (index) {
              ScheduleModel schedule = scheduleList[index];
              return Container(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 13),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                decoration: BoxDecoration(
                    color: schedule.category == 'Vaksinasi'
                        ? const Color(0xFFF7E4FF)
                        : const Color(0xFFFFE7BC),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Image.asset(
                      schedule.category == 'Vaksinasi'
                          ? 'assets/img_vaksin.png'
                          : 'assets/img_imunisasi.png',
                      width: 45,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.role == 'pasien'
                                ? 'Ayo ${schedule.category} Hewanmu !!'
                                : 'Terdapat Jadwal ${schedule.category}',
                            style: inter.copyWith(
                                fontWeight: medium,
                                fontSize: 12,
                                color: neutral00),
                          ),
                          Text(
                            'Tanggal ${schedule.category!.toLowerCase()} : ${DateFormat('d MMMM yyyy').format(DateTime.parse(schedule.date!))}',
                            style: inter.copyWith(
                                fontWeight: medium,
                                fontSize: 12,
                                color: neutral00),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Column(
            children: List.generate(appointmentList.length, (index) {
              AppointmentModel appointment = appointmentList[index];
              if (index == 0) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                  decoration: BoxDecoration(
                      color: const Color(0xFFCDF4DC),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/img_kalender.png',
                        width: 45,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jangan Lupa Janji Temu Kamu!!\nTanggal : ${DateFormat('EEEE, d MMMM yyyy').format(DateTime.parse(appointment.date!))}',
                              style: inter.copyWith(
                                  fontWeight: medium,
                                  fontSize: 12,
                                  color: neutral00),
                            ),
                            widget.role == 'pasien'
                                ? Text(
                                    'Dokter   : ${appointment.doctor!.name}',
                                    style: inter.copyWith(
                                        fontWeight: medium,
                                        fontSize: 12,
                                        color: neutral00),
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hewan   : ',
                                        style: inter.copyWith(
                                            fontWeight: medium,
                                            fontSize: 12,
                                            color: neutral00),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${appointment.pet!.name} (${appointment.pet!.type})',
                                          style: inter.copyWith(
                                              fontWeight: medium,
                                              fontSize: 12,
                                              color: neutral00),
                                        ),
                                      ),
                                    ],
                                  ),
                            Text(
                              'Jam        : ${appointment.time!.substring(0, 5)}',
                              style: inter.copyWith(
                                  fontWeight: medium,
                                  fontSize: 12,
                                  color: neutral00),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}

_tambahHewan(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CreateHewanPage()));
    },
    child: Container(
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF0DE1F8),
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Image.asset(
            'assets/img_jejak.png',
            width: 39,
          ),
          const SizedBox(
            width: 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tambahkan Hewanmu',
                style: inter.copyWith(fontWeight: medium, color: neutral00),
              ),
              Text(
                'Kamu belum menambahkan hewanmu',
                style: inter.copyWith(fontSize: 10, color: neutral200),
              )
            ],
          ),
          const Spacer(),
          Image.asset(
            'assets/ic_plus_rec.png',
            width: 28,
          ),
        ],
      ),
    ),
  );
}

_statistikHarian({required String role}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 63,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFFFFEAE7),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/img_suntik.png',
                  width: 28,
                ),
                const SizedBox(
                  width: 4,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah Operasi',
                      style: plusJakartaSans.copyWith(
                          fontWeight: medium, fontSize: 12, color: neutral00),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Operasi Ringan : 30',
                      style: plusJakartaSans.copyWith(
                          fontSize: 10, color: const Color(0xFF94959A)),
                    ),
                    Text(
                      'Operasi Berat     : 20',
                      style: plusJakartaSans.copyWith(
                          fontSize: 10, color: const Color(0xFF94959A)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        if (role == 'dokter')
          Expanded(
            child: Container(
              height: 63,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(left: 13),
              decoration: BoxDecoration(
                  color: const Color(0xFFEEFFC2),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/img_kotak_obat.png',
                    width: 28,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pasien Hari ini',
                        style: plusJakartaSans.copyWith(
                            fontWeight: medium, fontSize: 12, color: neutral00),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '10',
                            style: plusJakartaSans.copyWith(
                                fontSize: 24, color: const Color(0xFF94959A)),
                          ),
                          Text(
                            '  Hewan',
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: const Color(0xFF94959A)),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

_jumlahHewan({required PetCountModel petCount}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jumlah Hewan',
          style: inter.copyWith(fontWeight: medium, color: neutral00),
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(10)),
          child: Wrap(children: [
            _customListHewan(
                urlImage: 'assets/img_cat_kucing.png',
                category: 'Kucing',
                count: petCount.kucing!),
            _customListHewan(
                urlImage: 'assets/img_cat_anjing.png',
                category: 'Anjing',
                count: petCount.anjing!),
            _customListHewan(
                urlImage: 'assets/img_cat_kelinci.png',
                category: 'Kelinci',
                count: petCount.kelinci!),
            _customListHewan(
                urlImage: 'assets/img_cat_burung.png',
                category: 'Burung',
                count: petCount.burung!),
            _customListHewan(
                urlImage: 'assets/img_cat_ular.png',
                category: 'Ular',
                count: petCount.ular!),
            _customListHewan(
                urlImage: 'assets/img_cat_hamster.png',
                category: 'Hamster',
                count: petCount.hamster!),
          ]),
        )
      ],
    ),
  );
}

_customListHewan(
    {required String urlImage, required String category, required int count}) {
  return Container(
    width: 130,
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          urlImage,
          width: 31,
        ),
        const SizedBox(
          width: 4,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: plusJakartaSans.copyWith(
                  fontWeight: medium, fontSize: 12, color: neutral00),
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              '$count hewan',
              style: plusJakartaSans.copyWith(
                  fontWeight: medium,
                  fontSize: 12,
                  color: const Color(0xFF94959A)),
            )
          ],
        )
      ],
    ),
  );
}
