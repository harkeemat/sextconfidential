import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sextconfidential/Bottomnavigation.dart';
import 'package:sextconfidential/pojo/getprofilepojo.dart';
import 'package:sextconfidential/utils/Appcolors.dart';
import 'package:sextconfidential/utils/Helpingwidgets.dart';
import 'package:sextconfidential/utils/Networks.dart';
import 'package:sextconfidential/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Editprofilescreen extends StatefulWidget {
  @override
  EditprofilescreenState createState() => EditprofilescreenState();
}

class EditprofilescreenState extends State<Editprofilescreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController biocontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  SharedPreferences? sharedPreferences;
  Getprofilepojo? getprofilepojo;
  String? token;
  File? imageFile;
  GlobalKey<FormState>_key=GlobalKey();
  GlobalKey<State>key=GlobalKey();
  String? profilepic;
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
          StringConstants.editprofile,
          style: TextStyle(
              fontSize: 14.sp,
              fontFamily: "PulpDisplay",
              fontWeight: FontWeight.w500,
              color: Appcolors().whitecolor),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(left: 3.w, right: 3.w),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                      width: 30.w,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          imageFile==null?
                          profilepic==null||profilepic==""?
                          Image.asset("assets/images/userprofile.png",height: 10.h,width: 20.w,):
                          Container(
                            width: 30.w,
                            child: CachedNetworkImage(
                              alignment: Alignment.topCenter,
                              imageUrl:
                                  profilepic.toString(),
                              imageBuilder: (context, imageProvider) => Container(
                                width: 30.w,
                                alignment: Alignment.centerLeft,
                                height: 15.h,
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
                                    color: Appcolors().backgroundcolor,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 30.w,
                                height: 15.h,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/userprofile.png")
                                    )
                                ),
                              ),
                            ),
                          )
                          :
                              CircleAvatar(
                                radius: 7.h,
                                backgroundImage: FileImage(imageFile!),
                              )
                          ,
                          GestureDetector(
                            onTap: () {
                              clickphotofromcamera();
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: 1.h, right: 1.w),
                                padding: EdgeInsets.all(0.8.h),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        colors: [
                                          Appcolors().gradientcolorsecond,
                                          Appcolors().gradientcolorfirst,
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight)),
                                child: SvgPicture.asset(
                                  "assets/images/cameraicon.svg",
                                  color: Colors.black,
                                  height: 2.h,
                                  width: 2.w,
                                )),
                          )
                        ],
                      )),
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        StringConstants.name,
                        style: TextStyle(
                            fontSize: 1.7.h,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w400,
                            color: Appcolors().loginhintcolor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    child: TextFormField(
                      cursorColor: Appcolors().loginhintcolor,
                      style: TextStyle(
                        color: Appcolors().whitecolor,
                        fontSize: 12.sp,
                      ),
                      controller: namecontroller,
                      decoration: InputDecoration(
                        // prefix: Container(
                        //   child: SvgPicture.asset("assets/images/astrickicon.svg",width: 5.w,),
                        // ),
                        border: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Appcolors().logintextformborder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              BorderSide(color: Appcolors().logintextformborder),
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: Appcolors().backgroundcolor,
                        hintText: "Elexa Steele",
                        hintStyle: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          // fontFamily: 'PulpDisplay',
                          color: Appcolors().loginhintcolor,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Model Name!";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        StringConstants.bio,
                        style: TextStyle(
                            fontSize: 11.sp,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w400,
                            color: Appcolors().loginhintcolor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 3,
                      cursorColor: Appcolors().loginhintcolor,
                      style: TextStyle(
                        color: Appcolors().whitecolor,
                        fontSize: 12.sp,
                      ),
                      controller: biocontroller,
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
                        isDense: true,
                        filled: true,
                        fillColor: Appcolors().backgroundcolor,
                        hintText:
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy.",
                        hintStyle: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          // fontFamily: 'PulpDisplay',
                          color: Appcolors().loginhintcolor,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return StringConstants.pleaseentermodelbio;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        StringConstants.emailaddress,
                        style: TextStyle(
                            fontSize: 11.sp,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w400,
                            color: Appcolors().loginhintcolor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    child: TextFormField(
                      cursorColor: Appcolors().loginhintcolor,
                      style: TextStyle(
                        color: Appcolors().whitecolor,
                        fontSize: 12.sp,
                      ),
                      readOnly: true,
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        // prefix: Container(
                        //   child: SvgPicture.asset("assets/images/astrickicon.svg",width: 5.w,),
                        // ),
                        isDense: true,
                        border: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              color: Appcolors().logintextformborder),
                        ),
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
                        hintText: "elexasteele@gmail.com",
                        hintStyle: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          // fontFamily: 'PulpDisplay',
                          color: Appcolors().loginhintcolor,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return StringConstants.pleaseenteremailaddress;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        StringConstants.phonenumber,
                        style: TextStyle(
                            fontSize: 11.sp,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w400,
                            color: Appcolors().loginhintcolor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    child: TextFormField(
                      cursorColor: Appcolors().loginhintcolor,
                      style: TextStyle(
                        color: Appcolors().whitecolor,
                        fontSize: 12.sp,
                      ),
                      controller: phonenumbercontroller,
                      decoration: InputDecoration(
                        // suffixIcon: Icon(
                        //   Icons.verified_rounded,
                        //   color: Appcolors().gradientcolorfirst,
                        //   size: 3.h,
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
                        isDense: true,
                        filled: true,
                        fillColor: Appcolors().backgroundcolor,
                        hintText: "+1 2345 7890",
                        hintStyle: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          // fontFamily: 'PulpDisplay',
                          color: Appcolors().loginhintcolor,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return StringConstants.pleaseenterphonenumber;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if(_key.currentState!.validate()){
                          print("Update profile");
                          updateprofile();
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
                ],
              ),
            ),
          )),
    );
  }

  clickphotofromcamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  Future<void> getsharedpreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState((){
      token=sharedPreferences!.getString("token");
      token=sharedPreferences!.getString("token");
      namecontroller.text=sharedPreferences!.getString("stagename")!;
      biocontroller.text=sharedPreferences!.getString("bio")!;
      phonenumbercontroller.text=sharedPreferences!.getString("phone")!;
      emailcontroller.text=sharedPreferences!.getString("email")!;
      profilepic=sharedPreferences!.getString("profilepic")!;
    });
    print("Token value:-"+token.toString());
    print("profilepic value:-"+profilepic.toString());
  }

  Future<void> updateprofile() async {
    Helpingwidgets.showLoadingDialog(context, key);
    var request = http.MultipartRequest('post', Uri.parse(
        Networks.baseurl+Networks.updateprofile),);
    var jsonData = null;
    request.headers["Content-Type"] = "multipart/form-data";
    request.fields["stagename"] = namecontroller.text.trim();
    request.fields["bio"] = biocontroller.text.trim();
    request.fields["email"] = emailcontroller.text.trim();
    request.fields["phone"] = phonenumbercontroller.text.trim();
    request.fields["token"] = token!;
    print("User name:-"+namecontroller.text.trim());
    print("Bio:-"+biocontroller.text.trim());
    print("email:-"+emailcontroller.text.trim());
    print("phone:-"+phonenumbercontroller.text.trim());
    print("token:-"+token.toString());
    // print("Image path:-"+imageFile!.path.toString());
    if(imageFile!=null){
      request.files.add(await http.MultipartFile.fromPath("image", imageFile!.path,
          filename: imageFile!.path),);
    }
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      jsonData = json.decode(value);
      print("Json:-" + jsonData.toString());
      if (response.statusCode == 200) {
        if (jsonData["status"] == false) {
          Helpingwidgets.failedsnackbar(jsonData["message"].toString(), context);
          print("Response:${jsonData["message"]}");
          Navigator.pop(context);
        } else {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              Bottomnavigation()), (Route<dynamic> route) => false);
          Helpingwidgets.successsnackbar("Data Saved!", context);
          getprofilepojo=Getprofilepojo.fromJson(jsonData);
          sharedPreferences!.setString("profilepic", jsonData["data"]["image"]==null?"":jsonData["data"]["image"].toString());
          sharedPreferences!.setString("stagename", jsonData["data"]["stagename"].toString());
          sharedPreferences!.setString("bio", jsonData["data"]["bio"].toString());
          sharedPreferences!.setString("phone", jsonData["data"]["phone"].toString());
          print("Response:${jsonData["message"]}");
          // Navigator.pop(context);
        }
      }
      else {
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(jsonData["message"].toString(), context);
        print("Response:${jsonData["message"]}");
      }
    }
    );
  }
}
