import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/components/material_design_indicator.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/medical_record_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/pages/hewanku/comp/edit_hewan_page.dart';
import 'package:galaxy_satwa/services/medical_record_service.dart';
import 'package:galaxy_satwa/services/pet_service.dart';
import 'package:intl/intl.dart';

class DetailHewankuPage extends StatefulWidget {
  final PetModel pet;
  const DetailHewankuPage({super.key, required this.pet});

  @override
  State<DetailHewankuPage> createState() => _DetailHewankuPageState();
}

class _DetailHewankuPageState extends State<DetailHewankuPage> {
  void _deletePet() async {
    ApiResponse response = await deletePet(widget.pet.id!);

    if (response.error == null) {
      // ignore: use_build_context_synchronously
      customDialog('Hapus Data Hewan', 'Data hewan berhasil di hapus',
          'assets/ic_sampah.png', () {
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
      }, () async {
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
        return true;
      }, context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  List<dynamic> medicalRecordList = [];
  void _getMedicalRecord() async {
    ApiResponse response = await getMedicalRecordByPetId(petId: widget.pet.id!);
    if (response.error == null) {
      medicalRecordList = response.data as List<dynamic>;
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
    var now = DateTime.now();
    month = int.parse(DateFormat("MM").format(now));
    year = int.parse(DateFormat("yyyy").format(now));
    _getMedicalRecord();
    super.initState();
  }

  int month = 5, year = 2024;
  bool filter = false;
  @override
  Widget build(BuildContext context) {
    String monthName = DateFormat.MMMM().format(DateTime(year, month));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Data Hewan'),
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
            height: 10,
          ),
          Container(
            width: 83,
            height: 80,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  '${widget.pet.image}',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: neutral07,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          TabBar(
                            labelPadding: EdgeInsets.zero,
                            indicator: MaterialDesignIndicator(
                                indicatorHeight: 4,
                                indicatorColor: primaryBlue1),
                            labelColor: neutral00,
                            labelStyle: plusJakartaSans.copyWith(
                                fontWeight: bold, fontSize: 12),
                            unselectedLabelColor: neutral00,
                            unselectedLabelStyle: plusJakartaSans.copyWith(
                                fontSize: 12, fontWeight: medium),
                            tabs: const [
                              Tab(
                                text: 'Data Hewan',
                              ),
                              Tab(
                                text: 'Riwayat Pemeriksaan',
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
                          //Data Hewan
                          ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              CustomDataHewan(
                                  title: 'Nama', value: widget.pet.name!),
                              CustomDataHewan(
                                  title: 'Umur', value: widget.pet.old!),
                              CustomDataHewan(
                                  title: 'Jenis Hewan',
                                  value: widget.pet.type!),
                              CustomDataHewan(
                                  title: 'Jenis Kelamin',
                                  value: widget.pet.gender!),
                              CustomDataHewan(
                                  title: 'Warna', value: widget.pet.color!),
                              CustomDataHewan(
                                  title: 'Tato', value: widget.pet.tatto!),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                content: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          24, 20, 24, 10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: neutral07,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            'assets/ic_sampah.png',
                                                            width: 24,
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          Text(
                                                            'Konfirmasi Hapus Data Hewan',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: inter.copyWith(
                                                                fontWeight:
                                                                    bold,
                                                                fontSize: 16,
                                                                color: const Color(
                                                                    0xFF1C1B1F)),
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          Text(
                                                            'Apa kamu yakin ingin menghapus semua data hewan ini?',
                                                            style: inter.copyWith(
                                                                fontSize: 14,
                                                                color:
                                                                    neutral00),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Batal',
                                                                    style: inter.copyWith(
                                                                        fontWeight:
                                                                            bold,
                                                                        color: const Color(
                                                                            0xFfEF4444)),
                                                                  )),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          _deletePet();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Ya',
                                                                          style: inter.copyWith(
                                                                              fontWeight: bold,
                                                                              color: primaryGreen1),
                                                                        )),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFF302F),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: Text(
                                            'Hapus',
                                            style: plusJakartaSans.copyWith(
                                                fontWeight: semiBold,
                                                color: neutral07),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditHewanPage(
                                                      pet: widget.pet,
                                                    )));
                                      },
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFB0DA43),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: Text(
                                            'Edit',
                                            style: plusJakartaSans.copyWith(
                                                fontWeight: semiBold,
                                                color: neutral07),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),

                          // Riwayat
                          ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Pilih Bulan Pemeriksaan',
                                style: plusJakartaSans.copyWith(
                                    fontSize: 12,
                                    fontWeight: medium,
                                    color: const Color(0xFF586266)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  showMonthPicker(context,
                                      onSelected: (month, year) {
                                    setState(() {
                                      this.month = month;
                                      this.year = year;
                                      filter = true;
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 5),
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
                                      !filter
                                          ? Text(
                                              'Filter tanggal',
                                              style: plusJakartaSans.copyWith(
                                                  color: neutral02),
                                            )
                                          : Text(
                                              '$monthName $year',
                                              style: plusJakartaSans.copyWith(
                                                  color: neutral01),
                                            ),
                                      const Spacer(),
                                      const Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: List.generate(
                                    medicalRecordList.length, (index) {
                                  MedicalRecordModel medicalRecord =
                                      medicalRecordList[index];
                                  String formattedDate =
                                      DateFormat('dd MMMM yyyy').format(
                                          DateTime.parse(medicalRecord.date!));
                                  String formattedDateF =
                                      DateFormat('MMMM yyyy').format(
                                          DateTime.parse(medicalRecord.date!));
                                  if (!filter ||
                                      (filter &&
                                          formattedDateF ==
                                              '$monthName $year')) {
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
                                                Text(
                                                  '${medicalRecord.pet!.name} (${medicalRecord.pet!.type})',
                                                  style:
                                                      plusJakartaSans.copyWith(
                                                          fontSize: 12,
                                                          fontWeight: semiBold,
                                                          color: primaryBlue1),
                                                ),
                                                Text(
                                                  '${medicalRecord.doctor!.name}',
                                                  style:
                                                      plusJakartaSans.copyWith(
                                                          fontSize: 12,
                                                          fontWeight: semiBold,
                                                          color: const Color(
                                                              0xFF94959A)),
                                                ),
                                                Text(
                                                  formattedDate,
                                                  style:
                                                      plusJakartaSans.copyWith(
                                                          fontSize: 12,
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
                                                top: 8.5, bottom: 0.5),
                                            color: const Color(0xFFD2D4DA),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Diagnosa',
                                                  style:
                                                      plusJakartaSans.copyWith(
                                                          fontSize: 12,
                                                          color: primaryBlue1),
                                                ),
                                                Text(
                                                  '${medicalRecord.diagnosis}',
                                                  style:
                                                      plusJakartaSans.copyWith(
                                                          fontSize: 12,
                                                          color: const Color(
                                                              0xFF94959A)),
                                                ),
                                                Text(
                                                  'Resep : ${medicalRecord.recipe}',
                                                  style:
                                                      plusJakartaSans.copyWith(
                                                          fontSize: 12,
                                                          color: const Color(
                                                              0xFF94959A)),
                                                )
                                              ],
                                            ),
                                          )
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
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDataHewan extends StatelessWidget {
  final String title;
  final String value;
  const CustomDataHewan({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: inter.copyWith(
              fontSize: 12, fontWeight: semiBold, color: neutral00),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 20, bottom: 25),
          child: Text(
            value,
            style: inter.copyWith(fontSize: 12, color: const Color(0xFF353E5C)),
          ),
        )
      ],
    );
  }
}
