import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:galaxy_satwa/services/auth_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../config/methods.dart';

//
class CustomUploadImagePath extends StatefulWidget {
  final String title;
  final TextEditingController controllerImage;
  const CustomUploadImagePath({
    super.key,
    required this.title,
    required this.controllerImage,
  });

  @override
  State<CustomUploadImagePath> createState() => _CustomUploadImagePathState();
}

class _CustomUploadImagePathState extends State<CustomUploadImagePath> {
  XFile? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            final image = await selectImage();

            setState(() {
              selectedImage = image;
              // if (selectedImage != null) {
              //   pengajuanKehadiranController
              //       .changeNameDokumen(basename(selectedImage!.path));
              //   widget.controllerImage.text = basename(selectedImage!.path);
              // }
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(
                      color: const Color(0xFFC1C2C4).withOpacity(0.20),
                      width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/ic_document_colored.png',
                      width: 24,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Unggah Dokumen',
                        style: plusJakartaSans.copyWith(
                            fontSize: 11, color: neutral00)),
                    const Spacer(),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/ic_paper.png',
                      width: 24,
                    )
                  ],
                ),
                selectedImage != null
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 34,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.controllerImage.text,
                                style: plusJakartaSans.copyWith(
                                    fontSize: 12,
                                    fontWeight: bold,
                                    color: neutral00),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 90,
                                height: 135,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 6),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(selectedImage!.path),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//
class CustomUploadFilePath extends StatefulWidget {
  final String title;
  final TextEditingController controllerFile;
  final TextEditingController controllerPathFile;
  const CustomUploadFilePath(
      {super.key,
      required this.title,
      required this.controllerFile,
      required this.controllerPathFile});

  @override
  State<CustomUploadFilePath> createState() => _CustomUploadFilePathState();
}

class _CustomUploadFilePathState extends State<CustomUploadFilePath> {
  File? pathFile;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        Text(
          widget.title,
          style: plusJakartaSans.copyWith(
              fontWeight: semiBold,
              fontSize: 12,
              color: const Color(0xFF586266)),
        ),
        const SizedBox(
          height: 1,
        ),
        GestureDetector(
          onTap: () async {
            final resultFile = await selectFile();

            if (resultFile == null) return;
            String fileExtension = extension(resultFile.files.single.name);
            if (fileExtension.toLowerCase() != '.pdf') return;
            // pengajuanCutiController
            //     .changeNameFile(resultFile.files.single.name);

            setState(() {
              widget.controllerFile.text = resultFile.files.single.name;
              pathFile = File(resultFile.files.single.path.toString());
              widget.controllerPathFile.text = getStringImage(pathFile)!;
            });
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: const Color(0xFFEDF1F7),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                if (widget.controllerFile.text == '')
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.asset(
                      'assets/ic_upload.png',
                      width: 15,
                    ),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    widget.controllerFile.text == ''
                        ? 'Unggah File'
                        : widget.controllerFile.text,
                    style: inter.copyWith(
                        fontSize: 12, color: const Color(0xFF017BF8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                if (widget.controllerFile.text != '')
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.controllerFile.text = '';
                      });
                    },
                    child: Container(
                      height: 40,
                      color: const Color(0xFFEDF1F7),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Image.asset(
                          'assets/ic_close.png',
                          width: 20,
                          color: neutral00,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//
class PreviewPdf extends StatelessWidget {
  final String path;
  final String nameFile;
  const PreviewPdf({super.key, required this.path, required this.nameFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameFile),
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
      body: PDFView(
        filePath: path,
      ),
    );
  }
}

//
class CustomFormField extends StatelessWidget {
  final String title;
  final String placeholder;
  final TextEditingController controller;
  final bool isEnable;
  final bool isRequired;
  final bool isNumberOnly;
  const CustomFormField(
      {super.key,
      required this.title,
      required this.placeholder,
      required this.controller,
      this.isEnable = true,
      this.isRequired = false,
      this.isNumberOnly = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Text(
              title,
              style: plusJakartaSans.copyWith(
                  fontWeight: semiBold,
                  fontSize: 12,
                  color: const Color(0xFF586266)),
            ),
            isRequired
                ? Text(
                    '*',
                    style: plusJakartaSans.copyWith(
                        fontWeight: semiBold,
                        fontSize: 12,
                        color: const Color(0xFFF44336)),
                  )
                : Container(),
          ],
        ),
        const SizedBox(
          height: 1,
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: const Color(0xFFedf1f7),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: TextFormField(
                controller: controller,
                keyboardType:
                    isNumberOnly ? TextInputType.number : TextInputType.text,
                enabled: isEnable,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                  hintText: placeholder,
                  hintStyle:
                      plusJakartaSans.copyWith(fontSize: 12, color: neutral200),
                  border: InputBorder.none,
                ),
                style:
                    plusJakartaSans.copyWith(fontSize: 12, color: neutral00)),
          ),
        )
      ],
    );
  }
}

