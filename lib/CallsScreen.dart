import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '/utils/Appcolors.dart';
import '/utils/CustomDropdownButton2.dart';
import '/utils/Sidedrawer.dart';
import '/utils/StringConstants.dart';
import 'package:sizer/sizer.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  CallsScreenState createState() => CallsScreenState();
}

class CallsScreenState extends State<CallsScreen> {
  late StateSetter setstate;
  List<String> items = [
    StringConstants.allcalls,
    StringConstants.phonecalls,
    StringConstants.videocalls
  ];
  List<String> datesvalue = [
    "2023",
    "2022",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015"
  ];
  String dropdownvalue = StringConstants.allcalls;
  String secondfdropdownvalue = "2023";
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   scrollController.animateTo(
    //     scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 100),
    //     curve: Curves.easeOut,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const Sidedrawer(),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Appcolors().bottomnavbgcolor,
      //   leading: GestureDetector(
      //     onTap: (){
      //       _key.currentState!.openDrawer();
      //     },
      //     child: Center(
      //         child: SvgPicture.asset(
      //       "assets/images/menubtn.svg",
      //     )),
      //   ),
      //   title: Text(
      //     StringConstants.calls,
      //     style: TextStyle(
      //         fontSize: 14.sp,
      //         fontFamily: "PulpDisplay",
      //         fontWeight: FontWeight.w500,
      //         color: Appcolors().whitecolor),
      //   ),
      // ),
      body: Container(
        padding: EdgeInsets.only(left: 3.w, right: 3.w),
        color: Appcolors().backgroundcolor,
        child: Column(
          children: [
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                  child: CustomDropdownButton2(
                    hint: 'Select Item',
                    dropdownItems: items,
                    value: dropdownvalue,
                    onChanged: (value) {
                      setState(() {
                        dropdownvalue = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                SizedBox(
                  width: 27.w,
                  child: CustomDropdownButton2(
                    hint: "Select Item",
                    dropdownItems: datesvalue,
                    value: secondfdropdownvalue,
                    dropdownWidth: 27.w,
                    dropdownHeight: 60.h,
                    buttonWidth: 27.w,
                    onChanged: (value) {
                      setState(() {
                        secondfdropdownvalue = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Expanded(
                child: AnimationLimiter(
              child: ListView.builder(
                itemCount: 10,
                reverse: false,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                          child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.h),
                                border: Border.all(
                                    color: Appcolors().chatuserborder)),
                            padding: EdgeInsets.only(
                                top: 2.h, bottom: 2.h, left: 2.w, right: 3.w),
                            width: double.infinity,
                            height: 20.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40.w,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 7.w,
                                            child: Image.asset(
                                              index % 2 == 0
                                                  ? "assets/images/callicon.png"
                                                  : "assets/images/videocallicon.png",
                                              height: 2.5.h,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Text(
                                            index % 2 == 0
                                                ? StringConstants.phonecallon
                                                : StringConstants.videocallon,
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                // fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Appcolors().loginhintcolor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 45.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "29/04/2023",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w400,
                                                color: Appcolors().whitecolor),
                                          ),
                                          Text(
                                            "|",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w400,
                                                color: Appcolors().whitecolor),
                                          ),
                                          Text(
                                            "10:59:03 PM",
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w400,
                                                color: Appcolors().whitecolor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40.w,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 7.w,
                                            child: Image.asset(
                                              "assets/images/usericon.png",
                                              height: 3.h,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Text(
                                            StringConstants.username,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                // fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Appcolors().loginhintcolor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 45.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "chris88",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w400,
                                                color: Appcolors().whitecolor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40.w,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 7.w,
                                            child: Image.asset(
                                              "assets/images/durationicon.png",
                                              height: 2.7.h,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Text(
                                            StringConstants.duration,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                // fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Appcolors().loginhintcolor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 45.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "3m32s",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w400,
                                                color: Appcolors().whitecolor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40.w,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 7.w,
                                            child: Image.asset(
                                              "assets/images/earningicon.png",
                                              height: 2.7.h,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Text(
                                            StringConstants.earnings,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                // fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Appcolors().loginhintcolor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 45.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$36.00",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: "PulpDisplay",
                                                fontWeight: FontWeight.w400,
                                                color: Appcolors().whitecolor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                        ],
                      )),
                    ),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
