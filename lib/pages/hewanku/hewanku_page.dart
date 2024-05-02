import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/pages/hewanku/comp/create_hewan_page.dart';
import 'package:galaxy_satwa/pages/hewanku/comp/detail_hewan_page.dart';
import 'package:galaxy_satwa/services/pet_service.dart';

class HewankuPage extends StatefulWidget {
  const HewankuPage({super.key});

  @override
  State<HewankuPage> createState() => _HewankuPageState();
}

class _HewankuPageState extends State<HewankuPage> {
  List<dynamic> petList = [];
  void _getPet() async {
    ApiResponse response = await getPetByUserLogin();
    if (response.error == null) {
      petList = response.data as List<dynamic>;
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
    _getPet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        Stack(
          children: [
            Container(
              height: 245,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: const Color(0xFFB1D7FF),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Image.asset(
                            'assets/img_grafis_hewanku.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                    height: 100,
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height -
                  227 -
                  MediaQuery.of(context).padding.top,
              margin: const EdgeInsets.only(top: 227),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  color: neutral07,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateHewanPage()));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 9),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF0DE1F8),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/img_jejak.png',
                            width: 39,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tambahkan Hewanmu',
                                style: inter.copyWith(
                                    fontWeight: medium, color: neutral00),
                              ),
                              Text(
                                'Kamu belum menambahkan hewanmu',
                                style: inter.copyWith(
                                    fontSize: 10, color: neutral200),
                              )
                            ],
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/ic_plus_rec.png',
                            width: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 14,
                        );
                      },
                      itemCount: petList.length,
                      itemBuilder: (context, index) {
                        PetModel pet = petList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailHewankuPage(
                                          pet: pet,
                                        ))).then((receivedData) {
                              if (receivedData == 'retrive') {
                                _getPet();
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF000000).withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 57,
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        '${pet.image}',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pet.name!,
                                      style: inter.copyWith(
                                          fontWeight: semiBold,
                                          color: neutral00),
                                    ),
                                    Text(
                                      'Umur ${pet.old}',
                                      style: inter.copyWith(
                                          fontSize: 12,
                                          fontWeight: semiBold,
                                          color: const Color(0xFF94959A)),
                                    ),
                                    Text(
                                      pet.type!,
                                      style: inter.copyWith(
                                          fontSize: 12,
                                          fontWeight: semiBold,
                                          color: const Color(0xFF94959A)),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/ic_arrow_right.png',
                                  width: 24,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}
