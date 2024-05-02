import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void _forgotPassword() async {
    // showAlertDialog(context);
    ApiResponse response = await forgotPassword(email: emailController.text);
    if (response.error == null) {
      isLoading = false;
      // ignore: use_build_context_synchronously
      customDialog(
          'Email reset password terkirim',
          'Periksa Email anda untuk mengatur ulang kata sandi',
          'assets/ic_presensi.png', () {
        Navigator.pop(context);
      }, () async {
        Navigator.pop(context);
        return true;
      }, context);
    } else {
      isLoading = false;
      // ignore: use_build_context_synchronously
      customDialog(
          'Email salah', 'Periksa kembali Email anda', 'assets/ic_presensi.png',
          () {
        Navigator.pop(context);
      }, () async {
        Navigator.pop(context);
        return true;
      }, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    emailController.addListener(() => setState(() {}));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Kata Sandi'),
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
              height: 34,
            ),
            Text(
              'Masukkan Alamat Email',
              style: plusJakartaSans.copyWith(
                  fontWeight: bold, fontSize: 16, color: neutral00),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: emailController,
                style: plusJakartaSans.copyWith(
                    fontWeight: medium, fontSize: 13, color: neutral00),
                decoration: InputDecoration(
                  hintText: 'Masukkan Email',
                  hintStyle: plusJakartaSans.copyWith(
                      fontWeight: medium, fontSize: 13, color: neutral200),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 23,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: emailController.text.trim().isEmpty
                          ? neutral200
                          : primaryBlue1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: emailController.text.trim().isEmpty
                            ? neutral200
                            : primaryBlue1),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomFilledButton(
                title: 'Kirim',
                isActive: emailController.text.trim().isNotEmpty,
                onPressed: () {
                  if (!isLoading) {
                    isLoading = true;
                    _forgotPassword();
                  }
                })
          ],
        ),
      ),
    );
  }
}
