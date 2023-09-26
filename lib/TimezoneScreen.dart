import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sextconfidential/utils/Appcolors.dart';
import 'package:sextconfidential/utils/CustomDropdownButton2.dart';
import 'package:sextconfidential/utils/Helpingwidgets.dart';
import 'package:sextconfidential/utils/Networks.dart';
import 'package:sextconfidential/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class TimezoneScreen extends StatefulWidget{
  const TimezoneScreen({super.key});

  @override
  TimezoneScreenState createState() => TimezoneScreenState();

}

class TimezoneScreenState extends State<TimezoneScreen>{
  List<String>timezonelist=["Eastern UTC -05:00","Central UTC - 06:00","Mountain UTC - 07:00","Pacific UTC - 08:00"];
  String dropdownvalue="Eastern UTC -05:00";
  String userselectedzone="Eastern UTC -05:00";
  bool savebtnstatus=false;
  String? token;
  GlobalKey<State>key=GlobalKey();
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
      bottomNavigationBar: SizedBox(
        height: 20.h,
        child: Center(
          child:
          Offstage(
            offstage: !savebtnstatus,
            child: GestureDetector(
              onTap: (){
                settimezone();
              },
              child: Container(
                alignment: Alignment.center,
                width: 60.w,
                height: 5.h,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage(
                          "assets/images/btnbackgroundgradient.png"),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
                child: Text(
                  StringConstants.savechanges,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "PulpDisplay",
                      fontWeight: FontWeight.w500,
                      color: Appcolors().blackcolor),
                ),
              ),
            ),
          )
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appcolors().bottomnavbgcolor,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
            print("Click back");
          },
          child: Container(
            // color: Colors.white,
              margin: EdgeInsets.only(left: 2.w),
              child: const Icon(Icons.arrow_back_ios_rounded)),
        ),
        title: Text(StringConstants.timezone,style: TextStyle(
            fontSize: 14.sp,
            fontFamily: "PulpDisplay",
            fontWeight: FontWeight.w500,
            color: Appcolors().whitecolor),),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h),
        child: Column(
          children: [
              SizedBox(
                height: 2.h,
              ),
            Text(StringConstants.timezonenote,style: TextStyle(
                fontSize: 13.sp,
                // fontFamily: "PulpDisplay",
                fontWeight: FontWeight.w500,
                color: Appcolors().loginhintcolor),),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 5.h,
              width: 94.w,
              child: CustomDropdownButton2(
                hint: "Select Item",
                dropdownItems: timezonelist,
                value: dropdownvalue,
                dropdownWidth: 96.w,
                dropdownHeight: 60.h,
                buttonWidth: 27.w,
                onChanged: (value) {
                  setState(() {
                    dropdownvalue = value!;
                    value!=userselectedzone?
                    savebtnstatus=true:
                        savebtnstatus=false;
                    print("on change:-$savebtnstatus");


                  });
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> getsharedpreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState((){
      token=sharedPreferences.getString("token");
    });
    print("Token value:-$token");
  }
  Future<void> settimezone() async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data ={
      "timezone":dropdownvalue,
      "token":token,
    };
    var jsonResponse;
    var response = await http.post(
        Uri.parse(Networks.baseurl + Networks.updatetimezone),
        body: data
    );
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Helpingwidgets.failedsnackbar(jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        Helpingwidgets.successsnackbar(jsonResponse["message"].toString(), context);
        print("Response:${jsonResponse["message"]}");
        Navigator.pop(context);
      }
    } else {
      Helpingwidgets.failedsnackbar(jsonResponse["message"].toString(), context);
      Navigator.pop(context);

    }
  }
}