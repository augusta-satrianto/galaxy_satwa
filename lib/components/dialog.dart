import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/services/auth_service.dart';

void customDialog(
  String title,
  String subtitle,
  String urlIcon,
  VoidCallback onPressed,
  Future<bool> Function() onWillPop,
  BuildContext context,
) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: onWillPop,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: const EdgeInsets.all(0),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: neutral07,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        urlIcon,
                        width: 24,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: inter.copyWith(
                            fontWeight: bold,
                            fontSize: 16,
                            color: const Color(0xFF1C1B1F)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        subtitle.split('||')[0],
                        style: inter.copyWith(fontSize: 14, color: neutral00),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          title == 'Email belum terverifikasi'
                              ? TextButton(
                                  onPressed: () {
                                    sendEmail(token: subtitle.split('||')[1]);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Kirim Email',
                                    style: inter.copyWith(
                                        fontWeight: bold, color: primaryGreen1),
                                  ))
                              : Container(),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: onPressed,
                                child: Text(
                                  'Tutup',
                                  style: inter.copyWith(
                                      fontWeight: bold, color: primaryGreen1),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
