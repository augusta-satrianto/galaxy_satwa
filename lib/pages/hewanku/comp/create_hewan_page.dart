import 'dart:io';

import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/config/methods.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/pages/base/base.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:galaxy_satwa/services/pet_service.dart';
import '../../../components/form.dart';

class CreateHewanPage extends StatefulWidget {
  const CreateHewanPage({
    super.key,
  });

  @override
  State<CreateHewanPage> createState() => _CreateHewanPageState();
}

class _CreateHewanPageState extends State<CreateHewanPage> {
  final nameController = TextEditingController();
  final umurController = TextEditingController();
  final categoryController = TextEditingController();
  final jenisController = TextEditingController();
  final genderController = TextEditingController();
  final warnaController = TextEditingController();
  final tatoController = TextEditingController();
  File? selectedImage;

  void _createdPet() async {
    String? img = getStringImage(selectedImage);

    ApiResponse response = await createPet(
        name: nameController.text,
        old: umurController.text,
        category: categoryController.text,
        type: jenisController.text,
        gender: genderController.text,
        color: warnaController.text,
        tatto: tatoController.text == '' ? '-' : tatoController.text,
        image: img!);

    if (response.error == null) {
      String role = await getRole();
      String name = await getName();
      String image = await getImage();

      // ignore: use_build_context_synchronously
      customDialog(
          'Tambah Hewan', 'Hewan Berhasil Ditambahkan', 'assets/ic_hewanku.png',
          () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BasePage(role: role, name: name, image: image)),
            (route) => false);
      }, () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BasePage(role: role, name: name, image: image)),
            (route) => false);
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
    nameController.addListener(() => setState(() {}));
    umurController.addListener(() => setState(() {}));
    jenisController.addListener(() => setState(() {}));
    genderController.addListener(() => setState(() {}));
    warnaController.addListener(() => setState(() {}));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Hewan'),
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
                          ? Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                            )
                          : Container()),
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
          CustomFormDropdown(
            title: 'Kategori Hewan',
            listItems: const [
              'Kucing',
              'Anjing',
              'Kelinci',
              'Burung',
              'Ular',
              'Hamster'
            ],
            placeholderText: 'Pilih kategori hewan',
            isRequired: true,
            controller: categoryController,
          ),
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
                isActive: selectedImage != null &&
                    nameController.text.trim().isNotEmpty &&
                    umurController.text.trim().isNotEmpty &&
                    categoryController.text.trim().isNotEmpty &&
                    jenisController.text.trim().isNotEmpty &&
                    genderController.text.trim().isNotEmpty &&
                    warnaController.text.trim().isNotEmpty,
                onPressed: () {
                  _createdPet();
                }),
          ),
        ]),
      ),
    );
  }
}
