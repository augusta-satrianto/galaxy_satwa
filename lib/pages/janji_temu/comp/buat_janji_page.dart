import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/components/form.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';
import 'package:galaxy_satwa/services/appointment_service.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:galaxy_satwa/services/pet_service.dart';
import 'package:intl/intl.dart';

class BuatJanjiPage extends StatefulWidget {
  const BuatJanjiPage({super.key});

  @override
  State<BuatJanjiPage> createState() => _BuatJanjiPageState();
}

class _BuatJanjiPageState extends State<BuatJanjiPage> {
  final dokterController = TextEditingController();
  final tanggalController = TextEditingController();
  int jamSelected = -1;
  List jamList = ['09.00', '12.00', '15.00', '18.00', '19.00', '20.00'];
  final hewanController = TextEditingController();

  List<dynamic> petList = [];
  List<String> petIdList = [];
  List<String> petNameList = [];
  List<String> petImageList = [];
  void _getPet() async {
    ApiResponse response = await getPetByUserLogin();
    if (response.error == null) {
      petList = response.data as List<dynamic>;
      for (int i = 0; i < petList.length; i++) {
        PetModel pet = petList[i];
        petIdList.add(pet.id.toString());
        petNameList.add(pet.name!);
        petImageList.add(pet.image!);
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

  List<dynamic> userList = [];
  List<String> userIdList = [];
  List<String> userNameList = [];
  List<String> userImageList = [];
  void _getuser() async {
    ApiResponse response = await getAllDokter();
    if (response.error == null) {
      userList = response.data as List<dynamic>;
      for (int i = 0; i < userList.length; i++) {
        UserModel user = userList[i];
        userIdList.add(user.id.toString());
        userNameList.add(user.name!);
        userImageList.add(user.image!);
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

  void _createdJanji() async {
    DateTime tanggal =
        DateFormat('EEEE, dd MMMM yyyy').parse(tanggalController.text);
    String tanggalFormatted = DateFormat('yyyy-MM-dd').format(tanggal);
    ApiResponse response = await createAppointment(
        doctorId: dokterController.text.split('||')[0],
        petId: hewanController.text.split('||')[0],
        date: tanggalFormatted,
        time: jamList[jamSelected]);

    if (response.error == null) {
      isLoading = false;
      // ignore: use_build_context_synchronously
      customDialog('Buat Janji Temu', 'Jadwal janji temu berhasil dibuat',
          'assets/ic_kalender_check.png', () {
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
      }, () async {
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
        return true;
      }, context);
    } else {
      isLoading = false;
      // ignore: use_build_context_synchronously
      customDialog('Terjadi Kesalahan', 'Silahkan coba buat kembali',
          'assets/ic_presensi.png', () {
        Navigator.pop(context);
      }, () async {
        Navigator.pop(context);
        return true;
      }, context);
    }
  }

  List<String> timeList = [];
  bool hasData = true;
  bool loadingSchedule = false;
  void _getAppointmentDoctorDate() async {
    DateTime tanggal =
        DateFormat('EEEE, dd MMMM yyyy').parse(tanggalController.text);
    String tanggalFormatted = DateFormat('yyyy-MM-dd').format(tanggal);
    timeList = await getAppointmentByDoctorDate(
        doctorId: dokterController.text.split('||')[0], date: tanggalFormatted);
    if (!timeList.contains('error')) {
      jamList.removeWhere((jam) => timeList.contains(jam));
      loadingSchedule = false;

      setState(() {});
    } else {
      loadingSchedule = false;
      // ignore: use_build_context_synchronously
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error')),
        );
      }
    }
  }

  @override
  void initState() {
    _getPet();
    _getuser();
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    dokterController.addListener(() {
      jamSelected = -1;
      if (dokterController.text.isNotEmpty &&
          tanggalController.text.isNotEmpty &&
          !loadingSchedule) {
        loadingSchedule = true;
        _getAppointmentDoctorDate();
      } else {
        setState(() {});
      }
    });
    hewanController.addListener(() => setState(() {}));
    tanggalController.addListener(() {
      jamSelected = -1;
      if (dokterController.text.isNotEmpty &&
          tanggalController.text.isNotEmpty &&
          !loadingSchedule) {
        loadingSchedule = true;
        _getAppointmentDoctorDate();
      } else {
        setState(() {});
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Janji Temu'),
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
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomFormDropdown2(
              urlImage: 'assets/ic_user_star.png',
              listId: userIdList,
              listItems: userNameList,
              listImage: userImageList,
              placeholderText: 'Pilih dokter',
              controller: dokterController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomFormDateSimple(
                placeholder: 'Pilih tanggal janji temu',
                tanggalController: tanggalController),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Image.asset(
                  'assets/ic_time.png',
                  width: 24,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text('Pilih jam yang tersedia',
                    style: plusJakartaSans.copyWith(
                        fontWeight: medium, fontSize: 12, color: neutral00))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              children: List.generate(
                jamList.length,
                (index) => GestureDetector(
                  onTap: () {
                    if (dokterController.text.isNotEmpty &&
                        tanggalController.text.isNotEmpty) {
                      setState(() {
                        jamSelected = index;
                      });
                    } else {
                      // ignore: use_build_context_synchronously
                      customDialog(
                          'Pilih Dokter dan Tanggal',
                          'Plih dokter dan tanggal terlebih dahulu',
                          'assets/ic_presensi.png', () {
                        Navigator.pop(context);
                      }, () async {
                        Navigator.pop(context);
                        return true;
                      }, context);
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                    width: 72,
                    height: 25,
                    decoration: BoxDecoration(
                        color: index == jamSelected
                            ? const Color(0xFFB0DA43)
                            : const Color(0xFFEDF1F7),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        jamList[index],
                        style: plusJakartaSans.copyWith(
                            fontWeight:
                                index == jamSelected ? semiBold : regular,
                            fontSize: 12,
                            color: index == jamSelected
                                ? neutral07
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomFormDropdown2(
              urlImage: 'assets/ic_hewanku.png',
              listId: petIdList,
              listImage: petImageList,
              listItems: petNameList,
              placeholderText: 'Pilih hewan kamu',
              controller: hewanController,
            ),
            const Spacer(),
            CustomFilledButton(
                title: 'Buat Janji Temu',
                isActive: dokterController.text.isNotEmpty &&
                    tanggalController.text.isNotEmpty &&
                    jamSelected != -1 &&
                    hewanController.text.isNotEmpty,
                onPressed: () {
                  if (dokterController.text.isNotEmpty &&
                      tanggalController.text.isNotEmpty &&
                      jamSelected != -1 &&
                      hewanController.text.isNotEmpty &&
                      !isLoading) {
                    isLoading = true;
                    _createdJanji();
                  } else {
                    customDialog(
                        'Lengkapi Form',
                        'Pastikan semua form telah terisi',
                        'assets/ic_presensi.png', () {
                      Navigator.pop(context);
                    }, () async {
                      Navigator.pop(context);
                      return true;
                    }, context);
                  }
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
