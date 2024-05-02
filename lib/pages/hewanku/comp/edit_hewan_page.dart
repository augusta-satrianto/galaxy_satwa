import 'dart:io';

import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/config/methods.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:galaxy_satwa/services/pet_service.dart';
import '../../../components/form.dart';

class EditHewanPage extends StatefulWidget {
  final PetModel pet;
  const EditHewanPage({super.key, required this.pet});

  @override
  State<EditHewanPage> createState() => _EditHewanPageState();
}

class _EditHewanPageState extends State<EditHewanPage> {
  final nameController = TextEditingController();
  final umurController = TextEditingController();
  final jenisController = TextEditingController();
  final genderController = TextEditingController();
  final warnaController = TextEditingController();
  final tatoController = TextEditingController();
  File? selectedImage;

  void _updatePet() async {
    String? img = selectedImage == null ? null : getStringImage(selectedImage);

    ApiResponse response = await updatePet(
        idPet: widget.pet.id!,
        name: nameController.text,
        old: umurController.text,
        type: jenisController.text,
        gender: genderController.text,
        color: warnaController.text,
        tatto: tatoController.text,
        image: img);

    if (response.error == null) {
      // ignore: use_build_context_synchronously
      customDialog('Edit Data Hewan', 'Data hewan berhasil di ubah',
          'assets/ic_hewanku.png', () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
      }, () async {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
        return true;
      }, context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    nameController.text = widget.pet.name!;
    genderController.text = widget.pet.gender!;
    jenisController.text = widget.pet.type!;
    umurController.text = widget.pet.old!;
    warnaController.text = widget.pet.color!;
    tatoController.text = widget.pet.tatto!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Hewan'),
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
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async {
                final image = await selectImageGalery();

                setState(() {
                  selectedImage = image;
                });
              },
              child: ClipOval(
                  child: Stack(
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: selectedImage != null
                          ? Image.file(File(selectedImage!.path))
                          : Image.network(widget.pet.image!)),
                  selectedImage == null
                      ? Container(
                          width: 100,
                          height: 100,
                          color: const Color(0xFF94959A).withOpacity(0.5),
                          child: Center(
                            child: Image.asset(
                              'assets/ic_edit.png',
                              width: 24,
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 100,
                          height: 100,
                        )
                ],
              )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomFormField(
              title: 'Nama',
              placeholder: 'Masukkan nama hewan',
              isRequired: true,
              controller: nameController),
          CustomFormField(
              title: 'Umur',
              placeholder: 'Masukkan umur hewan',
              isRequired: true,
              controller: umurController),
          CustomFormField(
              title: 'Jenis Hewan',
              placeholder: 'Masukkan jenis hewan',
              isRequired: true,
              controller: jenisController),
          CustomFormDropdown(
            title: 'Jenis Kelamin',
            listItems: const ['Jantan', 'Betina'],
            placeholderText: 'Pilih jenis kelamin hewan',
            isRequired: true,
            controller: genderController,
          ),
          CustomFormField(
              title: 'Warna',
              placeholder: 'Masukkan warna hewan',
              isRequired: true,
              controller: warnaController),
          CustomFormField(
              title: 'Tato',
              placeholder: 'Masukkan nomor tato hewan',
              controller: tatoController),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20),
            child: CustomFilledButton(
                title: 'Simpan',
                onPressed: () {
                  _updatePet();
                }),
          ),
        ]),
      ),
    );
  }
}
