import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/components/file_handle_api.dart';
import 'package:galaxy_satwa/components/form.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/medical_record_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/pages/rekam_medis/comp/buat_rekam_medis_page.dart';
import 'package:galaxy_satwa/pages/rekam_medis/comp/edit_rekam_medis_page.dart';
import 'package:galaxy_satwa/pages/rekam_medis/comp/pdf_rekam_medis.dart';
import 'package:galaxy_satwa/services/medical_record_service.dart';
import 'package:intl/intl.dart';

class DetailRekamMedisPage extends StatefulWidget {
  final PetModel pet;
  const DetailRekamMedisPage({super.key, required this.pet});

  @override
  State<DetailRekamMedisPage> createState() => _DetailRekamMedisPageState();
}

class _DetailRekamMedisPageState extends State<DetailRekamMedisPage> {
  final tanggalController = TextEditingController();

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

  void _deleteMedicalRecord({required String recordId}) async {
    ApiResponse response = await deleteMedicalRecord(recordId);

    if (response.error == null) {
      // ignore: use_build_context_synchronously
      customDialog('Hapus Data Rekam Medis',
          'Data rekam medis berhasil di hapus', 'assets/ic_sampah.png', () {
        Navigator.pop(context);
        _getMedicalRecord();
      }, () async {
        Navigator.pop(context);
        _getMedicalRecord();
        return true;
      }, context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    _getMedicalRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tanggalController.addListener(() => setState(() {}));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Rekam Medis'),
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
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuatRekamMedis(
                        pet: widget.pet,
                      ))).then((receivedData) {
            if (receivedData == 'retrive') {
              _getMedicalRecord();
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.pet.name!,
                  style: plusJakartaSans.copyWith(
                      fontWeight: semiBold, fontSize: 16, color: neutral00),
                ),
              ),
              if (medicalRecordList.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pdfFile = await PdfRekamMedis.generate(
                            widget.pet.name!,
                            widget.pet.type!,
                            widget.pet.gender!,
                            widget.pet.color!,
                            widget.pet.old!,
                            widget.pet.tatto ?? '-',
                            medicalRecordList);
                        FileHandleApi.openFile(pdfFile);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: primaryGreen1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Unduh Rekam Medis',
                            style: plusJakartaSans.copyWith(
                                fontWeight: semiBold, color: neutral100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 68,
                margin: const EdgeInsets.only(
                    bottom: 4, right: 10, left: 10, top: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      '${widget.pet.image}',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _customListDetailRM(title: 'Nama', value: widget.pet.name!),
                    _customListDetailRM(title: 'Umur', value: widget.pet.old!),
                    _customListDetailRM(
                        title: 'Kategori Hewan', value: widget.pet.category!),
                    _customListDetailRM(
                        title: 'Jenis Hewan', value: widget.pet.type!),
                    _customListDetailRM(
                        title: 'Jenis Kelamin', value: widget.pet.gender!),
                    _customListDetailRM(
                        title: 'Warna', value: widget.pet.color!),
                    _customListDetailRM(
                        title: 'Tato', value: widget.pet.tatto!),
                    _customListDetailRM(
                        title: 'Nama Pemilik', value: widget.pet.user!.name!),
                    _customListDetailRM(
                        title: 'No.tlpn pemilik',
                        value: widget.pet.user!.phone != null
                            ? widget.pet.user!.phone!
                            : '-'),
                    _customListDetailRM(
                        title: 'Alamat',
                        value: widget.pet.user!.address != null
                            ? widget.pet.user!.address!
                            : '-'),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomFormDate(
              title: '-',
              placeholder: 'Pilih Tanggal Rekam Medis',
              hasTitle: false,
              tanggalController: tanggalController),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: List.generate(medicalRecordList.length, (index) {
              MedicalRecordModel medicalRecord = medicalRecordList[index];
              String formattedDate = DateFormat('dd MMMM yyyy')
                  .format(DateTime.parse(medicalRecord.date!));

              if (tanggalController.text.isEmpty ||
                  (tanggalController.text.isNotEmpty &&
                      formattedDate == tanggalController.text.split(', ')[1])) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formattedDate,
                              style: plusJakartaSans.copyWith(
                                  fontWeight: semiBold, color: primaryBlue1),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 11, bottom: 12),
                        color: const Color(0xFFD2D4DA),
                      ),
                      _customListDetailRM2(
                          title: 'Gejala Klinis',
                          value: medicalRecord.symptom!),
                      _customListDetailRM2(
                          title: 'Diagnosa', value: medicalRecord.diagnosis!),
                      _customListDetailRM2(
                          title: 'Tindakan', value: medicalRecord.action!),
                      _customListDetailRM2(
                          title: 'Resep', value: medicalRecord.recipe!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditRekamMedis(
                                            pet: widget.pet,
                                            medicalRecord: medicalRecord,
                                          ))).then((receivedData) {
                                if (receivedData == 'retrive') {
                                  _getMedicalRecord();
                                }
                              });
                            },
                            child: Container(
                              color: neutral07,
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                'assets/ic_pencil.png',
                                width: 21,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.all(0),
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                24, 20, 24, 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: neutral07,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/ic_sampah.png',
                                                  width: 24,
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                Text(
                                                  'Konfirmasi Hapus Data Rekam Medis',
                                                  textAlign: TextAlign.center,
                                                  style: inter.copyWith(
                                                      fontWeight: bold,
                                                      fontSize: 16,
                                                      color: const Color(
                                                          0xFF1C1B1F)),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                Text(
                                                  'Apa kamu yakin ingin menghapus data rekam medis dari hewan ini?',
                                                  style: inter.copyWith(
                                                      fontSize: 14,
                                                      color: neutral00),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Batal',
                                                          style: inter.copyWith(
                                                              fontWeight: bold,
                                                              color: const Color(
                                                                  0xFfEF4444)),
                                                        )),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            _deleteMedicalRecord(
                                                                recordId:
                                                                    medicalRecord
                                                                        .id
                                                                        .toString());
                                                          },
                                                          child: Text(
                                                            'Ya',
                                                            style: inter.copyWith(
                                                                fontWeight:
                                                                    bold,
                                                                color:
                                                                    primaryGreen1),
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
                              color: neutral07,
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                'assets/ic_trash.png',
                                width: 21,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
          ),
          if (medicalRecordList.isEmpty)
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/img_grafis_data_kosong.png',
                  width: 175,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Belum ada data rekam medis disini',
                  style: plusJakartaSans.copyWith(
                      fontSize: 12, color: const Color(0xFF94959A)),
                ),
              ],
            ),
          const SizedBox(
            height: 90,
          )
        ],
      ),
    );
  }

  _customListDetailRM({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              title,
              style: inter.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                  color: const Color(0xFFA2A3A7)),
            ),
          ),
          Text(
            ' : ',
            style: inter.copyWith(
                fontSize: 12,
                fontWeight: medium,
                color: const Color(0xFFA2A3A7)),
          ),
          Expanded(
            child: Text(
              value,
              style: inter.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                  color: const Color(0xFFA2A3A7)),
            ),
          ),
        ],
      ),
    );
  }

  _customListDetailRM2({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 71,
            child: Text(
              title,
              style: plusJakartaSans.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                  color: const Color(0xFF06152B)),
            ),
          ),
          Text(
            ' : ',
            style: plusJakartaSans.copyWith(
                fontSize: 12,
                fontWeight: medium,
                color: const Color(0xFF06152B)),
          ),
          Expanded(
            child: Text(
              value,
              style: plusJakartaSans.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                  color: const Color(0xFF06152B)),
            ),
          ),
        ],
      ),
    );
  }
}
