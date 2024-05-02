import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/medicine_model.dart';
import 'package:galaxy_satwa/services/medicine_service.dart';
import 'package:intl/intl.dart';

class DataObatPage extends StatefulWidget {
  const DataObatPage({super.key});

  @override
  State<DataObatPage> createState() => _DataObatPageState();
}

class _DataObatPageState extends State<DataObatPage> {
  List<dynamic> medicineList = [];
  void _getMedicine() async {
    ApiResponse response = await getMedicineAll();
    if (response.error == null) {
      medicineList = response.data as List<dynamic>;
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
    _getMedicine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Obat'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: primaryGreen1,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Unduh Data Obat',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold, color: neutral100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  Container(
                    // color: Colors.amber,
                    width: 55,
                    child: Center(
                      child: Text(
                        'ID Obat',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold,
                            fontSize: 10,
                            color: const Color(0xFF06152B)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Nama Obat',
                          style: plusJakartaSans.copyWith(
                              fontWeight: semiBold,
                              fontSize: 10,
                              color: const Color(0xFF06152B)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    width: 100,
                    child: Center(
                      child: Text(
                        'Tgl. Kadaluarsa',
                        style: plusJakartaSans.copyWith(
                            fontWeight: semiBold,
                            fontSize: 10,
                            color: const Color(0xFF06152B)),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.green,
                    width: 35,
                    child: Center(
                      child: Text(
                        'Stok',
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
              children: List.generate(medicineList.length, (index) {
                MedicineModel medicine = medicineList[index];
                String formattedDate = DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(medicine.expiryDate.toString()));
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
                      Container(
                        width: 55,
                        // color: Colors.amber,
                        child: Center(
                          child: Text(
                            medicine.code!,
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: neutral00),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.blue,
                          child: Center(
                            child: Text(
                              medicine.name!,
                              style: plusJakartaSans.copyWith(
                                  fontSize: 10, color: neutral00),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        // color: Colors.red,
                        child: Center(
                          child: Text(
                            formattedDate,
                            style: plusJakartaSans.copyWith(
                                fontSize: 10, color: neutral00),
                          ),
                        ),
                      ),
                      Container(
                        width: 35,
                        // color: Colors.green,
                        child: Center(
                          child: Text(
                            medicine.stock.toString(),
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
