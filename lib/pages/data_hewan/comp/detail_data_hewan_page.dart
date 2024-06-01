import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/pet_model.dart';

class DetailDataHewanPage extends StatelessWidget {
  final PetModel pet;
  const DetailDataHewanPage({super.key, required this.pet});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      '${pet.image}',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _customListDetail(title: 'Nama', value: pet.name!),
            _customListDetail(title: 'Umur', value: pet.old!),
            _customListDetail(title: 'Kategori Hewan', value: pet.category!),
            _customListDetail(title: 'Jenis Hewan', value: pet.type!),
            _customListDetail(title: 'Jenis Kelamin', value: pet.gender!),
            _customListDetail(title: 'Warna', value: pet.color!),
            _customListDetail(title: 'Tato', value: pet.tatto!),
            _customListDetail(title: 'Nama Pemilik', value: pet.user!.name!),
            _customListDetail(
                title: 'No.tlpn pemilik',
                value: pet.user!.phone != null ? pet.user!.phone! : '-'),
            _customListDetail(
                title: 'Alamat',
                value: pet.user!.address != null ? pet.user!.address! : '-'),
            // const Spacer(),
            // CustomFilledButton(title: 'Unduh Data Hewan', onPressed: () {}),
            // const SizedBox(
            //   height: 50,
            // )
          ],
        ),
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
