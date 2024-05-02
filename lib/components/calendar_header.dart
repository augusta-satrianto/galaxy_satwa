import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:galaxy_satwa/config/theme.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.only(left: 39, right: 20),
      child: Row(
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: inter.copyWith(
                  fontSize: 13.06, fontWeight: bold, color: neutral00),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
            color: neutral01,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
            color: neutral01,
          ),
        ],
      ),
    );
  }
}
