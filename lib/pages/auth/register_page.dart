import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/pages/auth/login_page.dart';
import 'package:galaxy_satwa/services/auth_service.dart';

import '../../components/buttons.dart';
import '../../config/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = true;

  void _registerUser() async {
    ApiResponse response = await register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    if (response.error == null) {
      nameController.text = '';
      emailController.text = '';
      passwordController.text = '';
      // ignore: use_build_context_synchronously
      customDialog(
          'Berhasil membuat akun',
          'Silahkan cek email untuk verifikasi email',
          'assets/ic_presensi.png', () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      }, () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
        return true;
      }, context);
    } else {
      String title = '';
      String subTitle = '';
      if (response.error!.contains('valid email')) {
        title = 'Email Tidak Valid';
        subTitle = 'Email Harus Berupa Alamat Email Yang Valid';
      } else if (response.error!.contains('email has')) {
        title = 'Email Telah Digunakan';
        subTitle = 'Email ini telah terdaftar';
      } else {
        title = 'Password Tidak Valid';
        subTitle = 'Password harus berisi setidaknya 8 karakter';
      }
      // ignore: use_build_context_synchronously
      customDialog(title, subTitle, 'assets/ic_presensi.png', () {
        Navigator.pop(context);
      }, () async {
        Navigator.pop(context);
        return true;
      }, context);
      isLoading = false;
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight - MediaQuery.of(context).padding.top;
    nameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: neutral07,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: bodyHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                  child: Image.asset('assets/img_logo_color.png'),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daftar',
                    style: plusJakartaSans.copyWith(
                        color: primaryBlue1,
                        fontSize: 24,
                        fontWeight: semiBold),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: nameController.text.trim().isEmpty
                            ? neutral200
                            : primaryBlue1,
                      ),
                      borderRadius: BorderRadius.circular(4.25)),
                  child: TextFormField(
                    controller: nameController,
                    style: plusJakartaSans.copyWith(
                        fontWeight: medium, fontSize: 13, color: neutral00),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama Lengkap Kamu',
                      hintStyle: plusJakartaSans.copyWith(
                          fontWeight: medium, fontSize: 13, color: neutral200),
                      prefixIcon: const Icon(
                        Icons.person_2_outlined,
                        size: 18,
                      ),
                      prefixIconColor: nameController.text.trim().isEmpty
                          ? neutral200
                          : primaryBlue1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: emailController.text.trim().isEmpty
                            ? neutral200
                            : primaryBlue1,
                      ),
                      borderRadius: BorderRadius.circular(4.25)),
                  child: TextFormField(
                    controller: emailController,
                    style: plusJakartaSans.copyWith(
                        fontWeight: medium, fontSize: 13, color: neutral00),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Email',
                      hintStyle: plusJakartaSans.copyWith(
                          fontWeight: medium, fontSize: 13, color: neutral200),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        size: 18,
                      ),
                      prefixIconColor: emailController.text.trim().isEmpty
                          ? neutral200
                          : primaryBlue1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: passwordController.text.trim().isEmpty
                            ? neutral200
                            : primaryBlue1,
                      ),
                      borderRadius: BorderRadius.circular(4.25)),
                  child: TextFormField(
                    controller: passwordController,
                    style: plusJakartaSans.copyWith(
                        fontWeight: medium, fontSize: 13, color: neutral00),
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      hintText: 'Kata Sandi',
                      hintStyle: plusJakartaSans.copyWith(
                          fontWeight: medium, fontSize: 13, color: neutral200),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        size: 18,
                      ),
                      prefixIconColor: passwordController.text.trim().isEmpty
                          ? neutral200
                          : primaryBlue1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      suffixIcon: IconButton(
                          icon: Image.asset(
                            isObscure
                                ? 'assets/ic_hide.png'
                                : 'assets/ic_show.png',
                            color: passwordController.text.trim().isEmpty
                                ? neutral200
                                : primaryBlue1,
                            width: isObscure ? 12 : 16,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          }),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomFilledButton(
                  title: 'Daftar',
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty &&
                        emailController.text.trim().isNotEmpty &&
                        passwordController.text.trim().isNotEmpty &&
                        !isLoading) {
                      isLoading = true;
                      _registerUser();
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
                  },
                  height: 45,
                  isActive: nameController.text.trim().isNotEmpty &&
                      emailController.text.trim().isNotEmpty &&
                      passwordController.text.trim().isNotEmpty,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah memiliki akun?',
                        style: plusJakartaSans.copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                            color: neutral02)),
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false);
                        },
                        child: Text('Masuk',
                            style: plusJakartaSans.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                                color: primaryBlue1)))
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Expanded(child: Image.asset('assets/img_cat_dog.png'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
