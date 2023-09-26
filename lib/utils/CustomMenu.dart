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
              ...MenuItems.firstItems.map(
                    (item) => DropdownMenuItem<CustomMenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
              ),
              const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
              ...MenuItems.secondItems.map(
                    (item) => DropdownMenuItem<CustomMenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
              ),
            ],
            onChanged: (value) {
              MenuItems.onChanged(context, value as CustomMenuItem);
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
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              padding: const EdgeInsets.only(left: 16, right: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomMenuItem {
  final String text;
  final IconData icon;

  const CustomMenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  List<String> menuoptions = [
    StringConstants.editpost,
    StringConstants.copylink,
    StringConstants.pinpost,
    StringConstants.deletepost,
  ];
  static  const List<CustomMenuItem> firstItems = [editpost, copylink, pinpost,deletepost];
  static const List<CustomMenuItem> secondItems = [];
  static  const CustomMenuItem editpost = CustomMenuItem(text: "Edit Post", icon: Icons.home);
  static  const CustomMenuItem copylink = CustomMenuItem(text: "Copy Link", icon: Icons.share);
  static  const CustomMenuItem pinpost = CustomMenuItem(text: "Pin Post", icon: Icons.settings,);
  static  const CustomMenuItem deletepost = CustomMenuItem(text: "Delete Post", icon: Icons.logout,);

  static Widget buildItem(CustomMenuItem item) {
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

  static onChanged(BuildContext context, CustomMenuItem item) {
    switch (item) {
      case editpost:
      //Do something
        break;
      case copylink:
      //Do something
        break;
      case pinpost:
      //Do something
        break;
      case deletepost:
      //Do something
        break;
    }
  }
}