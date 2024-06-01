import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/services/medical_record_service.dart';
import '../../../components/form.dart';

class BuatRekamMedis extends StatefulWidget {
  final PetModel pet;
  const BuatRekamMedis({super.key, required this.pet});

  @override
  State<BuatRekamMedis> createState() => _BuatRekamMedisState();
}

class _BuatRekamMedisState extends State<BuatRekamMedis> {
  final gejalaController = TextEditingController();
  final diagnosaController = TextEditingController();
  final tindakanController = TextEditingController();
  final resepController = TextEditingController();

  void _createdMedicalRecord() async {
    ApiResponse response = await createMedicalRecord(
        petId: widget.pet.id.toString(),
        symptom: gejalaController.text,
        diagnosis: diagnosaController.text,
        action: tindakanController.text,
        recipe: resepController.text);

    if (response.error == null) {
      // ignore: use_build_context_synchronously
      customDialog('Tambah Rekam Medis', 'Rekam Medis Berhasil Ditambahkan',
          'assets/ic_hewanku.png', () {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    gejalaController.addListener(() => setState(() {}));
    diagnosaController.addListener(() => setState(() {}));
    tindakanController.addListener(() => setState(() {}));
    resepController.addListener(() => setState(() {}));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Rekam Medis'),
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
        child: ListView(physics: const BouncingScrollPhysics(), children: [
          const SizedBox(
            height: 20,
          ),
          CustomFormField(
              title: 'Gejala Klinis',
              placeholder: 'Masukkan gejala klinis hewan',
              controller: gejalaController),
          CustomFormField(
              title: 'Diagnosa',
              placeholder: 'Masukkan diagnosa hewan',
              controller: diagnosaController),
          CustomFormField(
              title: 'Tindakan',
              placeholder: 'Masukkan tindakan hewan',
              controller: tindakanController),
          CustomFormField(
              title: 'Resep',
              placeholder: 'Masukkan resep hewan',
              controller: resepController),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20),
            child: CustomFilledButton(
                title: 'Simpan',
                isActive: gejalaController.text.trim().isNotEmpty &&
                    diagnosaController.text.trim().isNotEmpty &&
                    tindakanController.text.trim().isNotEmpty &&
                    resepController.text.trim().isNotEmpty,
                onPressed: () {
                  _createdMedicalRecord();
                }),
          ),
        ]),
      ),
    );
  }
}
