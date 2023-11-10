import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '/Changepassword.dart';
import '/Deactivateaccscreen.dart';
import '/Editprofilescreen.dart';
import '/LocationdenialScreen.dart';
import '/LoginScreen.dart';
import '/PayoutInfoScreen.dart';
import '/TimezoneScreen.dart';
import '/utils/Appcolors.dart';
import '/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'Helpingwidgets.dart';
import 'Networks.dart';

class Sidedrawer extends StatefulWidget {
  const Sidedrawer({super.key});

  @override
  SidedrawerState createState() => SidedrawerState();
}

class SidedrawerState extends State<Sidedrawer> {
  static bool phonecallbool = false;
  static List<bool> switchlist = [false, false];

  static List<String> drawertitles = [];

  int onlinestatus = 0;
  static List<String> drawerimages = [
    "assets/images/callunselecticon.png",
    "assets/images/videocallicon.png",
    "assets/images/payoutinfo.png",
    "assets/images/locationdenialicon.png",
    "assets/images/locationicon.png",
    "assets/images/changepassword.png",
    "assets/images/deactivateacc.png",
    "assets/images/logout.png",
  ];
  String? username, profilepic, token, usertype;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsharedpreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().backgroundcolor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h),
          color: Appcolors().backgroundcolor,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 30.w,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 0.5.w, top: 0.5.h),
                          child: Image.asset(
                            "assets/images/crossicon.png",
                            width: 5.w,
                            color: Appcolors().whitecolor,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 3.w,
                    right: 3.w,
                  ),
                  height: 12.h,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage(
                              "assets/images/btnbackgroundgradient.png"),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child: profilepic == null || profilepic == ""
                              ? Image.asset(
                                  "assets/images/userprofile.png",
                                  height: 10.h,
                                  width: 20.w,
                                )
                              : CachedNetworkImage(
                                  imageUrl: profilepic.toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 20.w,
                                    alignment: Alignment.centerLeft,
                                    height: 10.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Appcolors().bottomnavbgcolor,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    width: 20.w,
                                    height: 10.h,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/userprofile.png"))),
                                  ),
                                )),
                      SizedBox(
                        width: 5.w,
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username.toString(),
                              style: TextStyle(
                                  fontSize: 2.2.h,
                                  fontFamily: "PulpDisplay",
                                  fontWeight: FontWeight.w500,
                                  color: Appcolors().blackcolor),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  onlinestatus == 0
                                      ? onlinestatus = 1
                                      : onlinestatus == 1
                                          ? onlinestatus = 2
                                          : onlinestatus = 0;
                                  changestatus();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: onlinestatus == 0
                                        ? Appcolors().loginhintcolor
                                        : onlinestatus == 1
                                            ? Appcolors().onlinecolor
                                            : Appcolors().deactivatecolor,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.only(
                                    left: 3.w,
                                    right: 3.w,
                                    top: 1.h,
                                    bottom: 1.h),
                                child: Text(
                                  onlinestatus == 0
                                      ? "${StringConstants.onlinestatus}: Off"
                                      : onlinestatus == 1
                                          ? "${StringConstants.onlinestatus}: On"
                                          : "${StringConstants.onlinestatus}: Away",
                                  style: TextStyle(
                                      fontSize: 1.5.h,
                                      fontFamily: "PulpDisplay",
                                      fontWeight: FontWeight.w500,
                                      color: onlinestatus == 2
                                          ? Appcolors().whitecolor
                                          : Appcolors().bottomnavbgcolor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Editprofilescreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Appcolors().blackcolor,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(2.w),
                          child: SvgPicture.asset("assets/images/editicon.svg"),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: drawertitles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        index == 5
                            ? SizedBox(
                                height: 12.h,
                              )
                            : const SizedBox(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              switch (index) {
                                case 2:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PayoutInfoScreen()));
                                  break;
                                case 3:
                                  {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TimezoneScreen()));
                                    break;
                                  }
                                case 4:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LocationdenialScreen()));
                                  break;
                                case 5:
                                  {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Changepassword()));
                                    break;
                                  }
                                case 6:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Deactivateaccscreen()));
                                  break;
                                case 7:
                                  {
                                    sharedPreferences!.clear();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  }
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 4.w),
                            height: 6.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      drawerimages.elementAt(index),
                                      height: 2.5.h,
                                      width: 3.h,
                                      color: Appcolors().whitecolor,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Container(
                                      child: Text(
                                        drawertitles.elementAt(index),
                                        style: TextStyle(
                                            fontSize: 2.h,
                                            fontFamily: "PulpDisplay",
                                            fontWeight: FontWeight.w500,
                                            color: Appcolors().whitecolor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                drawertitles.elementAt(index) ==
                                            StringConstants.phonecalls ||
                                        drawertitles.elementAt(index) ==
                                            StringConstants.videocalls
                                    ? Container(
                                        child: FlutterSwitch(
                                          width: 50.0,
                                          height: 25.0,
                                          toggleSize: 25.0,
                                          value: switchlist.elementAt(index),
                                          borderRadius: 40.0,
                                          padding: 2.0,
                                          toggleColor: Colors.black,
                                          toggleBorder: Border.all(
                                            color: Colors.black,
                                            width: 5.0,
                                          ),
                                          activeColor:
                                              Appcolors().gradientcolorfirst,
                                          inactiveColor:
                                              Appcolors().loginhintcolor,
                                          onToggle: (val) {
                                            setState(() {
                                              switchlist[index] = val;
                                              changestatus();
                                            });
                                          },
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getsharedpreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      usertype = sharedPreferences!.getString("usertype")!.toString();
      username = usertype == "user"
          ? sharedPreferences!.getString("dname") ?? ""
          : sharedPreferences!.getString("stagename") ?? "User Name";
      token = sharedPreferences!.getString("token")!;
      switchlist[0] = sharedPreferences!.getBool("phonecall")!;
      switchlist[1] = sharedPreferences!.getBool("videocall")!;
      onlinestatus =
          int.parse(sharedPreferences!.getString("userstatus").toString());
      profilepic = sharedPreferences!.getString("profilepic").toString();
    });
    if (usertype == "user") {
      drawertitles = [
        StringConstants.timezone,
        StringConstants.locationdeniel,
        StringConstants.changepassword,
        StringConstants.deactivateaccount,
        StringConstants.logout,
      ];
    } else {
      drawertitles = [
        StringConstants.phonecalls,
        StringConstants.videocalls,
        StringConstants.payoutinformation,
        StringConstants.timezone,
        StringConstants.locationdeniel,
        StringConstants.changepassword,
        StringConstants.deactivateaccount,
        StringConstants.logout,
      ];
    }
  }

  Future<void> changestatus() async {
    Map data = {
      "token": token,
      "show_online": onlinestatus.toString(),
      "video_calls": switchlist[0] == true ? "yes" : "no",
      "phone_calls": switchlist[1] == true ? "yes" : "no",
    };
    print("Data:-$data");
    var jsonResponse;
    var response = await http
        .post(Uri.parse(Networks.baseurl + Networks.updateonline), body: data);
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
      } else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool("phonecall", switchlist[0]);
        sharedPreferences.setBool("videocall", switchlist[1]);
        sharedPreferences.setString("userstatus", onlinestatus.toString());
        print("Response:${jsonResponse["message"]}");
      }
    } else {
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }
}
