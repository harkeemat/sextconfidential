import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sextconfidential/Videoscreen.dart';
import 'package:sextconfidential/pojo/Chatmediapojo.dart';
import 'package:sextconfidential/utils/Appcolors.dart';
import 'package:sextconfidential/utils/Helpingwidgets.dart';
import 'package:sextconfidential/utils/Networks.dart';
import 'package:sextconfidential/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'Bottomnavigation.dart';

class UserprofileScreen extends StatefulWidget{
  String userid,userimage,username;
  UserprofileScreen({super.key,required this.userid,required this.userimage,required this.username});

  @override
  UserprofileScreenState createState() => UserprofileScreenState();

}

class UserprofileScreenState extends State<UserprofileScreen>{

  GlobalKey<State> key = GlobalKey();
  String? token;
  bool responsestatus=false;
  Chatmediapojo? chatmediapojo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsharedpreference();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appcolors().bottomnavbgcolor,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_rounded)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(left: 3.w,right: 3.w),
        color: Appcolors().backgroundcolor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Container(
                  padding: EdgeInsets.only(left: 3.5.w, right: 3.5.w),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Appcolors().profileboxcolor,
                    borderRadius: BorderRadius.circular(10)
                ),
                // height: 40.h,
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 20.w,
                        ),
                        Container(
                          width: 30.w,
                          padding: EdgeInsets.all(0.6.h),
                          decoration:
                          BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.white,
                              gradient: LinearGradient(
                                  colors: [
                                    Appcolors().gradientcolorsecond,
                                    Appcolors().gradientcolorfirst,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight
                              )
                          ),
                          child:

                          CachedNetworkImage(
                            imageUrl:widget.userimage.toString(),
                            imageBuilder: (context,
                                imageProvider) =>
                                Container(
                                  width: 23.w,
                                  alignment: Alignment
                                      .centerLeft,
                                  height: 10.h,
                                  decoration:
                                  BoxDecoration(
                                    shape: BoxShape.circle,
                                    image:
                                    DecorationImage(
                                      image:
                                      imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            placeholder:
                                (context, url) =>
                                Container(
                                  child: Center(
                                    child:
                                    CircularProgressIndicator(strokeWidth: 2,color: Appcolors().backgroundcolor,),
                                  ),
                                ),
                            errorWidget: (context, url, error) => Container(
                              width: 23.w,
                              height: 10.h,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/userprofile.png")
                                  )
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                            width: 20.w,
                            child: FavoriteButton(
                              iconSize: 4.h,
                              valueChanged: (isFavorite) {
                                if(isFavorite){
                                  favourite(1);
                                }else{
                                  favourite(0);
                                }
                                print('Is Favorite $isFavorite');
                              },
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      widget.username.toString(),
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "PulpDisplay",
                          fontWeight: FontWeight.w400,
                          color: Appcolors().whitecolor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Text(
                      StringConstants.onlinenow,
                      style: TextStyle(
                          fontSize: 9.sp,
                          // fontFamily: "PulpDisplay",
                          fontWeight: FontWeight.w500,
                          color: Appcolors().onlinecolor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: (){
                        blockuserdialog(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 5.h,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/btnbackgroundgradient.png"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(1.5.h),
                        ),
                        child: Text(
                          StringConstants.block,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "PulpDisplay",
                              fontWeight: FontWeight.w500,
                              color: Appcolors().blackcolor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap:(){
                            hideuserdialog(context);
              },
                          child: Container(
                            alignment: Alignment.center,
                            height: 5.h,
                            width: 42.w,
                            decoration: BoxDecoration(
                                color: Appcolors().profileboxcolor,
                                borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Appcolors().loginhintcolor)
                            ),
                            child: Text(
                              StringConstants.hide,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "PulpDisplay",
                                  fontWeight: FontWeight.w500,
                                  color: Appcolors().loginhintcolor),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            reportuserdialog(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 5.h,
                            width: 42.w,
                            decoration: BoxDecoration(
                                color: Appcolors().profileboxcolor,
                                borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Appcolors().loginhintcolor)
                            ),
                            child: Text(
                              StringConstants.report,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "PulpDisplay",
                                  fontWeight: FontWeight.w500,
                                  color: Appcolors().loginhintcolor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                StringConstants.media,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "PulpDisplay",
                    fontWeight: FontWeight.w500,
                    color: Appcolors().whitecolor),
              ),
              SizedBox(
                height: 2.h,
              ),
              responsestatus?
              chatmediapojo!.data!.isNotEmpty?
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    // maxCrossAxisExtent: 320,
                      childAspectRatio: 1 / 1,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7, crossAxisCount: 3),
                  itemCount: chatmediapojo!.data!.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return
                      AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 30,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child:
                            chatmediapojo!.data!.elementAt(index).messageType.toString()=="jpg"?
                            GestureDetector(
                              onTap: () {
                                Helpingwidgets().mediaimagedialog(context,chatmediapojo!.data!.elementAt(index).message.toString());
                              },
                              child: Container(
                                child:
                                CachedNetworkImage(
                                  imageUrl:chatmediapojo!.data!.elementAt(index).message.toString(),
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 25.w,
                                    alignment: Alignment.centerLeft,
                                    height: 10.h,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>   Center(
                                    child:CircularProgressIndicator(strokeWidth: 2,color: Appcolors().backgroundcolor,),
                                  ),
                                  // errorWidget: (context, url, error) => errorWidget,
                                ),
                              ),
                            )
                            :
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Videoscreen(videopath: chatmediapojo!.data!.elementAt(index).message.toString())));
                                },
                                child: Container(
                                decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius
                                    .circular(20),
                            image:
                            const DecorationImage(
                                  image:
                                  AssetImage(
                                    "assets/images/videodefaultimg.png",
                                  ),
                                  fit: BoxFit
                                      .fill)),
                        child: Icon(
                          Icons
                                .play_circle_outline_rounded,
                          color: Colors.white,
                          size: 4.h,
                        ),
                      ),
                              ),
                          ),
                        ),
                      );
                  })
              :
                  Helpingwidgets.emptydatawithoutdivider("No Media!")
                  :
                  const SizedBox()
            ],
          ),
        )
      ),

    );
  }
  Future blockuserdialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              backgroundColor: Appcolors().dialogbgcolor,
              //title: Text("Image Picker"),
              content: Container(
                alignment: Alignment.center,
                height: 20.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringConstants.blockdialogmessage,
                      style: TextStyle(
                          fontSize: 14.sp,
                          height: 0.2.h,
                          // fontFamily: "PulpDisplay",
                          fontWeight: FontWeight.w500,
                          color: Appcolors().loginhintcolor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        blockuser();
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Appcolors().deactivatecolor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 40.w,
                          height: 5.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                StringConstants.blockuser,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "PulpDisplay",
                                    fontWeight: FontWeight.w500,
                                    color: Appcolors().whitecolor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        StringConstants.cancel,
                        style: TextStyle(
                            fontSize: 14.sp,
                            height: 0.2.h,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w500,
                            color: Appcolors().whitecolor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
  Future hideuserdialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              backgroundColor: Appcolors().dialogbgcolor,
              //title: Text("Image Picker"),
              content: Container(
                alignment: Alignment.center,
                height: 20.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringConstants.hidedialogmessage,
                      style: TextStyle(
                          fontSize: 14.sp,
                          height: 0.2.h,
                          // fontFamily: "PulpDisplay",
                          fontWeight: FontWeight.w500,
                          color: Appcolors().loginhintcolor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        hideuser();
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Appcolors().deactivatecolor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 40.w,
                          height: 5.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                StringConstants.hideuser,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "PulpDisplay",
                                    fontWeight: FontWeight.w500,
                                    color: Appcolors().whitecolor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        StringConstants.cancel,
                        style: TextStyle(
                            fontSize: 14.sp,
                            height: 0.2.h,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w500,
                            color: Appcolors().whitecolor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
  Future reportuserdialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              backgroundColor: Appcolors().dialogbgcolor,
              //title: Text("Image Picker"),
              content: Container(
                alignment: Alignment.center,
                height: 20.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringConstants.resportdialogmessage,
                      style: TextStyle(
                          fontSize: 14.sp,
                          height: 0.2.h,
                          // fontFamily: "PulpDisplay",
                          fontWeight: FontWeight.w500,
                          color: Appcolors().loginhintcolor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        reportuser();
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Appcolors().deactivatecolor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 40.w,
                          height: 5.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                StringConstants.reportuser,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "PulpDisplay",
                                    fontWeight: FontWeight.w500,
                                    color: Appcolors().whitecolor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        StringConstants.cancel,
                        style: TextStyle(
                            fontSize: 14.sp,
                            height: 0.2.h,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w500,
                            color: Appcolors().whitecolor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
  Future<void> getsharedpreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token")!;
    });
    print("Token value:-$token");
    usermedialisting();
  }

  Future<void> favourite(int status) async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "token": token,
      "userid": widget.userid.toString(),
      "status": status.toString(),
    };
    print("Data:-$data");
    var jsonResponse;
    var response = await http.post(Uri.parse(Networks.baseurl + Networks.favorite), body: data);
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        print("Message:-${jsonResponse["message"]}");
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }
  Future<void> hideuser() async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "token": token,
      "profileid": widget.userid.toString(),
    };
    print("Data:-$data");
    var jsonResponse;
    var response = await http.post(Uri.parse(Networks.baseurl + Networks.chathide), body: data);
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        print("Message:-${jsonResponse["message"]}");
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            const Bottomnavigation()), (Route<dynamic> route) => false);
      }
    } else {
      Navigator.pop(context);
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }
  Future<void> blockuser() async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "token": token,
      "profileid": widget.userid.toString(),
    };
    print("Data:-$data");
    var jsonResponse;
    var response = await http.post(Uri.parse(Networks.baseurl + Networks.chatblock), body: data);
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        print("Message:-${jsonResponse["message"]}");
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            const Bottomnavigation()), (Route<dynamic> route) => false);
      }
    } else {
      Navigator.pop(context);
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }
  Future<void> reportuser() async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "token": token,
      "profileid": widget.userid.toString(),
    };
    print("Data:-$data");
    var jsonResponse;
    var response = await http.post(Uri.parse(Networks.baseurl + Networks.chatreport), body: data);
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        print("Message:-${jsonResponse["message"]}");
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            const Bottomnavigation()), (Route<dynamic> route) => false);
      }
    } else {
      Navigator.pop(context);
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }
  Future<void> usermedialisting() async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "token": token,
      "toid": widget.userid.toString(),
    };
    print("Data:-$data");
    var jsonResponse;
    var response = await http.post(Uri.parse(Networks.baseurl + Networks.chatmedia), body: data);
    jsonResponse = json.decode(response.body);
    print("jsonResponse:-$jsonResponse");
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        setState(() {
          responsestatus = true;
        });
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        setState(() {
          responsestatus = true;
        });
        print("Message:-${jsonResponse["message"]}");
        chatmediapojo = Chatmediapojo.fromJson(jsonResponse);
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      setState(() {
        responsestatus = true;
      });
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }
}