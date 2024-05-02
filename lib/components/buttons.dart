import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';

class CustomFilledButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? height;
  final bool? isActive;
  const CustomFilledButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.height = 48,
      this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isActive! ? primaryGreen1 : neutral200,
        borderRadius: BorderRadius.circular(5),
        boxShadow: !isActive!
            ? [
                const BoxShadow(
                  color: Color(0x22000000),
                  offset: Offset(0, 0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                ),
              ]
            : null,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: plusJakartaSans.copyWith(
              color: Colors.white, fontWeight: semiBold),
        ),
      ),
    );
  }
}
