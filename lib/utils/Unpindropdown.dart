import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '/utils/Appcolors.dart';
import 'package:sizer/sizer.dart';

import 'StringConstants.dart';

class Unpindropdown extends StatefulWidget {
  const Unpindropdown({Key? key}) : super(key: key);

  @override
  UnpindropdownState createState() => UnpindropdownState();
}

class UnpindropdownState extends State<Unpindropdown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: Image.asset(
              "assets/images/menubtn.png",
              height: 4.h,
            ),
            items: [
              ...UnpinMenuItems.unpinfirstItems.map(
                (item) => DropdownMenuItem<UnpinCustomMenuItem>(
                  value: item,
                  child: UnpinMenuItems.buildItem(item),
                ),
              ),
              const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
              ...UnpinMenuItems.unpinsecondItems.map(
                (item) => DropdownMenuItem<UnpinCustomMenuItem>(
                  value: item,
                  child: UnpinMenuItems.buildItem(item),
                ),
              ),
            ],
            onChanged: (value) {
              UnpinMenuItems.onChanged(context, value as UnpinCustomMenuItem);
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
                ...List<double>.filled(
                    UnpinMenuItems.unpinfirstItems.length, 48),
                8,
                ...List<double>.filled(
                    UnpinMenuItems.unpinsecondItems.length, 48),
              ],
              padding: const EdgeInsets.only(left: 16, right: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class UnpinCustomMenuItem {
  final String text;
  final IconData icon;

  const UnpinCustomMenuItem({
    required this.text,
    required this.icon,
  });
}

class UnpinMenuItems {
  List<String> menuoptions = [
    StringConstants.editpost,
    StringConstants.deletepost,
  ];
  static const List<UnpinCustomMenuItem> unpinfirstItems = [
    editpost,
    copylink,
    unpinpost,
    deletepost
  ];
  static const List<UnpinCustomMenuItem> unpinsecondItems = [];
  static const UnpinCustomMenuItem editpost =
      UnpinCustomMenuItem(text: "Edit Post", icon: Icons.home);
  static const UnpinCustomMenuItem copylink =
      UnpinCustomMenuItem(text: "Copy Link", icon: Icons.share);
  static const UnpinCustomMenuItem unpinpost = UnpinCustomMenuItem(
    text: "Unpin Post",
    icon: Icons.settings,
  );
  static const UnpinCustomMenuItem deletepost = UnpinCustomMenuItem(
    text: "Delete Post",
    icon: Icons.logout,
  );

  static Widget buildItem(UnpinCustomMenuItem item) {
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

  static onChanged(BuildContext context, UnpinCustomMenuItem item) {
    switch (item) {
      case editpost:
        //Do something
        break;
      case copylink:
        //Do something
        break;
      case unpinpost:
        //Do something
        break;
      case deletepost:
        //Do something
        break;
    }
  }
}
