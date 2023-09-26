import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sextconfidential/utils/Appcolors.dart';
import 'package:sizer/sizer.dart';

import 'StringConstants.dart';

class CustomButtonTest extends StatefulWidget {
  const CustomButtonTest({Key? key}) : super(key: key);

  @override
  State<CustomButtonTest> createState() => _CustomButtonTestState();
}

class _CustomButtonTestState extends State<CustomButtonTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: Image.asset("assets/images/menubtn.png",height: 4.h,),
            items: [
              ...ScheduledMenuItems.schedulefirstItems.map(
                    (item) => DropdownMenuItem<ScheduledCustomMenuItem>(
                  value: item,
                  child: ScheduledMenuItems.buildItem(item),
                ),
              ),
              const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
              ...ScheduledMenuItems.schedulesecondItems.map(
                    (item) => DropdownMenuItem<ScheduledCustomMenuItem>(
                  value: item,
                  child: ScheduledMenuItems.buildItem(item),
                ),
              ),
            ],
            onChanged: (value) {
              ScheduledMenuItems.onChanged(context, value as ScheduledCustomMenuItem);
            },
            dropdownStyleData: DropdownStyleData(
              width: 160,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Appcolors().bottomnavbgcolor,
              ),
              elevation: 8,
              offset: const Offset(0, 8),
            ),
            menuItemStyleData: MenuItemStyleData(
              customHeights: [
                ...List<double>.filled(ScheduledMenuItems.schedulefirstItems.length, 48),
                8,
                ...List<double>.filled(ScheduledMenuItems.schedulesecondItems.length, 48),
              ],
              padding: const EdgeInsets.only(left: 16, right: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class ScheduledCustomMenuItem {
  final String text;
  final IconData icon;

  const ScheduledCustomMenuItem({
    required this.text,
    required this.icon,
  });
}

class ScheduledMenuItems {
  List<String> menuoptions = [
    StringConstants.editpost,
    StringConstants.deletepost,
  ];
  static  const List<ScheduledCustomMenuItem> schedulefirstItems = [editpost,deletepost];
  static const List<ScheduledCustomMenuItem> schedulesecondItems = [];
  static  const ScheduledCustomMenuItem editpost = ScheduledCustomMenuItem(text: "Edit Post", icon: Icons.home);
  static  const ScheduledCustomMenuItem deletepost = ScheduledCustomMenuItem(text: "Delete Post", icon: Icons.logout,);

  static Widget buildItem(ScheduledCustomMenuItem item) {
    return Row(
      children: [
        // Icon(item.icon, color: Appcolors().bottomnavbgcolor, size: 22),
        // const SizedBox(
        //   width: 10,
        // ),
        Text(
          item.text,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, ScheduledCustomMenuItem item) {
    switch (item) {
      case editpost:
      //Do something
        break;
      case deletepost:
      //Do something
        break;
    }
  }
}