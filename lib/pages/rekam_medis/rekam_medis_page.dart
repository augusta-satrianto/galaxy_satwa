import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/search.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/pages/rekam_medis/comp/detail_rekam_medis_page.dart';
import 'package:galaxy_satwa/services/pet_service.dart';

class RekamMedisPage extends StatefulWidget {
  const RekamMedisPage({super.key});

  @override
  State<RekamMedisPage> createState() => _RekamMedisPageState();
}

class _RekamMedisPageState extends State<RekamMedisPage> {
  final seacrhController = TextEditingController();

  List<dynamic> petList = [];
  void _getPet() async {
    ApiResponse response = await getAllPet();
    if (response.error == null) {
      petList = response.data as List<dynamic>;
      if (mounted) {
        setState(() {});
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
    seacrhController.addListener(() {
      setState(() {});
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Hewan'),
        titleSpacing: 24,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomSearch(
                placeholder: 'Cari pemilik hewan',
                seacrhController: seacrhController),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
                itemCount: petList.length,
                itemBuilder: (context, index) {
                  PetModel pet = petList[index];
                  if (seacrhController.text.isEmpty ||
                      (seacrhController.text.isNotEmpty &&
                          pet.user!.name!
                              .toLowerCase()
                              .contains(seacrhController.text.toLowerCase()))) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailRekamMedisPage(
                                      pet: pet,
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.25),
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
                                      fontWeight: semiBold, color: neutral00),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Umur ${pet.old}',
                                  style: inter.copyWith(
                                      fontSize: 12,
                                      fontWeight: semiBold,
                                      color: const Color(0xFF94959A)),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Pemilik: ${pet.user!.name}',
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
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
