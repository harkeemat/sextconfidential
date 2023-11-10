import 'dart:convert';

import 'package:flutter/material.dart';
import '/utils/Appcolors.dart';
import '/utils/Helpingwidgets.dart';
import '/utils/Networks.dart';
import '/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class PayoutInfoScreen extends StatefulWidget {
  const PayoutInfoScreen({super.key});

  @override
  PayoutInfoScreenState createState() => PayoutInfoScreenState();
}

class PayoutInfoScreenState extends State<PayoutInfoScreen> {
  bool twelvehouralert = false;
  bool endofpayalert = false;
  bool payoutprocessedalert = false;
  SharedPreferences? sharedPreferences;
  String? token;
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appcolors().bottomnavbgcolor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            print("Click back");
          },
          child: Container(
              // color: Colors.white,
              margin: EdgeInsets.only(left: 2.w),
              child: const Icon(Icons.arrow_back_ios_rounded)),
        ),
        title: Text(
          StringConstants.payoutinformation,
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: "PulpDisplay",
              fontWeight: FontWeight.w500,
              color: Appcolors().whitecolor),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 3.w, right: 3.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: twelvehouralert
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  colors: [
                                    Appcolors().gradientcolorfirst,
                                    Appcolors().gradientcolorsecond,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: const [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Appcolors().checkboxcolor,
                            ),
                      height: 3.h,
                      width: 3.h,
                      child: Checkbox(
                        fillColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        checkColor: Appcolors().backgroundcolor,
                        activeColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        value: twelvehouralert,
                        onChanged: (value) {
                          setState(() {
                            twelvehouralert = value!;
                            payoutinfo();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    twelvehouralert
                        ? GradientText(
                            StringConstants.hoursalert,
                            style: TextStyle(
                                fontSize: 12.sp,
                                // fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                color: Appcolors().loginhintcolor),
                            gradientType: GradientType.linear,
                            gradientDirection: GradientDirection.ttb,
                            radius: 8,
                            colors: [
                              Appcolors().gradientcolorfirst,
                              Appcolors().gradientcolorsecond,
                            ],
                          )
                        : Text(
                            StringConstants.hoursalert,
                            style: TextStyle(
                                fontSize: 12.sp,
                                // fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                color: Appcolors().loginhintcolor),
                          )
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: payoutprocessedalert
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  colors: [
                                    Appcolors().gradientcolorfirst,
                                    Appcolors().gradientcolorsecond,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: const [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Appcolors().checkboxcolor,
                            ),
                      height: 3.h,
                      width: 3.h,
                      child: Checkbox(
                        fillColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        checkColor: Appcolors().backgroundcolor,
                        activeColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        value: payoutprocessedalert,
                        onChanged: (value) {
                          setState(() {
                            payoutprocessedalert = value!;
                            payoutinfo();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    payoutprocessedalert
                        ? GradientText(
                            StringConstants.payoutprocessed,
                            style: TextStyle(
                                fontSize: 12.sp,
                                // fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                color: Appcolors().loginhintcolor),
                            gradientType: GradientType.linear,
                            gradientDirection: GradientDirection.ttb,
                            radius: 8,
                            colors: [
                              Appcolors().gradientcolorfirst,
                              Appcolors().gradientcolorsecond,
                            ],
                          )
                        : Text(
                            StringConstants.payoutprocessed,
                            style: TextStyle(
                                fontSize: 12.sp,
                                // fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                color: Appcolors().loginhintcolor),
                          ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: endofpayalert
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  colors: [
                                    Appcolors().gradientcolorfirst,
                                    Appcolors().gradientcolorsecond,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: const [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Appcolors().checkboxcolor,
                            ),
                      height: 3.h,
                      width: 3.h,
                      child: Checkbox(
                        fillColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        checkColor: Appcolors().backgroundcolor,
                        activeColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        value: endofpayalert,
                        onChanged: (value) {
                          setState(() {
                            endofpayalert = value!;
                            payoutinfo();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    endofpayalert
                        ? GradientText(
                            StringConstants.endofpayperiod,
                            style: TextStyle(
                                fontSize: 12.sp,
                                // fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                color: Appcolors().loginhintcolor),
                            gradientType: GradientType.linear,
                            gradientDirection: GradientDirection.ttb,
                            radius: 8,
                            colors: [
                              Appcolors().gradientcolorfirst,
                              Appcolors().gradientcolorsecond,
                            ],
                          )
                        : Text(
                            StringConstants.endofpayperiod,
                            style: TextStyle(
                                fontSize: 12.sp,
                                // fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                color: Appcolors().loginhintcolor),
                          )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getsharedpreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences?.getString("token");
      twelvehouralert = sharedPreferences!.getBool("twelvehouralert") ?? false;
      payoutprocessedalert =
          sharedPreferences!.getBool("payoutprocessed") ?? false;
      endofpayalert = sharedPreferences!.getBool("endofpayperiod") ?? false;
    });
    print("Token value:-$token");
  }

  Future<void> payoutinfo() async {
    Map data = {
      "token": token,
      "hours": twelvehouralert.toString(),
      "processed": payoutprocessedalert.toString(),
      "endpayperiod": endofpayalert.toString(),
    };
    print("Data:-$data");
    var jsonResponse;
    var response = await http.post(
        Uri.parse(Networks.baseurl + Networks.updatepayoutinfo),
        body: data);
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
      } else {
        Helpingwidgets.successsnackbar(
            jsonResponse["message"].toString(), context);
        print("Response:${jsonResponse["message"]}");
        sharedPreferences!.setBool("twelvehouralert", twelvehouralert);
        sharedPreferences!.setBool("payoutprocessed", payoutprocessedalert);
        sharedPreferences!.setBool("endofpayperiod", endofpayalert);
        // Navigator.pop(context);
      }
    } else {
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }
}
