import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/ConvertsationScreen.dart';
import '/pojo/Chatuserpojo.dart';
import '/utils/Appcolors.dart';
import '/utils/CustomDropdownButton2.dart';
import '/utils/Helpingwidgets.dart';
import '/utils/Networks.dart';
import '/utils/Sidedrawer.dart';
import '/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Chatusersscreen extends StatefulWidget {
  const Chatusersscreen({super.key});

  @override
  ChatusersscreenState createState() => ChatusersscreenState();
}

class ChatusersscreenState extends State<Chatusersscreen> {
  TextEditingController searchcontroller = TextEditingController();
  List<String> chattype = [
    StringConstants.mostrecent,
    StringConstants.unread,
    StringConstants.recentlyactive,
    StringConstants.newclients,
    StringConstants.favourite,
    StringConstants.credits,
    StringConstants.topspenders,
    StringConstants.hidden,
    StringConstants.unanswered,
  ];
  Chatuserpojo? chatuserpojo;
  Chatuserpojo? searchchatuserpojo;
  String chatselectedtype = StringConstants.mostrecent;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  late String token;
  String usertype = '';
  GlobalKey<State> key = GlobalKey();
  bool? responsestatus = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsharedpreference();
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
      //       onTap: (){
      //         _key.currentState!.openDrawer();
      //       },
      //       child: Center(child: SvgPicture.asset("assets/images/menubtn.svg",))),
      //   title: Text(StringConstants.messages,style: TextStyle(
      //       fontSize: 14.sp,
      //       fontFamily: "PulpDisplay",
      //       fontWeight: FontWeight.w500,
      //       color: Appcolors().whitecolor),),
      // ),
      body: Container(
        padding: EdgeInsets.only(left: 2.w, right: 2.w),
        color: Appcolors().backgroundcolor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 1.h,
            ),
            Container(
              child: TextFormField(
                cursorColor: Appcolors().gradientcolorfirst,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w300,
                  fontFamily: "PulpDisplay",
                  fontSize: 12.sp,
                  color: Appcolors().loginhintcolor,
                ),
                controller: searchcontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: 4.w,
                      right: 4.w,
                    ),
                    child: SvgPicture.asset(
                      "assets/images/searchicon.svg",
                      color: Appcolors().loginhintcolor,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width / 100) * 5,
                      right: (MediaQuery.of(context).size.width / 100) * 5,
                      //  top: (MediaQuery.of(context).size.height / 100) * 1,
                    ),
                  ),
                  // focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Appcolors().bottomnavbgcolor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Appcolors().bottomnavbgcolor),
                  ),
                  filled: true,
                  fillColor: Appcolors().bottomnavbgcolor,
                  hintText: StringConstants.search,
                  hintStyle: TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w300,
                    fontFamily: "PulpDisplay",
                    fontSize: 12.sp,
                    color: Appcolors().loginhintcolor,
                  ),
                ),
                onChanged: (value) {
                  //print("On change");
                  // onSearchTextChanged(value);
                },
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              alignment: Alignment.topLeft,
              width: 50.w,
              child: CustomDropdownButton2(
                hint: chatselectedtype,
                dropdownItems: chattype,
                value: chatselectedtype,
                dropdownWidth: 50.w,
                buttonWidth: 50.w,
                dropdownHeight: 60.h,
                onChanged: (value) {
                  setState(() {
                    chatselectedtype = value!;
                    // switch (chatselectedtype){
                    //   case "Most Recent":
                    chatuserlisting(2);
                    // break;

                    // }
                  });
                },
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            responsestatus!
                ? chatuserpojo!.data!.isNotEmpty
                    ? Expanded(
                        child: AnimationLimiter(
                        child: searchcontroller.text.isEmpty
                            ? ListView.builder(
                                itemCount: chatuserpojo!.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 300),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Column(
                                          children: [
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(2.h),
                                              clipBehavior: Clip.hardEdge,
                                              color:
                                                  Appcolors().backgroundcolor,
                                              child: InkWell(
                                                hoverColor: Appcolors()
                                                    .bottomnavbgcolor,
                                                splashColor: Appcolors()
                                                    .bottomnavbgcolor,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConvertsationScreen(
                                                                userid: chatuserpojo!
                                                                    .data!
                                                                    .elementAt(
                                                                        index)
                                                                    .userid
                                                                    .toString(),
                                                                userimage: chatuserpojo!
                                                                    .data!
                                                                    .elementAt(
                                                                        index)
                                                                    .useriimage
                                                                    .toString(),
                                                                username: usertype ==
                                                                        "user"
                                                                    ? chatuserpojo!
                                                                        .data!
                                                                        .elementAt(
                                                                            index)
                                                                        .usericreateName
                                                                        .toString()
                                                                    : chatuserpojo!
                                                                        .data!
                                                                        .elementAt(
                                                                            index)
                                                                        .useriname
                                                                        .toString(),
                                                              )));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(1.h),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Appcolors()
                                                              .chatuserborder),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.h)),
                                                  width: double.infinity,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 14.w,
                                                        height: 7.h,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              chatuserpojo!
                                                                  .data!
                                                                  .elementAt(
                                                                      index)
                                                                  .useriimage
                                                                  .toString(),
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 14.w,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 7.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Appcolors()
                                                                    .gradientcolorfirst,
                                                              ),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/userprofile.png"))),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      SizedBox(
                                                        width: 72.w,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 1.h,
                                                            ),
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 30.w,
                                                                    child: Text(
                                                                      usertype ==
                                                                              "user"
                                                                          ? chatuserpojo!
                                                                              .data!
                                                                              .elementAt(
                                                                                  index)
                                                                              .usericreateName
                                                                              .toString()
                                                                          : chatuserpojo!
                                                                              .data!
                                                                              .elementAt(index)
                                                                              .useriname
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontSize: 12
                                                                              .sp,
                                                                          fontFamily:
                                                                              "PulpDisplay",
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color:
                                                                              Appcolors().whitecolor),
                                                                    ),
                                                                  ),
                                                                  GradientText(
                                                                    //chatuserpojo!.data!.elementAt(index).lastmessagetime.toString().substring(13,22),
                                                                    chatuserpojo!
                                                                        .data!
                                                                        .elementAt(
                                                                            index)
                                                                        .lastmessagetime
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 10
                                                                            .sp,
                                                                        fontFamily:
                                                                            "PulpDisplay",
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                    gradientType:
                                                                        GradientType
                                                                            .linear,
                                                                    gradientDirection:
                                                                        GradientDirection
                                                                            .ttb,
                                                                    radius: 6,
                                                                    colors: [
                                                                      Appcolors()
                                                                          .gradientcolorfirst,
                                                                      Appcolors()
                                                                          .gradientcolorsecond,
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: 60.w,
                                                                  child: Text(
                                                                    chatuserpojo!.data!.elementAt(index).messageType.toString() ==
                                                                            "jpg"
                                                                        ? "Image"
                                                                        : chatuserpojo!.data!.elementAt(index).messageType.toString() ==
                                                                                "mp4"
                                                                            ? "Video"
                                                                            : chatuserpojo!.data!.elementAt(index).messageType.toString() == "mp3"
                                                                                ? "Audio Message"
                                                                                : chatuserpojo!.data!.elementAt(index).lastmessage.toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 12.sp,
                                                                        // fontFamily: "PulpDisplay",
                                                                        fontWeight: FontWeight.w400,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        color: Appcolors().loginhintcolor),
                                                                  ),
                                                                ),
                                                                chatuserpojo!
                                                                            .data!
                                                                            .elementAt(index)
                                                                            .messagecount
                                                                            .toString() !=
                                                                        "0"
                                                                    ? Container(
                                                                        padding:
                                                                            EdgeInsets.all(1.h),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          gradient: LinearGradient(
                                                                              colors: [
                                                                                Appcolors().gradientcolorfirst,
                                                                                Appcolors().gradientcolorsecond,
                                                                              ],
                                                                              begin: Alignment.topCenter,
                                                                              end: Alignment.bottomCenter,
                                                                              stops: const [0.0, 1.0],
                                                                              tileMode: TileMode.clamp),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          chatuserpojo!
                                                                              .data!
                                                                              .elementAt(index)
                                                                              .messagecount
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 10.sp,
                                                                              fontFamily: "PulpDisplay",
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Appcolors().blackcolor),
                                                                        ),
                                                                      )
                                                                    : const SizedBox()
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1.5.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: searchchatuserpojo!.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 300),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Column(
                                          children: [
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(2.h),
                                              clipBehavior: Clip.hardEdge,
                                              color:
                                                  Appcolors().backgroundcolor,
                                              child: InkWell(
                                                hoverColor: Appcolors()
                                                    .bottomnavbgcolor,
                                                splashColor: Appcolors()
                                                    .bottomnavbgcolor,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConvertsationScreen(
                                                                userid: searchchatuserpojo!
                                                                    .data!
                                                                    .elementAt(
                                                                        index)
                                                                    .userid
                                                                    .toString(),
                                                                userimage: searchchatuserpojo!
                                                                    .data!
                                                                    .elementAt(
                                                                        index)
                                                                    .useriimage
                                                                    .toString(),
                                                                username: searchchatuserpojo!
                                                                    .data!
                                                                    .elementAt(
                                                                        index)
                                                                    .useriname
                                                                    .toString(),
                                                              )));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(1.h),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Appcolors()
                                                              .chatuserborder),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.h)),
                                                  width: double.infinity,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 14.w,
                                                        height: 7.h,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              searchchatuserpojo!
                                                                  .data!
                                                                  .elementAt(
                                                                      index)
                                                                  .useriimage
                                                                  .toString(),
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 14.w,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 7.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Appcolors()
                                                                    .gradientcolorfirst,
                                                              ),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            decoration: const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/userprofile.png"))),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      SizedBox(
                                                        width: 72.w,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 1.h,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: 30.w,
                                                                  child: Text(
                                                                    usertype ==
                                                                            "user"
                                                                        ? chatuserpojo!
                                                                            .data!
                                                                            .elementAt(
                                                                                index)
                                                                            .usericreateName
                                                                            .toString()
                                                                        : searchchatuserpojo!
                                                                            .data!
                                                                            .elementAt(index)
                                                                            .useriname
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 12
                                                                            .sp,
                                                                        fontFamily:
                                                                            "PulpDisplay",
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        color: Appcolors()
                                                                            .whitecolor),
                                                                  ),
                                                                ),
                                                                GradientText(
                                                                  searchchatuserpojo!
                                                                      .data!
                                                                      .elementAt(
                                                                          index)
                                                                      .lastmessagetime
                                                                      .toString()
                                                                      .substring(
                                                                          13,
                                                                          22),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10.sp,
                                                                      fontFamily:
                                                                          "PulpDisplay",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                  gradientType:
                                                                      GradientType
                                                                          .linear,
                                                                  gradientDirection:
                                                                      GradientDirection
                                                                          .ttb,
                                                                  radius: 6,
                                                                  colors: [
                                                                    Appcolors()
                                                                        .gradientcolorfirst,
                                                                    Appcolors()
                                                                        .gradientcolorsecond,
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: 60.w,
                                                                  child: Text(
                                                                    searchchatuserpojo!.data!.elementAt(index).messageType.toString() ==
                                                                            "jpg"
                                                                        ? "Image"
                                                                        : searchchatuserpojo!.data!.elementAt(index).messageType.toString() ==
                                                                                "mp4"
                                                                            ? "Video"
                                                                            : searchchatuserpojo!.data!.elementAt(index).lastmessage.toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 12.sp,
                                                                        // fontFamily: "PulpDisplay",
                                                                        fontWeight: FontWeight.w400,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        color: Appcolors().loginhintcolor),
                                                                  ),
                                                                ),
                                                                searchchatuserpojo!
                                                                            .data!
                                                                            .elementAt(index)
                                                                            .messagecount
                                                                            .toString() !=
                                                                        "0"
                                                                    ? Container(
                                                                        padding:
                                                                            EdgeInsets.all(1.h),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          gradient: LinearGradient(
                                                                              colors: [
                                                                                Appcolors().gradientcolorfirst,
                                                                                Appcolors().gradientcolorsecond,
                                                                              ],
                                                                              begin: Alignment.topCenter,
                                                                              end: Alignment.bottomCenter,
                                                                              stops: const [0.0, 1.0],
                                                                              tileMode: TileMode.clamp),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          searchchatuserpojo!
                                                                              .data!
                                                                              .elementAt(index)
                                                                              .messagecount
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 10.sp,
                                                                              fontFamily: "PulpDisplay",
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Appcolors().blackcolor),
                                                                        ),
                                                                      )
                                                                    : const SizedBox()
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1.5.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ))
                    : Helpingwidgets.emptydatawithoutdivider("No Chat!")
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> getsharedpreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token")!;
      usertype = sharedPreferences.getString("usertype")!.toString(); //
      //usertype = sharedPreferences.getString("type")??'';
      // print("Token value:-" + token);
    });
    //setState(() {

    print("usertype$usertype");
    //});
    //var dateUtc = DateTime.now().toUtc();
    // print("dateUtc: $dateUtc");
    //var dateLocal = dateUtc.toLocal();
    // print("local: $dateLocal");
    chatuserlisting(2);
  }

  Future<void> chatuserlisting(int sorttype) async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "token": token,
      "sort": sorttype.toString(),
    };
    //print("Data:-" + data.toString());
    var jsonResponse;
    var response = await http
        .post(Uri.parse(Networks.baseurl + Networks.chatlist), body: data);
    jsonResponse = json.decode(response.body);
    //print("jsonResponse:-" + jsonResponse.toString());
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        setState(() {
          responsestatus = true;
        });
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
      } else {
        setState(() {
          responsestatus = true;
        });
        //print("Message:-" + jsonResponse["message"].toString());
        chatuserpojo = Chatuserpojo.fromJson(jsonResponse);
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
