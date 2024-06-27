import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/notification_model.dart';
import 'package:galaxy_satwa/services/notification_service.dart';
import 'package:intl/intl.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  List<dynamic> notificationList = [];
  void _getNotification() async {
    ApiResponse response = await getNotificationByUserLogin();
    if (response.error == null) {
      notificationList = response.data as List<dynamic>;
      if (mounted) {
        setState(() {});
      }

      updateNotification();
    }
  }

  @override
  void initState() {
    _getNotification();
    super.initState();
  }

  String header = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifikasi'),
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
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: notificationList.length,
          itemBuilder: (context, index) {
            NotificationModel notification = notificationList[index];
            String formattedDate = DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(notification.date!));
            String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
            bool lanjutan = false;
            if (header != formattedDate) {
              header = formattedDate;
              lanjutan = true;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                lanjutan
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: 20,
                            bottom: 10,
                            top: formattedDate == today ? 20 : 40),
                        child: Text(
                          formattedDate == today ? 'Hari ini' : header,
                          style: plusJakartaSans.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                  color: notification.isRead == '0'
                      ? const Color(0xFFE5F5F6)
                      : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/ic_stetho.png',
                            width: 24,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            notification.title!,
                            style: plusJakartaSans.copyWith(
                              fontWeight: semiBold,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          formattedDate == today
                              ? Text(
                                  notification.time!.substring(0, 5),
                                  style: plusJakartaSans.copyWith(
                                      fontWeight: semiBold,
                                      fontSize: 10,
                                      color: Color(0xFF94959A)),
                                )
                              : Text(
                                  '$formattedDate  ${notification.time!.substring(0, 5)}',
                                  style: plusJakartaSans.copyWith(
                                      fontWeight: semiBold,
                                      fontSize: 10,
                                      color: Color(0xFF94959A)),
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        notification.description!,
                        style: plusJakartaSans.copyWith(
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
