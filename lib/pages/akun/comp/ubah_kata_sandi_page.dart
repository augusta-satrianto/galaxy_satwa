import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/theme.dart';

class UbahKataSandiPage extends StatefulWidget {
  const UbahKataSandiPage({super.key});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  void _updatePassword() async {
    ApiResponse response = await updatePassword(password: newController.text);
    if (response.error == null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('passwordlogin', newController.text);
      // ignore: use_build_context_synchronously
      customDialog(
          'Berhasil', 'Kata sandi berhasil diubah', 'assets/ic_presensi.png',
          () {
        Navigator.pop(context);
      }, () async {
        Navigator.pop(context);
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

  String? passwordLogin;
  _getPrev() async {
    passwordLogin = await getPasswordLogin();
  }

  @override
  void initState() {
    _getPrev();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    oldController.addListener(() => setState(() {}));
    newController.addListener(() => setState(() {}));
    confirmController.addListener(() => setState(() {}));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Kata Sandi'),
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
              height: 6,
            ),
            CustomFormFieldPass(
                title: 'Kata Sandi Lama',
                placeholder: 'Masukkan Kata Sandi Lama',
                controller: oldController),
            CustomFormFieldPass(
                title: 'Kata Sandi Baru',
                placeholder: 'Masukkan Kata Sandi Baru',
                controller: newController),
            CustomFormFieldPass(
                title: 'Konfirmasi Kata Sandi Baru',
                placeholder: 'Masukkan Ulang Kata Sandi Baru',
                controller: confirmController),
            const SizedBox(
              height: 35,
            ),
            CustomFilledButton(
                title: 'Simpan',
                isActive: oldController.text.trim().isNotEmpty &&
                    newController.text.trim().isNotEmpty &&
                    confirmController.text.trim().isNotEmpty,
                onPressed: () {
                  if (oldController.text != passwordLogin) {
                    customDialog(
                        'Kata sandi lama salah',
                        'Periksa kembali kata sandi lama anda',
                        'assets/ic_presensi.png', () {
                      Navigator.pop(context);
                    }, () async {
                      Navigator.pop(context);
                      return true;
                    }, context);
                  } else if (newController.text != confirmController.text) {
                    customDialog(
                        'Konfirmasi kata sandi tidak sesuai',
                        'Kata sandi lama dan konfirmasi kata sandi harus sama',
                        'assets/ic_presensi.png', () {
                      Navigator.pop(context);
                    }, () async {
                      Navigator.pop(context);
                      return true;
                    }, context);
                  } else if (newController.text.trim().length < 8) {
                    customDialog(
                        'Kata sandi baru lemah',
                        'Kata sandi baru berisi setidaknya 8 karakter',
                        'assets/ic_presensi.png', () {
                      Navigator.pop(context);
                    }, () async {
                      Navigator.pop(context);
                      return true;
                    }, context);
                  } else {
                    _updatePassword();
                  }
                })
          ],
        ),
      ),
    );
  }
}

class CustomFormFieldPass extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextEditingController controller;
  final bool isEnable;
  const CustomFormFieldPass(
      {super.key,
      required this.title,
      required this.placeholder,
      required this.controller,
      this.isEnable = true});

  @override
  State<CustomFormFieldPass> createState() => _CustomFormFieldPassState();
}

class _CustomFormFieldPassState extends State<CustomFormFieldPass> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    widget.controller.addListener(() {
      setState(() {});
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          widget.title,
          style: plusJakartaSans.copyWith(
              fontWeight: semiBold, fontSize: 12, color: neutral00),
        ),
        const SizedBox(
          height: 1,
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(
                color: widget.controller.text.trim().isEmpty
                    ? neutral200
                    : primaryBlue1,
              ),
              borderRadius: BorderRadius.circular(4.25)),
          child: TextFormField(
            enabled: widget.isEnable,
            obscureText: isObscure,
            controller: widget.controller,
            style: plusJakartaSans.copyWith(
                fontWeight: medium, fontSize: 13, color: neutral00),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: plusJakartaSans.copyWith(
                  fontWeight: medium, fontSize: 13, color: neutral200),
              border: InputBorder.none,
              suffixIcon: IconButton(
                  icon: Image.asset(
                    isObscure ? 'assets/ic_hide.png' : 'assets/ic_show.png',
                    color: widget.controller.text.trim().isEmpty
                        ? neutral200
                        : primaryBlue1,
                    width: isObscure ? 12 : 16,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
