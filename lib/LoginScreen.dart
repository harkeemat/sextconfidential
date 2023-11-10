import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/Bottomnavigation.dart';
import '/Videocallscreen.dart';
import '/pojo/getprofilepojo.dart';
import '/utils/Appcolors.dart';
import '/utils/Helpingwidgets.dart';
import '/utils/Networks.dart';
import '/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  TextEditingController emailcontoller = TextEditingController();
  TextEditingController passwordcontoller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey(); // Create a key
  Getprofilepojo? getprofilepojo;
  bool passwordobsecure = true;
  String? userstatus;
  GlobalKey<State> key = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Appcolors().backgroundcolor,
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(
                    //   height: 2.h,
                    // ),
                    Container(
                      width: double.infinity,
                      height: 30.h,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/loginbgtop.png"),
                              fit: BoxFit.fill)),
                      child: Center(
                          child: Image.asset(
                        "assets/images/logo.png",
                        height: 12.h,
                      )),
                    ),
                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 3.h,
                          ),
                          GradientText(
                            StringConstants.welcome,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500),
                            gradientType: GradientType.linear,
                            gradientDirection: GradientDirection.ttb,
                            radius: 6,
                            colors: [
                              Appcolors().gradientcolorfirst,
                              Appcolors().gradientcolorsecond,
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            StringConstants.logintoyouraccount,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                color: Appcolors().whitecolor),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 3.w, right: 3.w),
                            child: TextFormField(
                              // autovalidateMode: AutovalidateMode.always,
                              cursorColor: Appcolors().loginhintcolor,
                              style: TextStyle(
                                color: Appcolors().whitecolor,
                                fontSize: 12.sp,
                              ),
                              controller: emailcontoller,
                              decoration: InputDecoration(
                                  // prefix: Container(
                                  //   child: SvgPicture.asset("assets/images/astrickicon.svg",width: 5.w,),
                                  // ),
                                  border: InputBorder.none,
                                  // focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Appcolors().logintextformborder),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Appcolors().logintextformborder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Appcolors().logintextformborder),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Appcolors().logintextformborder),
                                  ),
                                  filled: true,
                                  fillColor: Appcolors().backgroundcolor,
                                  hintText:
                                      StringConstants.emailaddressorphoneno,
                                  hintStyle: TextStyle(
                                    decoration: TextDecoration.none,
                                    // fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    // fontFamily: 'PulpDisplay',
                                    color: Appcolors().loginhintcolor,
                                  ),
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.only(left: 4.w, right: 4.w),
                                    child: SvgPicture.asset(
                                        "assets/images/astrickicon.svg"),
                                  )),
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Email or phone no.";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 3.5.w, right: 3.5.w),
                            child: TextFormField(
                              // autovalidateMode: AutovalidateMode.always,
                              style: TextStyle(
                                color: Appcolors().whitecolor,
                                fontSize: 12.sp,
                              ),
                              controller: passwordcontoller,
                              obscureText: passwordobsecure,
                              cursorColor: Appcolors().loginhintcolor,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Appcolors().logintextformborder),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Appcolors().logintextformborder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Appcolors().logintextformborder),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Appcolors().logintextformborder),
                                  ),
                                  filled: true,
                                  fillColor: Appcolors().backgroundcolor,
                                  hintText: StringConstants.password,
                                  hintStyle: TextStyle(
                                    decoration: TextDecoration.none,
                                    // fontWeight: FontWeight.w200,
                                    fontSize: 12.sp,
                                    // fontFamily: 'PulpDisplay',
                                    color: Appcolors().loginhintcolor,
                                  ),
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.only(left: 4.w, right: 4.w),
                                    child: SvgPicture.asset(
                                        "assets/images/lockicon.svg"),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (passwordobsecure == true) {
                                          passwordobsecure = false;
                                        } else {
                                          passwordobsecure = true;
                                        }
                                        print("Visibility true");
                                      });
                                    },
                                    child: Icon(
                                      !passwordobsecure
                                          ? Icons.visibility
                                          : Icons.visibility_off_outlined,
                                      color: Appcolors().loginhintcolor,
                                    ),
                                  )
                                  // suffixIcon: Icon(Icons.visibility)
                                  ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter password";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 3.5.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_key.currentState!.validate()) {
                                login();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              margin:
                                  EdgeInsets.only(left: 3.5.w, right: 3.5.w),
                              height: 6.h,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/btnbackgroundgradient.png"),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(1.5.h),
                              ),
                              child: Text(
                                StringConstants.login,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "PulpDisplay",
                                    fontWeight: FontWeight.w500,
                                    color: Appcolors().blackcolor),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          )),
    );
  }

  Future<void> login() async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "email": emailcontoller.text.trim(),
      "password": passwordcontoller.text.trim(),
    };
    var jsonResponse;
    var response = await http.post(Uri.parse(Networks.baseurl + Networks.login),
        body: data);
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        // ignore: use_build_context_synchronously
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        getprofilepojo = Getprofilepojo.fromJson(jsonResponse);

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            "token", getprofilepojo!.token!.id.toString());
        sharedPreferences.setString(
            "dname",
            getprofilepojo!.token!.dname == null
                ? ""
                : getprofilepojo!.token!.dname.toString());
        sharedPreferences.setString(
            "profilepic",
            getprofilepojo!.token!.image == null
                ? ""
                : getprofilepojo!.token!.image.toString());
        sharedPreferences.setString(
            "usertype",
            getprofilepojo!.token!.type == null
                ? ""
                : getprofilepojo!.token!.type.toString());
        sharedPreferences.setString(
            "stagename", getprofilepojo!.token!.stagename.toString());
        sharedPreferences.setString(
            "bio", getprofilepojo!.token!.bio.toString());
        sharedPreferences.setString(
            "phone", getprofilepojo!.token!.phone.toString());
        sharedPreferences.setString(
            "email", getprofilepojo!.token!.email.toString());
        sharedPreferences.setString(
            "userstatus", getprofilepojo!.token!.showOnline ?? "0");
        sharedPreferences.setBool(
            "phonecall",
            getprofilepojo!.token!.phoneCalls.toString().toLowerCase() == "yes"
                ? true
                : false);
        sharedPreferences.setBool(
            "videocall",
            getprofilepojo!.token!.videoCalls.toString().toLowerCase() == "yes"
                ? true
                : false);
        sharedPreferences.setBool("loginstatus", true);
        String? devicetoken;
        String? devicetype;
        if (Platform.isIOS) {
          devicetoken = await messaging.getAPNSToken();
          devicetype = "ios";
          print("FCMToken $devicetoken");
        } else {
          devicetoken = await messaging.getToken();
          devicetype = "android";
          print("FCMToken $devicetoken");
        }
        //token update after user login
        Map tokenupdate = {
          "token": getprofilepojo!.token!.id.toString(),
          "notification_token": devicetoken,
          "devicetype": devicetype
        };

        await http.post(Uri.parse(Networks.baseurl + Networks.updatetoken),
            body: tokenupdate);

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Bottomnavigation()),
            (Route<dynamic> route) => false);
        // ignore: use_build_context_synchronously
        Helpingwidgets.successsnackbar(
            jsonResponse["message"].toString(), context);
      }
    } else {
      // ignore: use_build_context_synchronously
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }
}
