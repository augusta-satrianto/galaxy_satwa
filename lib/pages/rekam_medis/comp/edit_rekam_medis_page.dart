import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/medical_record_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/services/medical_record_service.dart';
import '../../../components/form.dart';

class EditRekamMedis extends StatefulWidget {
  final PetModel pet;
  final MedicalRecordModel medicalRecord;
  const EditRekamMedis(
      {super.key, required this.pet, required this.medicalRecord});

  @override
  State<EditRekamMedis> createState() => _EditRekamMedisState();
}

class _EditRekamMedisState extends State<EditRekamMedis> {
  final gejalaController = TextEditingController();
  final diagnosaController = TextEditingController();
  final tindakanController = TextEditingController();
  final resepController = TextEditingController();

  void _editMedicalRecord() async {
    ApiResponse response = await updateMedicalRecord(
        recordId: widget.medicalRecord.id.toString(),
        symptom: gejalaController.text,
        diagnosis: diagnosaController.text,
        action: tindakanController.text,
        recipe: resepController.text);

    if (response.error == null) {
      // ignore: use_build_context_synchronously
      customDialog('Edit Rekam Medis', 'Data Rekam Medis Berhasil Diubah',
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
  void initState() {
    gejalaController.text = widget.medicalRecord.symptom!;
    diagnosaController.text = widget.medicalRecord.diagnosis!;
    tindakanController.text = widget.medicalRecord.action!;
    resepController.text = widget.medicalRecord.recipe!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gejalaController.addListener(() => setState(() {}));
    diagnosaController.addListener(() => setState(() {}));
    tindakanController.addListener(() => setState(() {}));
    resepController.addListener(() => setState(() {}));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Rekam Medis'),
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
          Container(
            width: 70,
            height: 68,
            margin:
                const EdgeInsets.only(bottom: 4, right: 10, left: 10, top: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  '${widget.pet.image}',
                ),
              ),
            ),
          ),
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
                  _editMedicalRecord();
                }),
          ),
        ]),
      ),
    );
  }
}
