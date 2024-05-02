import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';
import 'package:galaxy_satwa/services/pet_service.dart';

class DetailPemilikHewanPage extends StatefulWidget {
  final UserModel user;
  const DetailPemilikHewanPage({super.key, required this.user});

  @override
  State<DetailPemilikHewanPage> createState() => _DetailPemilikHewanPageState();
}

class _DetailPemilikHewanPageState extends State<DetailPemilikHewanPage> {
  List<dynamic> petList = [];
  void _getPet() async {
    ApiResponse response =
        await getPetByUserId(userId: widget.user.id.toString());
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
      appBar: AppBar(
        title: const Text('Detail Data Hewan'),
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(
            height: 12,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 83,
              height: 80,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${widget.user.image}',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _customListDetail(title: 'Nama', value: widget.user.name!),
          _customListDetail(title: 'Jenis Kelamin', value: widget.user.gender!),
          _customListDetail(title: 'Alamat', value: widget.user.address!),
          _customListDetail(title: 'Email', value: widget.user.email!),
          const SizedBox(
            height: 30,
          ),
          Column(
            children: List.generate(petList.length, (index) {
              PetModel pet = petList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hewan ${index + 1}',
                    style: plusJakartaSans.copyWith(
                        fontWeight: semiBold, color: neutral00),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  _customListDetail(title: 'Nama', value: pet.name!),
                  _customListDetail(title: 'Umur', value: pet.old!),
                  _customListDetail(
                      title: 'Kategori Hewan', value: pet.category!),
                  _customListDetail(title: 'Jenis Hewan', value: pet.type!),
                  _customListDetail(title: 'Jenis Kelamin', value: pet.gender!),
                  _customListDetail(title: 'Warna', value: pet.color!),
                  _customListDetail(title: 'Tato', value: pet.tatto!),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomFilledButton(
              title: 'Unduh data pemilik hewan', onPressed: () {}),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  _customListDetail({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              title,
              style: itemDetailDataHewan,
            ),
          ),
          Text(
            ' : ',
            style: itemDetailDataHewan,
          ),
          Expanded(
            child: Text(
              value,
              style: itemDetailDataHewan,
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle itemDetailDataHewan =
    inter.copyWith(fontSize: 12, fontWeight: medium, color: neutral00);
