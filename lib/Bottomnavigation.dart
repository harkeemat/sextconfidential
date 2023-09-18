import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sextconfidential/pojo/getpayoutpojo.dart';
import 'package:sextconfidential/utils/Appcolors.dart';
import 'package:sextconfidential/utils/Helpingwidgets.dart';
import 'package:sextconfidential/utils/Networks.dart';
import 'package:sextconfidential/utils/Sidedrawer.dart';
import 'package:sextconfidential/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'CallsScreen.dart';
import 'Chatusersscreen.dart';
import 'FeedScreen.dart';
import 'MassmessageScreen.dart';

class Bottomnavigation extends StatefulWidget {
  @override
  BottomnavigationState createState() => BottomnavigationState();
}

class BottomnavigationState extends State<Bottomnavigation> {
  int selectedindex = 0;
  SharedPreferences? sharedPreferences;
  String? token;
  final pages = [
    Chatusersscreen(),
    MassmessageScreen(),
    FeedScreen(),
    CallsScreen(),
  ];
  Getpayoutpojo? getpayoutpojo;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().bottomnavbgcolor,
      key: _key,
      drawer: Sidedrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appcolors().bottomnavbgcolor,
        leading: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              _key.currentState!.openDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(2.h),
                child: Center(
                  child: SvgPicture.asset(
              "assets/images/menubtn.svg",height: 3.h,
            ),
                ))),
        title: Text(
          selectedindex == 0
              ? StringConstants.messages
              : selectedindex == 1
                  ? StringConstants.massmessages
                  : selectedindex == 2
                      ? StringConstants.feed
                      : StringConstants.calls,
          style: TextStyle(
              fontSize: 2.2.h,
              fontFamily: "PulpDisplay",
              fontWeight: FontWeight.w500,
              color: Appcolors().whitecolor),
        ),
      ),
      body: pages[selectedindex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 7.h,
          color: Appcolors().bottomnavbgcolor,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedindex = 0;
                  });
                },
                child:
                Container(
                  padding: EdgeInsets.all(2),
                  // color: Colors.white,
                    height: 4.h,
                  width: 7.w,
                  child:selectedindex == 0
                      ? Image.asset("assets/images/chatselectedicon.png",
                      height: 3.h)
                      : Image.asset(
                    "assets/images/messagesunselec.png",
                    height: 3.h,
                  ),
                )
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedindex = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  // color: Colors.white,
                  height: 4.h,
                  width: 7.w,
                  child: selectedindex == 1
                      ? Image.asset("assets/images/massmessageselect.png",
                      height: 3.h)
                      : Image.asset("assets/images/massmessageunselect.png",
                      height: 3.h),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedindex = 2;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  // color: Colors.white,
                  height: 4.h,
                  width: 7.w,
                  child: selectedindex == 2
                      ? Image.asset("assets/images/feedselecticon.png",
                      height: 3.h)
                      : Image.asset("assets/images/feedunselecticon.png",
                      height: 3.h),
                )
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedindex = 3;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  // color: Colors.white,
                  height: 4.h,
                  width: 7.w,
                  child: selectedindex == 3
                      ? Image.asset("assets/images/callselecticon.png",
                      height: 3.h)
                      : Image.asset("assets/images/callunselecticon.png",
                      height: 3.h),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> getsharedpreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState((){
      token=sharedPreferences?.getString("token");
    });
    print("Token value:-"+token.toString());
  }
  Future<void> payoutinfo() async {

    Map data={
      "token":token
    };
    print("Data:-"+data.toString());
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(Networks.baseurl + Networks.getpayoutinfo),
        body: data
    );
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-" + jsonResponse.toString());
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Helpingwidgets.failedsnackbar(jsonResponse["message"].toString(), context);
      } else {
        Helpingwidgets.successsnackbar(jsonResponse["message"].toString(), context);
        print("Response:${jsonResponse["message"]}");
        // sharedPreferences!.setBool("twelvehouralert", bool.parse(getpayoutpojo!.data!.elementAt(0).status.toString()));
        // sharedPreferences!.setBool("payoutprocessed", payoutprocessedalert);
        // sharedPreferences!.setBool("endofpayperiod", endofpayalert);
        // Navigator.pop(context);
      }
    } else {
      Helpingwidgets.failedsnackbar(jsonResponse["message"].toString(), context);
    }
  }
}
