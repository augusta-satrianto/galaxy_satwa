import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';
import 'package:galaxy_satwa/services/auth_service.dart';

class DataMasterPage extends StatefulWidget {
  const DataMasterPage({super.key});

  @override
  State<DataMasterPage> createState() => _DataMasterPageState();
}

class _DataMasterPageState extends State<DataMasterPage> {
  List<dynamic> userList = [];
  void _getuser() async {
    ApiResponse response = await getUserAll();
    if (response.error == null) {
      userList = response.data as List<dynamic>;
      setState(() {});
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
    _getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Master'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: neutral07,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF055EA8).withOpacity(0.12),
                      offset: const Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ]),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      // color: Colors.amber,
                      child: Center(
                        child: Text(
                          'Nama',
                          style: plusJakartaSans.copyWith(
                              fontWeight: semiBold,
                              fontSize: 10,
                              color: const Color(0xFF06152B)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.blue,
                    width: 60,
                    child: Center(
                      child: Text(
                        'Jabatan',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold,
                            fontSize: 10,
                            color: const Color(0xFF06152B)),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    width: 90,
                    child: Center(
                      child: Text(
                        'Email',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold,
                            fontSize: 10,
                            color: const Color(0xFF06152B)),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.green,
                    width: 75,
                    child: Center(
                      child: Text(
                        'Phone',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold,
                            fontSize: 10,
                            color: const Color(0xFF06152B)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: List.generate(userList.length, (index) {
                UserModel user = userList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.12),
                      boxShadow: index % 2 != 0
                          ? [
                              BoxShadow(
                                color: const Color(0xFFF1F4FA).withOpacity(0.8),
                                offset: const Offset(0, 0),
                                blurRadius: 2,
                                spreadRadius: 2,
                              ),
                            ]
                          : []),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          // color: Colors.amber,
                          child: Center(
                            child: Text(
                              user.name!,
                              textAlign: TextAlign.center,
                              style: plusJakartaSans.copyWith(
                                  fontSize: 10, color: neutral00),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.blue,
                        width: 60,
                        child: Center(
                          child: Text(
                            user.role!,
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: neutral00),
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        width: 90,
                        child: Center(
                          child: Text(
                            user.email!,
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: neutral00),
                          ),
                        ),
                      ),
                      Container(
                        width: 75,
                        child: Center(
                          child: Text(
                            user.phone!,
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: neutral00),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
