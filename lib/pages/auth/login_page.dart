import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/auth_model.dart';
import 'package:galaxy_satwa/pages/auth/register_page.dart';
import 'package:galaxy_satwa/pages/base/base.dart';
import 'package:galaxy_satwa/pages/forgot_password/forgot_password_page.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../components/buttons.dart';
import '../../config/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  void _loginUser() async {
    isLoading = true;
    ApiResponse response = await login(
        email: emailController.text,
        password: passwordController.text,
        device: device);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as AuthModel);
    } else {
      isLoading = false;
      // ignore: use_build_context_synchronously
      customDialog(
          'Email atau password salah',
          'Periksa kembali Email dan Password anda',
          'assets/ic_presensi.png', () {
        Navigator.pop(context);
      }, () async {
        Navigator.pop(context);
        return true;
      }, context);
    }
  }

  void _saveAndRedirectToHome(AuthModel userModel) async {
    if (userModel.emailVerifiedAt == null) {
      isLoading = false;
      // ignore: use_build_context_synchronously
      customDialog(
          'Email belum terverifikasi',
          'Lakukan verifikasi email terlebih dahulu||${userModel.token}',
          'assets/ic_presensi.png', () {
        Navigator.pop(context);
      }, () async {
        Navigator.pop(context);
        return true;
      }, context);
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      await preferences.setString('image', userModel.image);
      await preferences.setString('name', userModel.name);
      await preferences.setString('token', userModel.token);
      await preferences.setString('role', userModel.role);
      await preferences.setString('passwordlogin', passwordController.text);

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BasePage(
                    role: userModel.role,
                    name: userModel.name,
                    image: userModel.image,
                  )),
          (route) => false);
    }
  }

  String device = '';
  @override
  void initState() {
    super.initState();
    OneSignal.shared.getDeviceState().then((deviceState) {
      device = deviceState?.userId ?? 'Not Available';
    });
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight - MediaQuery.of(context).padding.top;
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
                    'Masuk',
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()));
                        },
                        child: Text('Lupa kata sandi?',
                            style: plusJakartaSans.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                                color: neutral00,
                                decoration: TextDecoration.underline)),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFilledButton(
                  title: 'Masuk',
                  onPressed: () {
                    if (emailController.text.trim().isNotEmpty &&
                        passwordController.text.trim().isNotEmpty &&
                        !isLoading) {
                      _loginUser();
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
                  isActive: emailController.text.trim().isNotEmpty &&
                      passwordController.text.trim().isNotEmpty,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum memiliki akun?',
                        style: plusJakartaSans.copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                            color: neutral02)),
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                              (route) => false);
                        },
                        child: Text('Daftar',
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
