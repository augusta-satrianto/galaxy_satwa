import 'package:flutter/material.dart';
import 'package:galaxy_satwa/pages/auth/login_page.dart';
import 'package:galaxy_satwa/pages/base/base.dart';
import 'package:galaxy_satwa/services/auth_service.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  void _checkToken() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    String token = await getToken();
    if (token == '') {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    } else {
      String role = await getRole();
      String name = await getName();
      String image = await getImage();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BasePage(
                    role: role,
                    name: name,
                    image: image,
                  )),
          (route) => false);
    }
  }

  @override
  void initState() {
    _checkToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img_bg_splash.png'),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Image.asset('assets/img_logo_white.png'),
          )),
    );
  }
}
