// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '/Feeddetailedpage.dart';
import '/pojo/Feedpostspojo.dart';
import '/utils/Appcolors.dart';
import '/utils/CustomDropdownButton2.dart';
import '/utils/CustomMenu.dart';
import '/utils/Scheduleddropdown.dart';
import '/utils/Unpindropdown.dart';
// import '/utils/CustomMenu.dart';
import '/utils/Helpingwidgets.dart';
import '/utils/Networks.dart';
import '/utils/Sidedrawer.dart';
import '/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sizer/sizer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

import 'ConvertsationScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FeedScreen());
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  TextEditingController messagecontroller = TextEditingController();
  TextEditingController postcontentcontoller =
      TextEditingController(text: "What are you up to tonight?");
  List<String> posttypes = [
    StringConstants.post,
    StringConstants.scheduledpost,
    StringConstants.saveasdraft
  ];
  List<String> postfilters = [
    StringConstants.mostrecent,
    StringConstants.mostread,
    StringConstants.readrate,
    StringConstants.mostunlocks,
    StringConstants.mostearnings,
  ];
  List<String> menuoptions = [
    StringConstants.editpost,
    StringConstants.copylink,
    StringConstants.pinpost,
    StringConstants.deletepost,
  ];
  String? token;
  String? usertype;
  String postselectedvalue = StringConstants.post;
  String selectedmenu = StringConstants.editpost;
  String postfiltervalue = StringConstants.mostrecent;
  bool posttoexplore = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  int? editedpostid;
  File? imageFile;
  int imagecredit = 0;
  Uint8List? thumbnail;
  int selectedposttype = 0;
  GlobalKey<State> key = GlobalKey();
  String? timezone = "HH:MM";
  int postprice = 0;
  String? formattedDate = "YYYY/MM/DD", type = "private";
  int posttype = 0;
  bool responsestatus = false;
  Feedpostspojo? feedpostspojo;
  String? userprofilepic, username;
  int? sorttype = 1;
  //Dynamic Linking
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final String DynamicLink = 'https://sextconfidential.page.link';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsharedpreference();
    _createDynamicLink(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().backgroundcolor,
      key: _key,
      drawer: const Sidedrawer(),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Appcolors().bottomnavbgcolor,
      //   leading: GestureDetector(
      //     onTap: (){
      //       _key.currentState!.openDrawer();
      //     },
      //       child: Center(child: SvgPicture.asset("assets/images/menubtn.svg",))),
      //   title: Text(StringConstants.feed,style: TextStyle(
      //       fontSize: 14.sp,
      //       fontFamily: "PulpDisplay",
      //       fontWeight: FontWeight.w500,
      //       color: Appcolors().whitecolor),),
      // ),
      body: Container(
        padding: EdgeInsets.only(left: 3.w, right: 3.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              usertype != 'user'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringConstants.posttoprofile,
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: "PulpDisplay",
                              fontWeight: FontWeight.w400,
                              color: Appcolors().whitecolor),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        SizedBox(
                          width: 45.w,
                          child: CustomDropdownButton2(
                            hint: "Select Item",
                            dropdownItems: posttypes,
                            value: postselectedvalue,
                            dropdownWidth: 45.w,
                            dropdownHeight: 60.h,
                            buttonWidth: 27.w,
                            onChanged: (value) {
                              setState(() {
                                postselectedvalue = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(
                height: 1.h,
              ),
              usertype != 'user'
                  ? Column(children: [
                      Offstage(
                        offstage:
                            postselectedvalue != StringConstants.scheduledpost,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                StringConstants.selectdateandtime,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    // fontFamily: "PulpDisplay",
                                    fontWeight: FontWeight.w500,
                                    color: Appcolors().loginhintcolor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));
                                if (pickedDate != null) {
                                  print(pickedDate);
                                  formattedDate = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                  print("Selected date:-${formattedDate!}");
                                  timepicker();
                                  setState(() {
                                    // dateInput.text =
                                    //     formattedDate;
                                  });
                                } else {}
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Appcolors().bottomnavbgcolor,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  formattedDate == null
                                      ? "YYYY/MM/DD HH:MM"
                                      : "${formattedDate!} ${timezone!}",
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      // fontFamily: "PulpDisplay",
                                      fontWeight: FontWeight.w500,
                                      color: Appcolors().whitecolor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
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
                          textInputAction: TextInputAction.done,
                          controller: messagecontroller,
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  color: Appcolors().logintextformborder),
                            ),
                            filled: true,
                            fillColor: Appcolors().messageboxbgcolor,
                            hintText: StringConstants.writesomething,
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
                              return "Please enter Message";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (imageFile == null) {
                            addmediadialog(context);
                          }
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: DottedBorder(
                            strokeCap: StrokeCap.round,
                            strokeWidth: 1,
                            dashPattern: const [8, 4],
                            color: Appcolors().gradientcolorfirst,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(15),
                            padding: const EdgeInsets.all(6),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: imageFile == null
                                  ? GestureDetector(
                                      onTap: () {
                                        addmediadialog(context);
                                      },
                                      child: SizedBox(
                                          height: 5.h,
                                          width: double.infinity,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: SvgPicture.asset(
                                                "assets/images/uploadimageicon.svg",
                                                height: 3.h,
                                                width: 3.w,
                                              )),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Text(
                                                StringConstants
                                                    .addphotosorvideo,
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    // fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w500,
                                                    color: Appcolors()
                                                        .loginhintcolor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                // child: Image.file(imageFile!,height:15.h,width:25.w,fit: BoxFit.fill,)),
                                                child: imageFile!.path.substring(
                                                            imageFile!.path
                                                                    .length -
                                                                3,
                                                            imageFile!
                                                                .path.length) ==
                                                        "mp4"
                                                    ? Image.asset(
                                                        "assets/images/thumbnaildefault.png",
                                                        height: 15.h,
                                                        width: 30.w,
                                                        fit: BoxFit.fill,
                                                      )
                                                    // Image.memory(
                                                    //         thumbnail!,
                                                    //         height: 15.h,
                                                    //         width: 25.w,
                                                    //         fit: BoxFit.fill,
                                                    //       )
                                                    : Image.file(
                                                        imageFile!,
                                                        height: 15.h,
                                                        width: 25.w,
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    imageFile = null;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 3, top: 5),
                                                  child: CircleAvatar(
                                                    radius: 1.5.h,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Image.asset(
                                                      "assets/images/crossicon.png",
                                                      height: 1.h,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 4.h,
                                              alignment: Alignment.center,
                                              width: 20.w,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Appcolors()
                                                          .loginhintcolor),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Text(
                                                imagecredit == 0
                                                    ? "Free"
                                                    : imagecredit.toString(),
                                                style: TextStyle(
                                                    fontSize: 8.sp,
                                                    fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Appcolors().whitecolor),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (imagecredit > 0) {
                                                    imagecredit =
                                                        imagecredit - 1;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 20.w),
                                                alignment: Alignment.center,
                                                width: 4.w,
                                                height: 2.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                ),
                                                child: Text(
                                                  "-",
                                                  style: TextStyle(
                                                      fontSize: 8.sp,
                                                      fontFamily: "PulpDisplay",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Appcolors()
                                                          .blackcolor),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  imagecredit = imagecredit + 1;
                                                });
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 20.w),
                                                alignment: Alignment.center,
                                                width: 4.w,
                                                height: 2.h,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/btnbackgroundgradient.png"),
                                                        fit: BoxFit.fill),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  "+",
                                                  style: TextStyle(
                                                      fontSize: 8.sp,
                                                      fontFamily: "PulpDisplay",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Appcolors()
                                                          .blackcolor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (postselectedvalue ==
                              StringConstants.scheduledpost) {
                            if (timezone == "HH:MM" ||
                                formattedDate == "YYYY/MM/DD") {
                              Helpingwidgets.failedsnackbar(
                                  "Choose Schedule date and time!", context);
                            } else if (messagecontroller.text.isEmpty &&
                                imageFile == null) {
                              Helpingwidgets.failedsnackbar(
                                  "Enter description or Upload image", context);
                            } else {
                              postfeed();
                            }
                          } else {
                            postfeed();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/btnbackgroundgradient.png"),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(10)),
                          height: 5.h,
                          child: Text(
                            postselectedvalue == StringConstants.scheduledpost
                                ? StringConstants.scheduledpost
                                : postselectedvalue ==
                                        StringConstants.saveasdraft
                                    ? StringConstants.saveasdraft
                                    : "Post Feed",
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w400,
                                color: Appcolors().backgroundcolor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ])
                  : SizedBox(),
              Container(
                decoration: BoxDecoration(
                    color: Appcolors().bottomnavbgcolor,
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                height: 5.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedposttype = 0;
                        });
                      },
                      child: GradientText(
                        "${StringConstants.posted}(${responsestatus == false ? "0" : feedpostspojo!.message!.post!.length})",
                        style: TextStyle(
                            fontSize: 9.sp,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w400),
                        gradientType: GradientType.linear,
                        gradientDirection: GradientDirection.ttb,
                        radius: 6,
                        colors: [
                          selectedposttype == 0
                              ? Appcolors().gradientcolorfirst
                              : Appcolors().loginhintcolor,
                          selectedposttype == 0
                              ? Appcolors().gradientcolorsecond
                              : Appcolors().loginhintcolor,
                        ],
                      ),
                    ),
                    Container(
                        height: 6.h,
                        width: 1.5,
                        color: Appcolors().dividercolor),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedposttype = 1;
                        });
                      },
                      child: GradientText(
                        "${StringConstants.scheduled}(${responsestatus == false ? "0" : feedpostspojo!.message!.schedule!.length})",
                        style: TextStyle(
                            fontSize: 9.sp,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w400),
                        gradientType: GradientType.linear,
                        gradientDirection: GradientDirection.ttb,
                        radius: 6,
                        colors: [
                          selectedposttype == 1
                              ? Appcolors().gradientcolorfirst
                              : Appcolors().loginhintcolor,
                          selectedposttype == 1
                              ? Appcolors().gradientcolorsecond
                              : Appcolors().loginhintcolor,
                        ],
                      ),
                    ),
                    Container(
                        height: 6.h,
                        width: 1.5,
                        color: Appcolors().dividercolor),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedposttype = 2;
                        });
                      },
                      child: GradientText(
                        "${StringConstants.drafts}(${responsestatus == false ? "0" : feedpostspojo!.message!.saveDraft!.length})",
                        style: TextStyle(
                            fontSize: 9.sp,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w400),
                        gradientType: GradientType.linear,
                        gradientDirection: GradientDirection.ttb,
                        radius: 6,
                        colors: [
                          selectedposttype == 2
                              ? Appcolors().gradientcolorfirst
                              : Appcolors().loginhintcolor,
                          selectedposttype == 2
                              ? Appcolors().gradientcolorsecond
                              : Appcolors().loginhintcolor,
                        ],
                      ),
                    ),
                    // Container(
                    //     height: 6.h,
                    //     width: 1.5,
                    //     color: Appcolors().dividercolor),
                    // InkWell(
                    //   onTap: () {
                    //     setState(() {
                    //       selectedposttype = 3;
                    //     });
                    //   },
                    //   child:
                    //   GradientText(
                    //     "${StringConstants.tagged}(250)",
                    //     style: TextStyle(
                    //         fontSize: 9.sp,
                    //         // fontFamily: "PulpDisplay",
                    //         fontWeight: FontWeight.w400),
                    //     gradientType: GradientType.linear,
                    //     gradientDirection: GradientDirection.ttb,
                    //     radius: 6,
                    //     colors: [
                    //       selectedposttype==3?Appcolors().gradientcolorfirst:Appcolors().loginhintcolor,
                    //       selectedposttype==3?Appcolors().gradientcolorsecond:Appcolors().loginhintcolor,
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              selectedposttype == 0
                  ? SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 45.w,
                            child: CustomDropdownButton2(
                              hint: "Select Item",
                              dropdownItems: postfilters,
                              value: postfiltervalue,
                              dropdownWidth: 45.w,
                              dropdownHeight: 60.h,
                              buttonWidth: 27.w,
                              onChanged: (value) {
                                setState(() {
                                  postfiltervalue = value!;
                                  switch (postfiltervalue) {
                                    case "Most Recent":
                                      feedlisting(1);
                                      break;
                                    case "Most read":
                                      feedlisting(2);
                                      break;
                                    case "Read Rate":
                                      feedlisting(3);
                                      break;
                                    case "Most Unlocks":
                                      feedlisting(4);
                                      break;
                                    case "Most Earnings":
                                      feedlisting(5);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: 1.h,
              ),
              responsestatus
                  ? selectedposttype == 0
                      ? postedlistview()
                      : selectedposttype == 1
                          ? scheduledlistview()
                          : savetodraft()
                  : const SizedBox()
              // : Helpingwidgets().customloader()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showdeletealert(BuildContext context, String postid, int index) {
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
                height: 25.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringConstants.deletediologmessage,
                      style: TextStyle(
                          fontSize: 14.sp,
                          height: 0.2.h,
                          // fontFamily: "PulpDisplay",
                          fontWeight: FontWeight.w500,
                          color: Appcolors().loginhintcolor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        deletepost(postid, index);
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
                              SvgPicture.asset(
                                "assets/images/deleteicon.svg",
                                height: 3.h,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                StringConstants.deletepost,
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
                      height: 2.h,
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

  Future<void> addmediadialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            backgroundColor: Colors.transparent,
            //title: Text("Image Picker"),
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: 80.w,
                        // margin: EdgeInsets.only(left: 2.w, right: 2.w,bottom: 1.h),
                        alignment: Alignment.center,
                        height: 10.h,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/btnbackgroundgradient.png",
                              ),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _getFromGallery();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/documentupload.svg",
                                    height: 3.h,
                                    width: 3.w,
                                    color: Appcolors().bottomnavbgcolor,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    StringConstants.choosefile,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        // fontFamily: "PulpDisplay",
                                        fontWeight: FontWeight.w500,
                                        color: Appcolors().bottomnavbgcolor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                clickphotofromcamera();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/cameraicon.svg",
                                    height: 3.h,
                                    width: 3.w,
                                    color: Appcolors().bottomnavbgcolor,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    StringConstants.takephoto,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        // fontFamily: "PulpDisplay",
                                        fontWeight: FontWeight.w500,
                                        color: Appcolors().bottomnavbgcolor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                pickVideo();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/videoicon.svg",
                                    height: 3.h,
                                    width: 3.w,
                                    color: Appcolors().bottomnavbgcolor,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    StringConstants.recordvideo,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        // fontFamily: "PulpDisplay",
                                        fontWeight: FontWeight.w500,
                                        color: Appcolors().bottomnavbgcolor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 1.5.h,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/images/crossicon.png",
                          height: 1.5.h,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  _getFromGallery() async {
    Navigator.pop(context);
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 700,
      maxHeight: 700,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  clickphotofromcamera() async {
    Navigator.pop(context);
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 700,
      maxHeight: 700,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> pickVideo() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      createthumbnail();
      // print("Video path:-${pickedFile.path}");
    }

    return;
  }

  Future<void> getsharedpreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token");
      userprofilepic = sharedPreferences.getString("profilepic");
      username = sharedPreferences.getString("stagename");
      usertype = sharedPreferences.getString("usertype")!.toString();
    });

    feedlisting(sorttype!);
  }

  Future<void> postfeed() async {
    Helpingwidgets.showLoadingDialog(context, key);
    var request = http.MultipartRequest(
      'post',
      Uri.parse(Networks.baseurl + Networks.newpost),
    );
    var jsonData;
    request.headers["Content-Type"] = "multipart/form-data";
    request.fields["text"] = messagecontroller.text.trim();
    request.fields["token"] = token!;
    request.fields["type"] = imagecredit == 0 ? "public" : "private";
    request.fields["price"] = imagecredit.toString();
    request.fields["posttype"] =
        postselectedvalue == StringConstants.scheduledpost
            ? "Schedule"
            : postselectedvalue == StringConstants.saveasdraft
                ? "Save Draft"
                : "Post";
    request.fields["scdate"] =
        postselectedvalue == StringConstants.scheduledpost
            ? "${formattedDate!} $timezone"
            : "";

    // print("Image path:-"+imageFile!.path.toString());
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("file", imageFile!.path,
            filename: imageFile!.path),
      );
    }
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      jsonData = json.decode(value);

      if (response.statusCode == 200) {
        if (jsonData["status"] == false) {
          Helpingwidgets.failedsnackbar(
              jsonData["message"].toString(), context);

          Navigator.pop(context);
        } else {
          setState(() {
            imageFile = null;
          });
          messagecontroller.clear();
          Helpingwidgets.successsnackbar(
              jsonData["message"].toString(), context);

          feedlisting(sorttype!);
          Navigator.pop(context);
        }
      } else {
        Helpingwidgets.failedsnackbar(jsonData["message"].toString(), context);

        Navigator.pop(context);
      }
    });
  }

  Future<void> feedlisting(int sorttype) async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "token": token,
      "sort": sorttype.toString(),
    };

    var jsonResponse;
    var response = await http
        .post(Uri.parse(Networks.baseurl + Networks.myposts), body: data);
    jsonResponse = json.decode(response.body);

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

        feedpostspojo = Feedpostspojo.fromJson(jsonResponse);
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

  Future<void> deletepost(String postid, int index) async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "postid": postid.toString(),
    };

    var jsonResponse;
    var response = await http
        .post(Uri.parse(Networks.baseurl + Networks.deletepost), body: data);
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        Helpingwidgets.successsnackbar(
            jsonResponse["message"].toString(), context);

        feedlisting(0);
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }

  Future<void> pinpost(String postid, int index, bool status) async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "postid": postid.toString(),
      "status": status.toString(),
    };

    var jsonResponse;
    var response = await http
        .post(Uri.parse(Networks.baseurl + Networks.pinposts), body: data);
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        feedlisting(0);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }

  Future<void> editpost(String postid, int index, String postcontent) async {
    Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "postid": postid.toString(),
      "text": postcontent.toString(),
    };
    var jsonResponse;
    var response = await http
        .post(Uri.parse(Networks.baseurl + Networks.updatepost), body: data);
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        // Helpingwidgets.successsnackbar(
        //     jsonResponse["message"].toString(), context);

        // feedpostspojo!.message!.post!.elementAt(index).="true";
        feedlisting(0);
        setState(() {
          editedpostid = null;
        });
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }

  Future<void> createthumbnail() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: imageFile!.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          400, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    setState(() {
      thumbnail = uint8list;
    });
  }

  Future<void> timepicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      //output 10:51 PM
      DateTime parsedTime =
          DateFormat.jm().parse(pickedTime.format(context).toString());
      //converting to DateTime so that we can further format on different pattern.
      //output 1970-01-01 22:53:00.000
      // String formattedTime1 =
      // DateFormat('HH:mma')
      //     .format(parsedTime());

      // //DateFormat() is from intl package, you can format the time on any pattern you need.
      setState(() {
        timezone = DateFormat('HH:mm').format(parsedTime);
        // timezone2=formattedTime1;
        // timeinput1.text =DateFormat('HH:mm').format(parsedTime); //set the value of text field.
      });
    } else {
      print("Time is not selected");
    }
  }

  Widget postedlistview() {
    return feedpostspojo!.message!.post!.isNotEmpty
        ? AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedpostspojo!.message!.post!.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConvertsationScreen(
                                            userid: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .id
                                                .toString(),
                                            userimage: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .url
                                                .toString(),
                                            username: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .stagename
                                                .toString(),
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.5.h),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Appcolors().chatuserborder),
                                  borderRadius: BorderRadius.circular(2.h)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 4.5.h,
                                            width: 15.w,
                                            child: CachedNetworkImage(
                                              imageUrl: feedpostspojo!
                                                  .message!.post!
                                                  .elementAt(index)
                                                  .image
                                                  .toString(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 15.w,
                                                alignment: Alignment.centerLeft,
                                                height: 4.5.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
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
                                              // errorWidget: (context, url, error) => errorWidget,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                feedpostspojo!.message!.post!
                                                    .elementAt(index)
                                                    .stagename
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Appcolors().whitecolor),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                feedpostspojo!.message!.post!
                                                    .elementAt(index)
                                                    .ago
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    // fontFamily: "PulpDisplay",
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w400,
                                                    color: Appcolors()
                                                        .loginhintcolor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Offstage(
                                            offstage: feedpostspojo!
                                                    .message!.post!
                                                    .elementAt(index)
                                                    .pinned
                                                    .toString() !=
                                                "true",
                                            child: pinnedpost(),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: feedpostspojo!.message!.post!
                                                        .elementAt(index)
                                                        .pinned
                                                        .toString() ==
                                                    "true"
                                                ? DropdownButton2(
                                                    customButton: Image.asset(
                                                      "assets/images/menubtn.png",
                                                      height: 4.h,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    items: [
                                                      ...UnpinMenuItems
                                                          .unpinfirstItems
                                                          .map(
                                                        (item) => DropdownMenuItem<
                                                            UnpinCustomMenuItem>(
                                                          value: item,
                                                          child: UnpinMenuItems
                                                              .buildItem(item),
                                                        ),
                                                      ),
                                                      const DropdownMenuItem<
                                                              Divider>(
                                                          enabled: false,
                                                          child: Divider()),
                                                      ...UnpinMenuItems
                                                          .unpinsecondItems
                                                          .map(
                                                        (item) => DropdownMenuItem<
                                                            UnpinCustomMenuItem>(
                                                          value: item,
                                                          child: UnpinMenuItems
                                                              .buildItem(item),
                                                        ),
                                                      ),
                                                    ],
                                                    onChanged: (value) {
                                                      UnpinMenuItems.onChanged(
                                                          context,
                                                          value
                                                              as UnpinCustomMenuItem);
                                                      print(
                                                          "Value:-${value.text}");
                                                      if (value.text ==
                                                          StringConstants
                                                              .editpost) {
                                                        setState(() {
                                                          editedpostid = index;
                                                          postcontentcontoller
                                                                  .text =
                                                              feedpostspojo!
                                                                  .message!
                                                                  .post!
                                                                  .elementAt(
                                                                      index)
                                                                  .text
                                                                  .toString();
                                                        });
                                                      } else if (value.text ==
                                                          StringConstants
                                                              .deletepost) {
                                                        showdeletealert(
                                                            context,
                                                            feedpostspojo!
                                                                .message!.post!
                                                                .elementAt(
                                                                    index)
                                                                .id
                                                                .toString(),
                                                            index);
                                                      } else if (value.text ==
                                                          StringConstants
                                                              .pinpost) {
                                                        pinpost(
                                                            feedpostspojo!
                                                                .message!.post!
                                                                .elementAt(
                                                                    index)
                                                                .id
                                                                .toString(),
                                                            index,
                                                            true);
                                                      } else if (value.text ==
                                                          StringConstants
                                                              .unpinpost) {
                                                        pinpost(
                                                            feedpostspojo!
                                                                .message!.post!
                                                                .elementAt(
                                                                    index)
                                                                .id
                                                                .toString(),
                                                            index,
                                                            false);
                                                      } else {}
                                                    },
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      width: 160,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Appcolors()
                                                            .bottomnavbgcolor,
                                                      ),
                                                      elevation: 8,
                                                      offset:
                                                          const Offset(0, 8),
                                                    ),
                                                    menuItemStyleData:
                                                        MenuItemStyleData(
                                                      customHeights: [
                                                        ...List<double>.filled(
                                                            UnpinMenuItems
                                                                .unpinfirstItems
                                                                .length,
                                                            35),
                                                        8,
                                                        ...List<double>.filled(
                                                            UnpinMenuItems
                                                                .unpinsecondItems
                                                                .length,
                                                            48),
                                                      ],
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16,
                                                              right: 16),
                                                    ),
                                                  )
                                                : DropdownButton2(
                                                    customButton: Image.asset(
                                                      "assets/images/menubtn.png",
                                                      height: 4.h,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    items: [
                                                      ...MenuItems.firstItems
                                                          .map(
                                                        (item) =>
                                                            DropdownMenuItem<
                                                                CustomMenuItem>(
                                                          value: item,
                                                          child: MenuItems
                                                              .buildItem(item),
                                                        ),
                                                      ),
                                                      const DropdownMenuItem<
                                                              Divider>(
                                                          enabled: false,
                                                          child: Divider()),
                                                      // ...MenuItems.secondItems.map(
                                                      //   (item) => DropdownMenuItem<
                                                      //       CustomMenuItem>(
                                                      //     value: item,
                                                      //     child:
                                                      //         MenuItems.buildItem(item),
                                                      //   ),
                                                      // ),
                                                    ],
                                                    onChanged: (value) {
                                                      MenuItems.onChanged(
                                                          context,
                                                          value
                                                              as CustomMenuItem);
                                                      print("Value:-$value");
                                                      if (value.text ==
                                                          StringConstants
                                                              .editpost) {
                                                        setState(() {
                                                          editedpostid = index;
                                                          postcontentcontoller
                                                                  .text =
                                                              feedpostspojo!
                                                                  .message!
                                                                  .post!
                                                                  .elementAt(
                                                                      index)
                                                                  .text
                                                                  .toString();
                                                        });
                                                      } else if (value.text ==
                                                          StringConstants
                                                              .deletepost) {
                                                        showdeletealert(
                                                            context,
                                                            feedpostspojo!
                                                                .message!.post!
                                                                .elementAt(
                                                                    index)
                                                                .id
                                                                .toString(),
                                                            index);
                                                      } else if (value.text ==
                                                          StringConstants
                                                              .pinpost) {
                                                        pinpost(
                                                            feedpostspojo!
                                                                .message!.post!
                                                                .elementAt(
                                                                    index)
                                                                .id
                                                                .toString(),
                                                            index,
                                                            true);
                                                      } else if (value.text ==
                                                          StringConstants
                                                              .unpinpost) {
                                                        pinpost(
                                                            feedpostspojo!
                                                                .message!.post!
                                                                .elementAt(
                                                                    index)
                                                                .id
                                                                .toString(),
                                                            index,
                                                            false);
                                                      } else {}
                                                    },
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      width: 160,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Appcolors()
                                                            .bottomnavbgcolor,
                                                      ),
                                                      elevation: 8,
                                                      offset:
                                                          const Offset(0, 8),
                                                    ),
                                                    menuItemStyleData:
                                                        MenuItemStyleData(
                                                      customHeights: [
                                                        ...List<double>.filled(
                                                            MenuItems.firstItems
                                                                .length,
                                                            35),
                                                        8,
                                                        ...List<double>.filled(
                                                            MenuItems
                                                                .secondItems
                                                                .length,
                                                            48),
                                                      ],
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16,
                                                              right: 16),
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  Offstage(
                                    offstage: feedpostspojo!.message!.post!
                                            .elementAt(index)
                                            .url ==
                                        "",
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Feeddetailedpage(
                                                      type: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .filetype
                                                          .toString(),
                                                      url: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .url
                                                          .toString(),
                                                      ago: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .ago
                                                          .toString(),
                                                      text: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .text,
                                                      likes: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .likes
                                                          .toString(),
                                                      views: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .views
                                                          .toString(),
                                                      unlocks: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .unlocked
                                                          .toString(),
                                                      posttype: 0,
                                                      pinstatus: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .pinned
                                                          .toString(),
                                                      postid: feedpostspojo!
                                                          .message!.post!
                                                          .elementAt(index)
                                                          .id
                                                          .toString(),
                                                    )));
                                      },
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 30.h,
                                          child: feedpostspojo!.message!.post!
                                                      .elementAt(index)
                                                      .filetype ==
                                                  "jpg"
                                              ? CachedNetworkImage(
                                                  imageUrl: feedpostspojo!
                                                      .message!.post!
                                                      .elementAt(index)
                                                      .url
                                                      .toString(),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: 15.w,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 4.5.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
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
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    width: 15.w,
                                                    height: 4.5.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/imageplaceholder.png"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                )
                                              : feedpostspojo!.message!.post!
                                                          .elementAt(index)
                                                          .filetype ==
                                                      "mp4"
                                                  ? Container(
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
                                                        size: 6.h,
                                                      ),
                                                    )
                                                  : const SizedBox()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Offstage(
                                      offstage: feedpostspojo!.message!.post!
                                              .elementAt(index)
                                              .text ==
                                          null,
                                      child: Column(
                                        children: [
                                          editedpostid != index
                                              ? Text(
                                                  feedpostspojo!.message!.post!
                                                      .elementAt(index)
                                                      .text
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      // fontFamily: "PulpDisplay",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Appcolors()
                                                          .whitecolor),
                                                  textAlign: TextAlign.start,
                                                )
                                              : Container(
                                                  child: Column(
                                                  children: [
                                                    TextFormField(
                                                      minLines: 3,
                                                      maxLines: 3,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      cursorColor: Appcolors()
                                                          .loginhintcolor,
                                                      style: TextStyle(
                                                        color: Appcolors()
                                                            .whitecolor,
                                                        fontSize: 12.sp,
                                                      ),
                                                      controller:
                                                          postcontentcontoller,
                                                      decoration:
                                                          InputDecoration(
                                                        // prefix: Container(
                                                        //   child: SvgPicture.asset("assets/images/astrickicon.svg",width: 5.w,),
                                                        // ),
                                                        border:
                                                            InputBorder.none,
                                                        // focusedBorder: InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide: BorderSide(
                                                              color: Appcolors()
                                                                  .logintextformborder),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide: BorderSide(
                                                              color: Appcolors()
                                                                  .logintextformborder),
                                                        ),
                                                        filled: true,
                                                        isDense: true,
                                                        fillColor: Appcolors()
                                                            .messageboxbgcolor,
                                                        hintText:
                                                            StringConstants
                                                                .writesomething,
                                                        hintStyle: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12.sp,
                                                          // fontFamily: 'PulpDisplay',
                                                          color: Appcolors()
                                                              .loginhintcolor,
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Please enter Message";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            editpost(
                                                                feedpostspojo!
                                                                    .message!
                                                                    .post!
                                                                    .elementAt(
                                                                        index)
                                                                    .id
                                                                    .toString(),
                                                                index,
                                                                postcontentcontoller
                                                                    .text
                                                                    .toString());
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 30.w,
                                                            decoration: BoxDecoration(
                                                                image: const DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/btnbackgroundgradient.png"),
                                                                    fit: BoxFit
                                                                        .fill),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            height: 5.h,
                                                            child: Text(
                                                              StringConstants
                                                                  .update,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontFamily:
                                                                      "PulpDisplay",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Appcolors()
                                                                      .backgroundcolor),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              editedpostid =
                                                                  null;
                                                            });
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 40.w,
                                                            height: 5.h,
                                                            child: Text(
                                                              StringConstants
                                                                  .cancel,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontFamily:
                                                                      "PulpDisplay",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Appcolors()
                                                                      .whitecolor),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 75.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/images/likeicon.svg"),
                                              Text(
                                                feedpostspojo!.message!.post!
                                                    .elementAt(index)
                                                    .likes
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    // fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w600,
                                                    color: Appcolors()
                                                        .loginhintcolor),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/images/viewsicon.svg"),
                                              Text(
                                                feedpostspojo!.message!.post!
                                                    .elementAt(index)
                                                    .views
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    // fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w600,
                                                    color: Appcolors()
                                                        .loginhintcolor),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/images/unlockicon.svg"),
                                              Text(
                                                feedpostspojo!.message!.post!
                                                    .elementAt(index)
                                                    .unlocked
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    // fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w600,
                                                    color: Appcolors()
                                                        .loginhintcolor),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                ],
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
          )
        : emptydata();
  }

  Widget scheduledlistview() {
    return feedpostspojo!.message!.schedule!.isNotEmpty
        ? AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedpostspojo!.message!.schedule!.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConvertsationScreen(
                                            userid: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .id
                                                .toString(),
                                            userimage: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .url
                                                .toString(),
                                            username: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .stagename
                                                .toString(),
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.5.h),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Appcolors().chatuserborder),
                                  borderRadius: BorderRadius.circular(2.h)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 4.5.h,
                                            width: 15.w,
                                            child: CachedNetworkImage(
                                              imageUrl: feedpostspojo!
                                                  .message!.post!
                                                  .elementAt(index)
                                                  .image
                                                  .toString(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 15.w,
                                                alignment: Alignment.centerLeft,
                                                height: 4.5.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                width: 15.w,
                                                height: 4.5.h,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    shape: BoxShape.circle,
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/userprofile.png"),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                feedpostspojo!
                                                    .message!.schedule!
                                                    .elementAt(index)
                                                    .stagename
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Appcolors().whitecolor),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                feedpostspojo!
                                                    .message!.schedule!
                                                    .elementAt(index)
                                                    .ago
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    // fontFamily: "PulpDisplay",
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w400,
                                                    color: Appcolors()
                                                        .loginhintcolor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          customButton: Image.asset(
                                            "assets/images/menubtn.png",
                                            height: 4.h,
                                            fit: BoxFit.fill,
                                          ),
                                          items: [
                                            ...ScheduledMenuItems
                                                .schedulefirstItems
                                                .map(
                                              (item) => DropdownMenuItem<
                                                  ScheduledCustomMenuItem>(
                                                value: item,
                                                child: ScheduledMenuItems
                                                    .buildItem(item),
                                              ),
                                            ),
                                            const DropdownMenuItem<Divider>(
                                                enabled: false,
                                                child: Divider()),
                                            ...ScheduledMenuItems
                                                .schedulesecondItems
                                                .map(
                                              (item) => DropdownMenuItem<
                                                  ScheduledCustomMenuItem>(
                                                value: item,
                                                child: ScheduledMenuItems
                                                    .buildItem(item),
                                              ),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            ScheduledMenuItems.onChanged(
                                                context,
                                                value
                                                    as ScheduledCustomMenuItem);
                                            print("Value:-${value.text}");
                                            if (value.text ==
                                                StringConstants.editpost) {
                                              setState(() {
                                                editedpostid = index;
                                                postcontentcontoller.text =
                                                    feedpostspojo!
                                                        .message!.post!
                                                        .elementAt(index)
                                                        .text
                                                        .toString();
                                              });
                                            } else {
                                              showdeletealert(
                                                  context,
                                                  feedpostspojo!.message!.post!
                                                      .elementAt(index)
                                                      .id
                                                      .toString(),
                                                  index);
                                            }
                                          },
                                          dropdownStyleData: DropdownStyleData(
                                            width: 160,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Appcolors().bottomnavbgcolor,
                                            ),
                                            elevation: 8,
                                            offset: const Offset(0, 8),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            customHeights: [
                                              ...List<double>.filled(
                                                  ScheduledMenuItems
                                                      .schedulefirstItems
                                                      .length,
                                                  35),
                                              8,
                                              ...List<double>.filled(
                                                  ScheduledMenuItems
                                                      .schedulesecondItems
                                                      .length,
                                                  48),
                                            ],
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  Offstage(
                                    offstage: feedpostspojo!.message!.schedule!
                                            .elementAt(index)
                                            .url ==
                                        "",
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Feeddetailedpage(
                                                      type: feedpostspojo!
                                                          .message!.schedule!
                                                          .elementAt(index)
                                                          .filetype
                                                          .toString(),
                                                      url: feedpostspojo!
                                                          .message!.schedule!
                                                          .elementAt(index)
                                                          .url
                                                          .toString(),
                                                      ago: feedpostspojo!
                                                          .message!.schedule!
                                                          .elementAt(index)
                                                          .ago
                                                          .toString(),
                                                      text: feedpostspojo!
                                                          .message!.schedule!
                                                          .elementAt(index)
                                                          .text,
                                                      likes: feedpostspojo!
                                                          .message!.schedule!
                                                          .elementAt(index)
                                                          .likes
                                                          .toString(),
                                                      views: feedpostspojo!
                                                          .message!.schedule!
                                                          .elementAt(index)
                                                          .views
                                                          .toString(),
                                                      unlocks: "",
                                                      posttype: 1,
                                                      pinstatus: "",
                                                      postid: feedpostspojo!
                                                          .message!.schedule!
                                                          .elementAt(index)
                                                          .id
                                                          .toString(),
                                                    )));
                                      },
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 30.h,
                                          child: feedpostspojo!
                                                      .message!.schedule!
                                                      .elementAt(index)
                                                      .filetype ==
                                                  "jpg"
                                              ? CachedNetworkImage(
                                                  imageUrl: feedpostspojo!
                                                      .message!.schedule!
                                                      .elementAt(index)
                                                      .url
                                                      .toString(),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: 15.w,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 4.5.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
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
                                                  // errorWidget: (context, url, error) => errorWidget,
                                                )
                                              : feedpostspojo!
                                                          .message!.schedule!
                                                          .elementAt(index)
                                                          .filetype ==
                                                      "mp4"
                                                  ? Container(
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
                                                        size: 6.h,
                                                      ),
                                                    )
                                                  : const SizedBox()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Offstage(
                                      offstage: feedpostspojo!
                                              .message!.schedule!
                                              .elementAt(index)
                                              .text ==
                                          null,
                                      child: Column(
                                        children: [
                                          editedpostid != index
                                              ? Text(
                                                  feedpostspojo!
                                                      .message!.schedule!
                                                      .elementAt(index)
                                                      .text
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      // fontFamily: "PulpDisplay",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Appcolors()
                                                          .whitecolor),
                                                  textAlign: TextAlign.start,
                                                )
                                              : Container(
                                                  child: Column(
                                                  children: [
                                                    TextFormField(
                                                      minLines: 3,
                                                      maxLines: 3,
                                                      cursorColor: Appcolors()
                                                          .loginhintcolor,
                                                      style: TextStyle(
                                                        color: Appcolors()
                                                            .whitecolor,
                                                        fontSize: 12.sp,
                                                      ),
                                                      controller:
                                                          postcontentcontoller,
                                                      decoration:
                                                          InputDecoration(
                                                        // prefix: Container(
                                                        //   child: SvgPicture.asset("assets/images/astrickicon.svg",width: 5.w,),
                                                        // ),
                                                        border:
                                                            InputBorder.none,
                                                        // focusedBorder: InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide: BorderSide(
                                                              color: Appcolors()
                                                                  .logintextformborder),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide: BorderSide(
                                                              color: Appcolors()
                                                                  .logintextformborder),
                                                        ),
                                                        filled: true,
                                                        isDense: true,
                                                        fillColor: Appcolors()
                                                            .messageboxbgcolor,
                                                        hintText:
                                                            StringConstants
                                                                .writesomething,
                                                        hintStyle: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12.sp,
                                                          // fontFamily: 'PulpDisplay',
                                                          color: Appcolors()
                                                              .loginhintcolor,
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Please enter Message";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 30.w,
                                                          decoration: BoxDecoration(
                                                              image: const DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/images/btnbackgroundgradient.png"),
                                                                  fit: BoxFit
                                                                      .fill),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          height: 5.h,
                                                          child: Text(
                                                            StringConstants
                                                                .update,
                                                            style: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontFamily:
                                                                    "PulpDisplay",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Appcolors()
                                                                    .backgroundcolor),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              editedpostid =
                                                                  null;
                                                            });
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 40.w,
                                                            height: 5.h,
                                                            child: Text(
                                                              StringConstants
                                                                  .cancel,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontFamily:
                                                                      "PulpDisplay",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Appcolors()
                                                                      .whitecolor),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                        ],
                                      )),
                                  // Container(
                                  //   width: 75.w,
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: [
                                  //       Container(
                                  //         width: 20.w,
                                  //         child: Row(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           children: [
                                  //             SvgPicture.asset(
                                  //                 "assets/images/likeicon.svg"),
                                  //             Text(
                                  //               feedpostspojo!.message!.schedule!
                                  //                   .elementAt(index)
                                  //                   .likes
                                  //                   .toString(),
                                  //               style: TextStyle(
                                  //                   fontSize: 12.sp,
                                  //                   // fontFamily: "PulpDisplay",
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color: Appcolors()
                                  //                       .loginhintcolor),
                                  //               textAlign: TextAlign.start,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Container(
                                  //         width: 20.w,
                                  //         child: Row(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.end,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           children: [
                                  //             SvgPicture.asset(
                                  //                 "assets/images/viewsicon.svg"),
                                  //             Text(
                                  //               feedpostspojo!.message!.schedule!
                                  //                   .elementAt(index)
                                  //                   .views
                                  //                   .toString(),
                                  //               style: TextStyle(
                                  //                   fontSize: 12.sp,
                                  //                   // fontFamily: "PulpDisplay",
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color: Appcolors()
                                  //                       .loginhintcolor),
                                  //               textAlign: TextAlign.start,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Container(
                                  //         width: 20.w,
                                  //         child: Row(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.end,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           children: [
                                  //             SvgPicture.asset(
                                  //                 "assets/images/unlockicon.svg"),
                                  //             Text(
                                  //               feedpostspojo!.message!.schedule!
                                  //                   .elementAt(index)
                                  //                   .unlocked
                                  //                   .toString(),
                                  //               style: TextStyle(
                                  //                   fontSize: 12.sp,
                                  //                   // fontFamily: "PulpDisplay",
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color: Appcolors()
                                  //                       .loginhintcolor),
                                  //               textAlign: TextAlign.start,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
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
          )
        : emptydata();
  }

  Widget savetodraft() {
    return feedpostspojo!.message!.saveDraft!.isNotEmpty
        ? AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedpostspojo!.message!.saveDraft!.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConvertsationScreen(
                                            userid: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .id
                                                .toString(),
                                            userimage: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .url
                                                .toString(),
                                            username: feedpostspojo!
                                                .message!.post!
                                                .elementAt(index)
                                                .stagename
                                                .toString(),
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.5.h),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Appcolors().chatuserborder),
                                  borderRadius: BorderRadius.circular(2.h)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 4.5.h,
                                            width: 15.w,
                                            child: CachedNetworkImage(
                                              imageUrl: feedpostspojo!
                                                  .message!.post!
                                                  .elementAt(index)
                                                  .image
                                                  .toString(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 15.w,
                                                alignment: Alignment.centerLeft,
                                                height: 4.5.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
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
                                              // errorWidget: (context, url, error) => errorWidget,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                feedpostspojo!.message!.post!
                                                    .elementAt(index)
                                                    .stagename
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Appcolors().whitecolor),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                feedpostspojo!
                                                    .message!.saveDraft!
                                                    .elementAt(index)
                                                    .ago
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    // fontFamily: "PulpDisplay",
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w400,
                                                    color: Appcolors()
                                                        .loginhintcolor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          customButton: Image.asset(
                                            "assets/images/menubtn.png",
                                            height: 4.h,
                                            fit: BoxFit.fill,
                                          ),
                                          items: [
                                            ...ScheduledMenuItems
                                                .schedulefirstItems
                                                .map(
                                              (item) => DropdownMenuItem<
                                                  ScheduledCustomMenuItem>(
                                                value: item,
                                                child: ScheduledMenuItems
                                                    .buildItem(item),
                                              ),
                                            ),
                                            const DropdownMenuItem<Divider>(
                                                enabled: false,
                                                child: Divider()),
                                            ...ScheduledMenuItems
                                                .schedulesecondItems
                                                .map(
                                              (item) => DropdownMenuItem<
                                                  ScheduledCustomMenuItem>(
                                                value: item,
                                                child: ScheduledMenuItems
                                                    .buildItem(item),
                                              ),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            ScheduledMenuItems.onChanged(
                                                context,
                                                value
                                                    as ScheduledCustomMenuItem);
                                            print("Value:-${value.text}");
                                            if (value.text ==
                                                StringConstants.editpost) {
                                              setState(() {
                                                editedpostid = index;
                                              });
                                            } else if (value.text ==
                                                StringConstants.deletepost) {
                                              showdeletealert(
                                                  context,
                                                  feedpostspojo!
                                                      .message!.saveDraft!
                                                      .elementAt(index)
                                                      .id
                                                      .toString(),
                                                  index);
                                            }
                                          },
                                          dropdownStyleData: DropdownStyleData(
                                            width: 160,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Appcolors().bottomnavbgcolor,
                                            ),
                                            elevation: 8,
                                            offset: const Offset(0, 8),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            customHeights: [
                                              ...List<double>.filled(
                                                  ScheduledMenuItems
                                                      .schedulefirstItems
                                                      .length,
                                                  35),
                                              8,
                                              ...List<double>.filled(
                                                  ScheduledMenuItems
                                                      .schedulesecondItems
                                                      .length,
                                                  48),
                                            ],
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                          ),
                                        ),
                                      ),
                                      // GestureDetector(
                                      //     onTap: () {
                                      //       print("Click click");
                                      //       // showMemberMenu();
                                      //     },
                                      //     child: SvgPicture.asset(
                                      //       "assets/images/feedmenubtn.svg",
                                      //       width: 10.w,
                                      //       height: 5.h,
                                      //     ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  Offstage(
                                    offstage: feedpostspojo!.message!.saveDraft!
                                            .elementAt(index)
                                            .url ==
                                        "",
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Feeddetailedpage(
                                                      type: feedpostspojo!
                                                          .message!.saveDraft!
                                                          .elementAt(index)
                                                          .filetype
                                                          .toString(),
                                                      url: feedpostspojo!
                                                          .message!.saveDraft!
                                                          .elementAt(index)
                                                          .url
                                                          .toString(),
                                                      ago: feedpostspojo!
                                                          .message!.saveDraft!
                                                          .elementAt(index)
                                                          .ago
                                                          .toString(),
                                                      text: feedpostspojo!
                                                          .message!.saveDraft!
                                                          .elementAt(index)
                                                          .text,
                                                      likes: feedpostspojo!
                                                          .message!.saveDraft!
                                                          .elementAt(index)
                                                          .likes
                                                          .toString(),
                                                      views: feedpostspojo!
                                                          .message!.saveDraft!
                                                          .elementAt(index)
                                                          .views
                                                          .toString(),
                                                      unlocks: "",
                                                      posttype: 2,
                                                      postid: feedpostspojo!
                                                          .message!.saveDraft!
                                                          .elementAt(index)
                                                          .id
                                                          .toString(),
                                                      pinstatus: "",
                                                    )));
                                      },
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 30.h,
                                          child: feedpostspojo!
                                                      .message!.saveDraft!
                                                      .elementAt(index)
                                                      .filetype ==
                                                  "jpg"
                                              ? CachedNetworkImage(
                                                  imageUrl: feedpostspojo!
                                                      .message!.saveDraft!
                                                      .elementAt(index)
                                                      .url
                                                      .toString(),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: 15.w,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 4.5.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
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
                                                  // errorWidget: (context, url, error) => errorWidget,
                                                )
                                              : feedpostspojo!
                                                          .message!.saveDraft!
                                                          .elementAt(index)
                                                          .filetype ==
                                                      "mp4"
                                                  ? Container(
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
                                                        size: 6.h,
                                                      ),
                                                    )
                                                  : const SizedBox()),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Offstage(
                                    offstage: feedpostspojo!.message!.saveDraft!
                                            .elementAt(index)
                                            .text ==
                                        null,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        editedpostid != index
                                            ? Text(
                                                feedpostspojo!
                                                    .message!.saveDraft!
                                                    .elementAt(index)
                                                    .text
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    // fontFamily: "PulpDisplay",
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Appcolors().whitecolor),
                                                textAlign: TextAlign.start,
                                              )
                                            : Container(
                                                child: Column(
                                                children: [
                                                  TextFormField(
                                                    minLines: 3,
                                                    maxLines: 3,
                                                    cursorColor: Appcolors()
                                                        .loginhintcolor,
                                                    style: TextStyle(
                                                      color: Appcolors()
                                                          .whitecolor,
                                                      fontSize: 12.sp,
                                                    ),
                                                    controller:
                                                        postcontentcontoller,
                                                    decoration: InputDecoration(
                                                      // prefix: Container(
                                                      //   child: SvgPicture.asset("assets/images/astrickicon.svg",width: 5.w,),
                                                      // ),
                                                      border: InputBorder.none,
                                                      // focusedBorder: InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        borderSide: BorderSide(
                                                            color: Appcolors()
                                                                .logintextformborder),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        borderSide: BorderSide(
                                                            color: Appcolors()
                                                                .logintextformborder),
                                                      ),
                                                      filled: true,
                                                      isDense: true,
                                                      fillColor: Appcolors()
                                                          .messageboxbgcolor,
                                                      hintText: StringConstants
                                                          .writesomething,
                                                      hintStyle: TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12.sp,
                                                        // fontFamily: 'PulpDisplay',
                                                        color: Appcolors()
                                                            .loginhintcolor,
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Please enter Message";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 30.w,
                                                        decoration: BoxDecoration(
                                                            image: const DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/images/btnbackgroundgradient.png"),
                                                                fit: BoxFit
                                                                    .fill),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        height: 5.h,
                                                        child: Text(
                                                          StringConstants
                                                              .update,
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  "PulpDisplay",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Appcolors()
                                                                  .backgroundcolor),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            editedpostid = null;
                                                          });
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 40.w,
                                                          height: 5.h,
                                                          child: Text(
                                                            StringConstants
                                                                .cancel,
                                                            style: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontFamily:
                                                                    "PulpDisplay",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Appcolors()
                                                                    .whitecolor),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   width: 75.w,
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: [
                                  //       Container(
                                  //         width: 20.w,
                                  //         child: Row(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           children: [
                                  //             SvgPicture.asset(
                                  //                 "assets/images/likeicon.svg"),
                                  //             Text(
                                  //               feedpostspojo!.message!.saveDraft!
                                  //                   .elementAt(index)
                                  //                   .likes
                                  //                   .toString(),
                                  //               style: TextStyle(
                                  //                   fontSize: 12.sp,
                                  //                   // fontFamily: "PulpDisplay",
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color: Appcolors()
                                  //                       .loginhintcolor),
                                  //               textAlign: TextAlign.start,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Container(
                                  //         width: 20.w,
                                  //         child: Row(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.end,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           children: [
                                  //             SvgPicture.asset(
                                  //                 "assets/images/viewsicon.svg"),
                                  //             Text(
                                  //               feedpostspojo!.message!.saveDraft!
                                  //                   .elementAt(index)
                                  //                   .views
                                  //                   .toString(),
                                  //               style: TextStyle(
                                  //                   fontSize: 12.sp,
                                  //                   // fontFamily: "PulpDisplay",
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color: Appcolors()
                                  //                       .loginhintcolor),
                                  //               textAlign: TextAlign.start,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Container(
                                  //         width: 20.w,
                                  //         child: Row(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.end,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           children: [
                                  //             SvgPicture.asset(
                                  //                 "assets/images/unlockicon.svg"),
                                  //             Text(
                                  //               "40",
                                  //               style: TextStyle(
                                  //                   fontSize: 12.sp,
                                  //                   // fontFamily: "PulpDisplay",
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color: Appcolors()
                                  //                       .loginhintcolor),
                                  //               textAlign: TextAlign.start,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
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
          )
        : emptydata();
  }

  Widget emptydata() {
    return Container(
      alignment: Alignment.center,
      height: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Divider(thickness: 1.2, height: 1.h, color: Appcolors().dividercolor),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/noresponse.png",
                height: 5.h,
              ),
              SizedBox(
                height: 1.h,
              ),
              GradientText(
                StringConstants.noposts,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "PulpDisplay",
                    fontWeight: FontWeight.w400),
                gradientType: GradientType.linear,
                gradientDirection: GradientDirection.ttb,
                radius: 6,
                colors: [
                  Appcolors().gradientcolorfirst,
                  Appcolors().gradientcolorsecond,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pinnedpost() {
    return Container(
        padding: const EdgeInsets.all(6),
        width: 6.w,
        margin: const EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Appcolors().gradientcolorsecond),
            //   color: Colors.white,
            borderRadius: BorderRadius.circular(5)),
        height: 3.h,
        child: Image.asset(
          "assets/images/pinpost.png",
          color: Colors.red,
          height: 15,
        )
        // Text(StringConstants.pinnedpost,style: TextStyle(color: Appcolors().whitecolor),),
        );
  }

  Future<void> _createDynamicLink(bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: DynamicLink,
      longDynamicLink: Uri.parse(
        'https://sextconfidential.page.link/?link=https://sextconfidential.com&isi=6450113311&ibi=com.coderzbar.sextconfidential.sextconfidential&efr=1'
        "10",
      ),
      link: Uri.parse(DynamicLink),
      // androidParameters: const AndroidParameters(
      //   packageName: 'io.flutter.plugins.firebase.dynamiclinksexample',
      //   minimumVersion: 0,
      // ),
      // iosParameters: const IOSParameters(
      //   bundleId: 'io.flutter.plugins.firebase.dynamiclinksexample',
      //   minimumVersion: '0',
      // ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }
    print("Url:-$url");
  }
}
