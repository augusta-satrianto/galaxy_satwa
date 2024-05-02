import 'package:flutter/material.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/components/form.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/services/correspondence_service.dart';

class BalasSuratPage extends StatefulWidget {
  final String id;
  const BalasSuratPage({super.key, required this.id});

  @override
  State<BalasSuratPage> createState() => _BalasSuratPageState();
}

class _BalasSuratPageState extends State<BalasSuratPage> {
  final judulController = TextEditingController();
  final suratController = TextEditingController();
  final pathController = TextEditingController();

  void _updateCorrespondence() async {
    ApiResponse response = await updateCorrespondence(
        id: widget.id, replyFile: pathController.text);

    if (response.error == null) {
      // ignore: use_build_context_synchronously
      customDialog('Balas Surat', 'Surat Balasan Berhasil Dikirim',
          'assets/ic_presensi.png', () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
      }, () async {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context, 'retrive');
        return true;
      }, context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unggah Surat'),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          // CustomFormField(
          //     title: 'Judul',
          //     placeholder: 'Masukkan judul ',
          //     controller: judulController),
          // const SizedBox(
          //   height: 10,
          // ),
          CustomUploadFilePath(
            title: 'Unggah File',
            controllerFile: suratController,
            controllerPathFile: pathController,
          ),
          const SizedBox(
            height: 50,
          ),
          CustomFilledButton(
              title: 'Unggah',
              onPressed: () {
                _updateCorrespondence();
              }),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
