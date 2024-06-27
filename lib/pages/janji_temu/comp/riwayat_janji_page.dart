import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/material_design_indicator.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/appointment_model.dart';
import 'package:intl/intl.dart';

class RiwayatJanjiPage extends StatelessWidget {
  final List<dynamic> appointmentList;
  const RiwayatJanjiPage({super.key, required this.appointmentList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Janji Temu'),
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
      body: DefaultTabController(
        length: 3,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: neutral07,
                ),
                child: Stack(
                  children: [
                    TabBar(
                      labelPadding: EdgeInsets.zero,
                      indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      indicator: MaterialDesignIndicator(
                          indicatorHeight: 4, indicatorColor: primaryBlue1),
                      labelColor: neutral00,
                      labelStyle: plusJakartaSans.copyWith(
                          fontWeight: bold, fontSize: 12),
                      unselectedLabelColor: neutral00,
                      unselectedLabelStyle: plusJakartaSans.copyWith(
                          fontSize: 12, fontWeight: medium),
                      tabs: [
                        const Tab(
                          text: 'Semua',
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF22C55E),
                                ),
                              ),
                              const Text('Selesai'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF44336),
                                ),
                              ),
                              const Text('Dibatalkan'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    //Semua
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children:
                              List.generate(appointmentList.length, (index) {
                            AppointmentModel appointment =
                                appointmentList[index];
                            DateTime parsedDate =
                                DateTime.parse(appointment.date!);
                            String date =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .format(parsedDate);
                            String dateNow =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .format(DateTime.now());
                            DateTime parsedDateObject =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .parse(date);
                            DateTime dateNowObject =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .parse(dateNow);
                            if ((appointment.status == 'dibuat' &&
                                    parsedDateObject.isBefore(dateNowObject) ||
                                appointment.status == 'dibatalkan')) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBFDFF),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x22000000),
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${appointment.pet!.name} (${appointment.pet!.type})',
                                                style: plusJakartaSans.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: medium,
                                                    color: primaryBlue1),
                                              ),
                                              Container(
                                                height: 10,
                                                width: 10,
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: appointment.status ==
                                                          'dibatalkan'
                                                      ? danger
                                                      : success,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            date,
                                            style: plusJakartaSans.copyWith(
                                                fontSize: 12,
                                                color: const Color(0xFF94959A)),
                                          ),
                                          Text(
                                            'Jam ${appointment.time}',
                                            style: plusJakartaSans.copyWith(
                                                fontSize: 12,
                                                fontWeight: medium,
                                                color: const Color(0xFF94959A)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          top: 8.5, bottom: 15),
                                      color: const Color(0xFFD2D4DA),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                appointment.pet!.image!,
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 14,
                                            ),
                                            Text(
                                              appointment.pet!.name!,
                                              style: inter.copyWith(
                                                  color: neutral00),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                        )
                      ],
                    ),

                    //Selesai
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children:
                              List.generate(appointmentList.length, (index) {
                            AppointmentModel appointment =
                                appointmentList[index];
                            DateTime parsedDate =
                                DateTime.parse(appointment.date!);
                            String date =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .format(parsedDate);
                            String dateNow =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .format(DateTime.now());
                            DateTime parsedDateObject =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .parse(date);
                            DateTime dateNowObject =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .parse(dateNow);
                            return appointment.status != 'dibatalkan' &&
                                    parsedDateObject.isBefore(dateNowObject)
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 14),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFBFDFF),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x22000000),
                                          blurRadius: 2.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${appointment.pet!.name} (${appointment.pet!.type})',
                                                    style: plusJakartaSans
                                                        .copyWith(
                                                            fontSize: 12,
                                                            fontWeight: medium,
                                                            color:
                                                                primaryBlue1),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: success,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                date,
                                                style: plusJakartaSans.copyWith(
                                                    fontSize: 12,
                                                    color: const Color(
                                                        0xFF94959A)),
                                              ),
                                              Text(
                                                'Jam ${appointment.time}',
                                                style: plusJakartaSans.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: medium,
                                                    color: const Color(
                                                        0xFF94959A)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              top: 8.5, bottom: 15),
                                          color: const Color(0xFFD2D4DA),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    appointment.pet!.image!,
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 14,
                                                ),
                                                Text(
                                                  appointment.pet!.name!,
                                                  style: inter.copyWith(
                                                      color: neutral00),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                : Container();
                          }),
                        )
                      ],
                    ),

                    // Dibatalkan
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children:
                              List.generate(appointmentList.length, (index) {
                            AppointmentModel appointment =
                                appointmentList[index];
                            DateTime parsedDate =
                                DateTime.parse(appointment.date!);
                            String date =
                                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                    .format(parsedDate);
                            return appointment.status == 'dibatalkan'
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 14),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFBFDFF),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x22000000),
                                          blurRadius: 2.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${appointment.pet!.name} (${appointment.pet!.type})',
                                                    style: plusJakartaSans
                                                        .copyWith(
                                                            fontSize: 12,
                                                            fontWeight: medium,
                                                            color:
                                                                primaryBlue1),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: danger,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                date,
                                                style: plusJakartaSans.copyWith(
                                                    fontSize: 12,
                                                    color: const Color(
                                                        0xFF94959A)),
                                              ),
                                              Text(
                                                'Jam ${appointment.time}',
                                                style: plusJakartaSans.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: medium,
                                                    color: const Color(
                                                        0xFF94959A)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              top: 8.5, bottom: 15),
                                          color: const Color(0xFFD2D4DA),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    appointment.pet!.image!,
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 14,
                                                ),
                                                Text(
                                                  appointment.pet!.name!,
                                                  style: inter.copyWith(
                                                      color: neutral00),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                : Container();
                          }),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