//CustomFormDropdown
class CustomFormDropdown extends StatefulWidget {
  final String title;
  final List<String> listItems;
  final String placeholderText;
  final bool isRequired;
  final TextEditingController controller;
  const CustomFormDropdown(
      {super.key,
      required this.title,
      required this.listItems,
      required this.placeholderText,
      this.isRequired = false,
      required this.controller});

  @override
  State<CustomFormDropdown> createState() => _CustomFormDropdownState();
}

class _CustomFormDropdownState extends State<CustomFormDropdown> {
  String? selectedValue;

  @override
  void initState() {
    if (widget.controller.text != '') {
      setState(() {
        selectedValue = widget.controller.text;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Text(
              widget.title,
              style: plusJakartaSans.copyWith(
                  fontWeight: semiBold,
                  fontSize: 12,
                  color: const Color(0xFF586266)),
            ),
            widget.isRequired
                ? Text(
                    '*',
                    style: plusJakartaSans.copyWith(
                        fontWeight: semiBold,
                        fontSize: 12,
                        color: const Color(0xFFF44336)),
                  )
                : Container(),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        DropdownButton2<String>(
          underline: Container(),
          isExpanded: true,
          iconStyleData: IconStyleData(
              icon: Transform.rotate(
            angle: 1.5708, // 90 degrees in radians
            child: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: widget.controller.text.trim().isEmpty
                  ? neutral200
                  : primaryBlue1,
            ),
          )),
          hint: widget.controller.text.isNotEmpty
              ? Text(widget.controller.text,
                  style: plusJakartaSans.copyWith(
                      fontWeight: medium, fontSize: 12, color: neutral00))
              : Text(widget.placeholderText,
                  style: plusJakartaSans.copyWith(
                      fontSize: 12, color: neutral200)),
          items: widget.listItems
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: plusJakartaSans.copyWith(
                          fontWeight: medium, fontSize: 12, color: neutral00),
                    ),
                  ))
              .toList(),
          menuItemStyleData: const MenuItemStyleData(height: 35),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
              widget.controller.text = value!;
            });
          },
          buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40, //Tinggi Form
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xFFEDF1F7),
                  borderRadius: BorderRadius.circular(10))),
          dropdownStyleData: DropdownStyleData(
              maxHeight: 300, //Tinggi Pop Up Dropdown
              decoration: BoxDecoration(color: neutral07),
              elevation: 1),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              widget.controller.clear();
            }
          },
        ),
      ],
    );
  }
}

//CustomFormDropdownImage
class CustomFormDropdown2 extends StatefulWidget {
  final List<String> listId;
  final List<String> listItems;
  final List<String> listImage;
  final String placeholderText;
  final String urlImage;
  final TextEditingController controller;
  const CustomFormDropdown2(
      {super.key,
      required this.listId,
      required this.listItems,
      required this.listImage,
      required this.placeholderText,
      required this.urlImage,
      required this.controller});

  @override
  State<CustomFormDropdown2> createState() => _CustomFormDropdown2State();
}

