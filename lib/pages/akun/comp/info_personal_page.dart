import 'dart:io';

import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/config/methods.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';
import 'package:galaxy_satwa/pages/base/base.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/form.dart';

class InfoPersonalPage extends StatefulWidget {
  final UserModel user;
  const InfoPersonalPage({super.key, required this.user});

  @override
  State<InfoPersonalPage> createState() => _InfoPersonalPageState();
}

class _InfoPersonalPageState extends State<InfoPersonalPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  File? selectedImage;
  bool isEdit = false;

  void _updateProfile() async {
    String? img = selectedImage == null ? null : getStringImage(selectedImage);

    ApiResponse response = await updateUser(
        name: nameController.text,
        dateOfBirth: dateOfBirthController.text,
        gender: genderController.text,
        phone: phoneController.text,
        address: addressController.text,
        image: img);
    if (response.error == null) {
      UserModel? userModel;

      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        userModel = response.data as UserModel;
        setState(() {});
      } else {
        // ignore: use_build_context_synchronously
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${response.error}')),
          );
        }
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();

      await preferences.setString('name', nameController.text);
      if (selectedImage != null) {
        await preferences.setString('image', userModel!.image ?? '');
      }
      String role = await getRole();
      String name = await getName();
      String image = await getImage();

      // ignore: use_build_context_synchronously
      customDialog('Edit Info Personal', 'Data info personal berhasil di ubah',
          'assets/user-follow-line.png', () {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BasePage(
                      role: role,
                      name: name,
                      image: image,
                      selectedIndex: role == 'pasien' ? 3 : 4,
                    )),
            (route) => false);
      }, () async {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BasePage(
                      role: role,
                      name: name,
                      image: image,
                      selectedIndex: role == 'pasien' ? 3 : 4,
                    )),
            (route) => false);
        return true;
      }, context);
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
    nameController.text = widget.user.name ?? '';
    emailController.text = widget.user.email ?? '';
    dateOfBirthController.text = widget.user.dateOfBirth ?? '';
    genderController.text = widget.user.gender ?? '';
    phoneController.text = widget.user.phone ?? '';
    addressController.text = widget.user.address ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nameController.addListener(() => setState(() => isEdit = true));
    emailController.addListener(() => setState(() => isEdit = true));
    dateOfBirthController.addListener(() => setState(() => isEdit = true));
    genderController.addListener(() => setState(() => isEdit = true));
    phoneController.addListener(() => setState(() => isEdit = true));
    addressController.addListener(() => setState(() => isEdit = true));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Personal'),
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
                          : Image.network(
                              widget.user.image!,
                              fit: BoxFit.cover,
                            )),
                  selectedImage == null
                      ? Container(
                          width: 100,
                          height: 100,
                          color: const Color(0xFF121214).withOpacity(0.5),
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
              title: 'Nama Lengkap',
              placeholder: 'Tuliskan Nama Lengkap Kamu',
              controller: nameController),
          CustomFormField(
            title: 'E-mail',
            placeholder: 'Tuliskan Email Kamu',
            controller: emailController,
            isEnable: false,
          ),
          CustomBirthDate(
              title: 'Tanggal Lahir',
              placeholder: 'Pilih Tanggal Lahir Kamu',
              tanggalController: dateOfBirthController),
          CustomFormDropdown(
            title: 'Jenis Kelamin',
            listItems: const ['Perempuan', 'Laki-laki'],
            placeholderText: 'Pilih Jenis Kelamin Kamu',
            controller: genderController,
          ),
          CustomFormField(
              title: 'Nomor Telepon',
              placeholder: 'Tuliskan Nomor Telepon Kamu',
              isNumberOnly: true,
              controller: phoneController),
          CustomFormField(
              title: 'Alamat',
              placeholder: 'Tuliskan Alamat  Kamu',
              controller: addressController),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20),
            child: CustomFilledButton(
                title: 'Simpan',
                onPressed: () {
                  _updateProfile();
                }),
          ),
        ]),
      ),
    );
  }
}
