import 'package:flutter/material.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class StyledSwitch extends StatefulWidget {
  final void Function(String clockValue) clockValue;

  const StyledSwitch({Key? key, required this.clockValue}) : super(key: key);

  @override
  State<StyledSwitch> createState() => _StyledSwitchState();
}

class _StyledSwitchState extends State<StyledSwitch> {
  bool isToggled = true;
  String clockValue = '';
  double size = 25;
  double innerPadding = 0;

  @override
  void initState() {
    innerPadding = size / 10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isToggled) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!);
            },
            initialEntryMode: TimePickerEntryMode.inputOnly,
            cancelText: 'Batal',
            confirmText: 'Oke',
            helpText: 'Pilih Waktu',
            hourLabelText: '',
            minuteLabelText: '',
          );

          if (pickedTime != null) {
            DateTime parsedTime =
                DateFormat.Hm().parse(pickedTime.format(context).toString());
            String formattedTime = DateFormat('HH:mm').format(parsedTime);
            setState(() {
              clockValue = formattedTime;
            });
          } else {
            print("Time is not selected");
          }
        } else {
          clockValue = '';
        }

        setState(() {
          if (clockValue != '' || isToggled == false) {
            isToggled = !isToggled;
          }
        });
        widget.clockValue(clockValue);
      },
      child: AnimatedContainer(
        height: size,
        width: 40,
        padding: EdgeInsets.all(innerPadding),
        alignment: isToggled ? Alignment.centerLeft : Alignment.centerRight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isToggled ? neutral200 : primaryBlue1,
        ),
        child: Container(
          width: size - innerPadding * 2,
          height: size - innerPadding * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          child: isToggled
              ? null
              : Center(
                  child: Image.asset(
                  'assets/images/ic_check.png',
                  width: 7,
                )),
        ),
      ),
    );
  }
}