class _CustomFormDropdown2State extends State<CustomFormDropdown2> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          widget.urlImage,
          width: 24,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: DropdownButton2<String>(
            underline: Container(),
            isExpanded: true,
            iconStyleData: IconStyleData(
                icon: Transform.rotate(
              angle: 1.5708,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: widget.controller.text.trim().isEmpty
                    ? neutral200
                    : primaryBlue1,
              ),
            )),
            hint: widget.controller.text.isNotEmpty
                ? Text(widget.controller.text.split('||')[1],
                    style: plusJakartaSans.copyWith(
                        fontWeight: medium, fontSize: 12, color: neutral00))
                : Text(widget.placeholderText,
                    style: plusJakartaSans.copyWith(
                        fontSize: 12, color: const Color(0xFF94959A))),
            items: List.generate(
              widget.listItems.length,
              (index) => DropdownMenuItem(
                value: '${widget.listId[index]}||${widget.listItems[index]}',
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.listImage[index],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.listItems[index],
                      style: plusJakartaSans.copyWith(
                          fontWeight: medium, fontSize: 12, color: neutral00),
                    ),
                  ],
                ),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(height: 50),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                widget.controller.text = value!;
              });
            },
            buttonStyleData: ButtonStyleData(
                height: 40, //Tinggi Form
                width: double.infinity,
                decoration: BoxDecoration(
                  color: neutral07,
                )),
            dropdownStyleData: const DropdownStyleData(
                maxHeight: 500, //Tinggi Pop Up Dropdown
                elevation: 1),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                widget.controller.clear();
              }
            },
          ),
        ),
      ],
    );
  }
}

//Date
class CustomFormDate extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextEditingController tanggalController;
  final bool isEnable;
  final bool hasTitle;
  const CustomFormDate(
      {super.key,
      required this.title,
      required this.placeholder,
      required this.tanggalController,
      this.hasTitle = true,
      this.isEnable = true});

  @override
  State<CustomFormDate> createState() => _CustomFormDateState();
}

