import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sextconfidential/LoginScreen.dart';
import 'package:sextconfidential/utils/Appcolors.dart';
import 'package:sextconfidential/utils/Helpingwidgets.dart';
import 'package:sextconfidential/utils/Networks.dart';
import 'package:sextconfidential/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'Bottomnavigation.dart';

class Changepassword extends StatefulWidget{
  @override
  ChangepasswordState createState() => ChangepasswordState();


}

class ChangepasswordState extends State<Changepassword>{
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController newpasswordcontroller=TextEditingController();
  TextEditingController confirmnewpasswordcontroller=TextEditingController();
  GlobalKey<FormState>_key=GlobalKey();
  GlobalKey<State>key=GlobalKey();
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
          onTap: (){
            Navigator.pop(context);
            print("Click back");
          },
          child: Container(
            // color: Colors.white,
              margin: EdgeInsets.only(left: 2.w),
              child: const Icon(Icons.arrow_back_ios_rounded)),
        ),
        title: Text(StringConstants.changepassword,style: TextStyle(
            fontSize: 14.sp,
            fontFamily: "PulpDisplay",
            fontWeight: FontWeight.w500,
            color: Appcolors().whitecolor),),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 3.w,right: 3.w),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Text(StringConstants.deactivatemesaage,style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "PulpDisplay",
                    fontWeight: FontWeight.w500,
                    color: Appcolors().loginhintcolor),),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  child: TextFormField(
                    cursorColor: Appcolors().loginhintcolor,
                    style: TextStyle(color:Appcolors().whitecolor,fontSize: 12.sp,),
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      // suffix: Container(
                      //   child: SvgPicture.asset("assets/images/verifiedicon.svg",width: 5.w,),
                      // ),
                      // suffixIcon: Icon(Icons.verified,color: Appcolors().verifiedicon,),
                      border: InputBorder.none,
                      isDense: true,
                      disabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                      ),focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          color: Appcolors().logintextformborder),
                    ),
                      filled: true,
                      fillColor: Appcolors().backgroundcolor,
                      hintText:
                      StringConstants.oldpassword,
                      hintStyle: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        // fontFamily: 'PulpDisplay',
                        color: Appcolors().loginhintcolor,
                      ),),
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Old Password";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(StringConstants.passwordnote,style: TextStyle(
                    fontSize: 11.sp,
                    // fontFamily: "PulpDisplay",
                    fontWeight: FontWeight.w500,
                    color: Appcolors().whitecolor),),
                SizedBox(
                  height: 4.h,
                ),
                Text(StringConstants.enternewpassword,style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "PulpDisplay",
                    fontWeight: FontWeight.w500,
                    color: Appcolors().loginhintcolor),),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  child: TextFormField(
                    cursorColor: Appcolors().loginhintcolor,
                    style: TextStyle(color:Appcolors().whitecolor,fontSize: 12.sp,),
                    controller: newpasswordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      // prefix: Container(
                      //   child: SvgPicture.asset("assets/images/astrickicon.svg",width: 5.w,),
                      // ),
                      isDense: true,
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
                      ),focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          color: Appcolors().logintextformborder),
                    ),
                      filled: true,
                      fillColor: Appcolors().backgroundcolor,
                      hintText:
                      StringConstants.newpassword,
                      hintStyle: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        // fontFamily: 'PulpDisplay',
                        color: Appcolors().loginhintcolor,
                      ),),
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter new Password";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(StringConstants.confirmnewpassword,style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "PulpDisplay",
                    fontWeight: FontWeight.w500,
                    color: Appcolors().loginhintcolor),),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  child: TextFormField(
                    cursorColor: Appcolors().loginhintcolor,
                    style: TextStyle(color:Appcolors().whitecolor,fontSize: 12.sp,),
                    controller: confirmnewpasswordcontroller,
                    obscureText: true,
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
                      ),focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          color: Appcolors().logintextformborder),
                    ),
                      filled: true,
                      isDense: true,
                      fillColor: Appcolors().backgroundcolor,
                      hintText:
                      StringConstants.confirmnewpassword,
                      hintStyle: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        // fontFamily: 'PulpDisplay',
                        color: Appcolors().loginhintcolor,
                      ),),
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Confirm New Password";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      if(_key.currentState!.validate()){
                        changepassword();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 60.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/btnbackgroundgradient.png"),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(1.5.h),
                      ),
                      child: Text(
                        StringConstants.changepassword,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w500,
                            color: Appcolors().blackcolor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> getsharedpreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState((){
      token=sharedPreferences.getString("token");
    });
    print("Token value:-"+token.toString());
  }
  Future<void> changepassword() async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data ={
      "opassword":passwordcontroller.text,
      "npassword":newpasswordcontroller.text,
      "cpassword":confirmnewpasswordcontroller.text,
      "token":token,
    };
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(Networks.baseurl + Networks.changepassword),
        body: data
    );
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-" + jsonResponse.toString());
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Helpingwidgets.failedsnackbar(jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        Helpingwidgets.successsnackbar(jsonResponse["message"].toString(), context);
        print("Response:${jsonResponse["message"]}");
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginScreen()), (Route<dynamic> route) => false);

      }
    } else {
      Helpingwidgets.failedsnackbar(jsonResponse["message"].toString(), context);
      Navigator.pop(context);

    }
  }


}