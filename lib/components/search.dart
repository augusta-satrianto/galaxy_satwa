import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';

class CustomSearch extends StatelessWidget {
  final String placeholder;
  final TextEditingController seacrhController;
  const CustomSearch(
      {super.key, required this.placeholder, required this.seacrhController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
          color: neutral100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: neutral02)),
      child: TextFormField(
        controller: seacrhController,
        style: inter.copyWith(color: neutral, fontSize: 12),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 0, top: 2, right: 10),
          hintText: placeholder,
          hintStyle: inter.copyWith(color: neutral02, fontSize: 12),
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/ic_search.png',
                width: 18,
              ),
            ],
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