class _CustomFormDateState extends State<CustomFormDate> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    late PageController pageController;
    widget.tanggalController.addListener(() {
      setState(() {});
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        if (widget.hasTitle)
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(
              widget.title,
              style: plusJakartaSans.copyWith(
                  fontWeight: semiBold,
                  fontSize: 12,
                  color: const Color(0xFF586266)),
            ),
          ),
        GestureDetector(
          onTap: () {
            widget.isEnable
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  height: (MediaQuery.of(context).size.height -
                                          MediaQuery.of(context).padding.top -
                                          400) /
                                      2,
                                )),
                            Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                decoration: BoxDecoration(
                                    color: neutral07,
                                    border: Border.all(
                                        color: const Color(0xFFC1C2C4)),
                                    borderRadius: BorderRadius.circular(6.528)),
                                child: TableCalendar(
                                  onCalendarCreated: (controller) =>
                                      pageController = controller,
                                  weekendDays: const [6, 7],
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                      weekdayStyle: inter.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF333333)),
                                      weekendStyle: inter.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF333333))),
                                  firstDay: DateTime.utc(2020, 3, 14),
                                  lastDay: DateTime.utc(2040, 3, 14),
                                  focusedDay: DateTime.now(),
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleTextStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  calendarStyle: CalendarStyle(
                                    cellMargin: const EdgeInsets.all(3),
                                    todayTextStyle: inter.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                    todayDecoration: const BoxDecoration(
                                        color: Color(0xFF7058E2),
                                        shape: BoxShape.circle),
                                    weekendTextStyle: inter.copyWith(
                                        color: const Color(0xFFE2313D),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                    defaultTextStyle: inter.copyWith(
                                        color: const Color(0xFF666666),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                    tablePadding: const EdgeInsets.fromLTRB(
                                        39, 0, 39, 29),
                                  ),
                                  rowHeight: 40,
                                  daysOfWeekHeight: 20,
                                  onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                                      widget.tanggalController.text =
                                          DateFormat('EEEE, dd MMMM yyyy')
                                              .format(selectedDay);
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  height: (MediaQuery.of(context).size.height -
                                          MediaQuery.of(context).padding.top -
                                          400) /
                                      2,
                                )),
                          ],
                        ),
                      );
                    })
                : null;
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFEDF1F7)),
            child: Row(
              children: [
                Text(
                  widget.tanggalController.text.isEmpty
                      ? widget.placeholder
                      : widget.tanggalController.text,
                  style: plusJakartaSans.copyWith(
                      fontSize: 12,
                      color: widget.tanggalController.text.isEmpty
                          ? neutral200
                          : neutral00),
                ),
                const Spacer(),
                Image.asset(
                  widget.tanggalController.text.isEmpty
                      ? 'assets/ic_calendar_not_colored.png'
                      : 'assets/ic_calendar_colored.png',
                  width: 24,
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//Date
class CustomFormDateSimple extends StatefulWidget {
  final String placeholder;
  final TextEditingController tanggalController;
  final bool isEnable;
  const CustomFormDateSimple(
      {super.key,
      required this.placeholder,
      required this.tanggalController,
      this.isEnable = true});

  @override
  State<CustomFormDateSimple> createState() => _CustomFormDateSimpleState();
}

class _CustomFormDateSimpleState extends State<CustomFormDateSimple> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    late PageController pageController;
    widget.tanggalController.addListener(() {
      setState(() {});
    });
    return GestureDetector(
        onTap: () {
          widget.isEnable
              ? showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: (MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).padding.top -
                                        400) /
                                    2,
                              )),
                          Center(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 28),
                              decoration: BoxDecoration(
                                  color: neutral07,
                                  border: Border.all(
                                      color: const Color(0xFFC1C2C4)),
                                  borderRadius: BorderRadius.circular(6.528)),
                              child: TableCalendar(
                                onCalendarCreated: (controller) =>
                                    pageController = controller,
                                weekendDays: const [6, 7],
                                daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle: inter.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF333333)),
                                    weekendStyle: inter.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF333333))),
                                firstDay: DateTime.now(),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay: DateTime.now(),
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleTextStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                                calendarStyle: CalendarStyle(
                                  // isTodayHighlighted: false,
                                  cellMargin: const EdgeInsets.all(3),
                                  todayTextStyle: inter.copyWith(
                                      color: Colors.grey.withOpacity(0.6),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                  todayDecoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle),
                                  weekendTextStyle: inter.copyWith(
                                      color: const Color(0xFFE2313D),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                  defaultTextStyle: inter.copyWith(
                                      color: const Color(0xFF666666),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                  tablePadding:
                                      const EdgeInsets.fromLTRB(39, 0, 39, 29),
                                ),
                                rowHeight: 40,
                                daysOfWeekHeight: 20,
                                onDaySelected: (selectedDay, focusedDay) {
                                  String day =
                                      DateFormat('EEEE').format(selectedDay);
                                  if (!['Sabtu', 'Minggu'].contains(day) &&
                                      selectedDay.toString().substring(0, 10) !=
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 10)) {
                                    setState(() {
                                      widget.tanggalController.text =
                                          DateFormat('EEEE, dd MMMM yyyy')
                                              .format(selectedDay);
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: (MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).padding.top -
                                        400) /
                                    2,
                              )),
                        ],
                      ),
                    );
                  })
              : null;
        },
        child: Container(
          color: neutral07,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset(
                'assets/ic_kalender_blue.png',
                width: 24,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                widget.tanggalController.text == ''
                    ? widget.placeholder
                    : widget.tanggalController.text,
                style: plusJakartaSans.copyWith(
                    fontSize: 12,
                    color: widget.tanggalController.text == ''
                        ? const Color(0xFF94959A)
                        : const Color(0xFF09121F)),
              )
            ],
          ),
        ));
  }
}

// BirthDate
class CustomBirthDate extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextEditingController tanggalController;
  const CustomBirthDate({
    super.key,
    required this.title,
    required this.placeholder,
    required this.tanggalController,
  });

  @override
  State<CustomBirthDate> createState() => _CustomBirthDateState();
}

class _CustomBirthDateState extends State<CustomBirthDate> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.tanggalController.text =
            _selectedDate.toString().substring(0, 10);
      });
    }
  }

  @override
  void initState() {
    if (widget.tanggalController.text != '') {
      _selectedDate = DateTime.now();
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        Text(
          widget.title,
          style: plusJakartaSans.copyWith(
              fontWeight: semiBold,
              fontSize: 12,
              color: const Color(0xFF586266)),
        ),
        const SizedBox(
          height: 1,
        ),
        GestureDetector(
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFEDF1F7)),
            child: Row(
              children: [
                Text(
                  _selectedDate == null
                      ? widget.placeholder
                      : _selectedDate.toString().substring(0, 10),
                  style: plusJakartaSans.copyWith(
                      fontSize: 12,
                      color: _selectedDate == null ? neutral200 : neutral00),
                ),
                const Spacer(),
                Image.asset(
                  _selectedDate == null
                      ? 'assets/ic_calendar_not_colored.png'
                      : 'assets/ic_calendar_colored.png',
                  width: 24,
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
