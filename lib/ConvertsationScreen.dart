import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textconfidential/Bottomnavigation.dart';
import '/Imagewithlock.dart';
// import 'package:record_mp3/record_mp3.dart';
import '/UserprofileScreen.dart';
import '/Videoscreen.dart';
import '/pojo/Chatmessagespojo.dart';
import '/utils/Appcolors.dart';
import '/utils/Helpingwidgets.dart';
import '/utils/Networks.dart';
import '/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:voice_message_package/voice_message_package.dart';
// import 'package:voice_message_package/voice_message_package.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'conference/conference_page.dart';
import 'debug.dart';
import 'models/twilio_enums.dart';
import 'room/room_bloc.dart';
import 'room/room_model.dart';
import 'shared/widgets/platform_exception_alert_dialog.dart';

// ignore: must_be_immutable
class ConvertsationScreen extends StatefulWidget {
  String userid, userimage, username;
  ConvertsationScreen(
      {super.key,
      required this.userid,
      required this.userimage,
      required this.username});

  @override
  ConvertsationScreenState createState() => ConvertsationScreenState();
}

class ConvertsationScreenState extends State<ConvertsationScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  TextEditingController messagecontroller = TextEditingController();
  int counter = 0;
  String? usertype;
  bool loading = false;
  bool showuploaddialog = false;
  bool emojiShowing = false;
  File? imageFile, recordingaudio;
  FocusNode messsagefocus = FocusNode();
  bool micstatus = false;
  String statusText = "";
  bool isComplete = false;
  String recordingTime = '0:0'; // to store value
  bool isRecording = false;
  String? token, userprofilepic, username;
  bool responsestatus = false;
  Chatmessagespojo? chatmessagespojonew;
  Chatmessagespojo? chatmessagespojo2;
  Chatmessagespojo? chatmessagespojo;
  GlobalKey<State> key = GlobalKey();
  Timer? _timer;
  bool condition = false;
  final ScrollController _controller = ScrollController();
  String? chatcurrentdate;
  int messageslength = 0;
  int online = 0;
  FlutterSound flutterSound = FlutterSound();
  final recorder = FlutterSoundRecorder();
  late final RoomBloc roomBloc;
  var responseSave;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsharedpreference();
    initRecorder();
    checkPermission();
    firebase();
  }

  void firebase() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      chatconversationlisting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _timer!.cancel();
        if (emojiShowing == true) {
          setState(() {
            emojiShowing = false;
            showuploaddialog = false;
            micstatus = false;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Appcolors().backgroundcolor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Appcolors().bottomnavbgcolor,
          leading: GestureDetector(
            onTap: () {
              _timer!.cancel();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const Bottomnavigation()),
                  (Route<dynamic> route) => false);
              //print("Click back");
            },
            child: Container(
                // color: Colors.white,
                margin: EdgeInsets.only(left: 2.w),
                child: const Icon(Icons.arrow_back_ios_rounded)),
          ),
          leadingWidth: 7.w,
          title: GestureDetector(
            onTap: () {
              // print("Scroll down");
              // _scrollDown();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserprofileScreen(
                            username: widget.username.toString(),
                            userimage: widget.userimage.toString(),
                            userid: widget.userid.toString(),
                          )));
            },
            child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 5.h,
                            width: 16.w,
                            child: CachedNetworkImage(
                              imageUrl: widget.userimage.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 16.w,
                                alignment: Alignment.centerLeft,
                                height: 5.h,
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
                                    color: Appcolors().gradientcolorfirst,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 16.w,
                                height: 5.h,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/userprofile.png"))),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.username.toString(),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    // fontFamily: "PulpDisplay",
                                    fontWeight: FontWeight.w500,
                                    color: Appcolors().whitecolor),
                                textAlign: TextAlign.start,
                              ),
                              online == 1
                                  ? Text(
                                      StringConstants.onlinenow,
                                      style: TextStyle(
                                          fontSize: 8.sp,
                                          // fontFamily: "PulpDisplay",
                                          fontWeight: FontWeight.w400,
                                          color: Appcolors().onlinecolor),
                                      textAlign: TextAlign.center,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      usertype == 'user'
                          ? FittedBox(
                              child: IconButton(
                                icon: const Icon(Icons.video_call),
                                highlightColor: Appcolors().gradientcolorfirst,
                                onPressed: () {
                                  submit(context, widget.userid.toString());
                                },
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ])),
          ),
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            // padding: EdgeInsets.only(left: 2.w, right: 2.w),
            color: Appcolors().backgroundcolor,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    responsestatus
                        ? chatmessagespojo!.data!.isNotEmpty &&
                                chatmessagespojo!.data != null
                            ? Expanded(
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                    // reverse: true,
                                    controller: _controller,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: chatmessagespojo!.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  online = chatmessagespojo!
                                                      .data!
                                                      .elementAt(index)
                                                      .online!
                                                      .toInt();
                                                  showuploaddialog = false;
                                                  emojiShowing = false;
                                                  // micstatus = false;
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 2.w, right: 2.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        chatcurrentdate !=
                                                                chatmessagespojo!
                                                                    .data!
                                                                    .elementAt(
                                                                        index)
                                                                    .createdAt
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10)
                                                            ? daydivider(
                                                                chatmessagespojo!
                                                                    .data!
                                                                    .elementAt(
                                                                        index)
                                                                    .createdAt
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10))
                                                            : const SizedBox(),
                                                        chatmessagespojo!.data!
                                                                    .elementAt(
                                                                        index)
                                                                    .fromId
                                                                    .toString() !=
                                                                token
                                                            ? sendermessage(
                                                                index)
                                                            : receivermessage(
                                                                index),
                                                        // voicemessage()
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.5.h,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Center(
                                child: Helpingwidgets.emptydatawithoutdivider(
                                    "No Message!"))
                        : const SizedBox(),
                    SizedBox(
                      height: 7.h,
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Offstage(
                      offstage: !micstatus,
                      child: miccontainer(),
                    ),
                    showuploaddialog ? uploadcontainer() : const SizedBox(),
                    Container(
                        margin: EdgeInsets.only(left: 2.w, right: 2.w),
                        color: Appcolors().backgroundcolor,
                        width: double.infinity,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 1.h),
                          padding: EdgeInsets.only(
                            left: 2.w,
                            right: 2.w,
                            top: 1.h,
                            bottom: 1.h,
                          ),
                          decoration: BoxDecoration(
                              color: Appcolors().bottomnavbgcolor,
                              borderRadius: BorderRadius.circular(15)),
                          // height: 7.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // !micstatus?
                              SizedBox(
                                height: 5.h,
                                width: 80.w,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          emojiShowing = !emojiShowing;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/emojiimg.svg",
                                        height: 3.h,
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        cursorColor: Appcolors().loginhintcolor,
                                        style: TextStyle(
                                          color: Appcolors().loginhintcolor,
                                          fontSize: 12.sp,
                                        ),
                                        controller: messagecontroller,
                                        focusNode: messsagefocus,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          // focusedBorder: InputBorder.none,
                                          filled: true,
                                          fillColor:
                                              Appcolors().bottomnavbgcolor,
                                          hintText: StringConstants.type,
                                          hintStyle: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            // fontFamily: 'PulpDisplay',
                                            color: Appcolors().loginhintcolor,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            emojiShowing = false;
                                            showuploaddialog = false;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return "Please enter Message";
                                        //   } else {
                                        //     return null;
                                        //   }
                                        // },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (showuploaddialog) {
                                              showuploaddialog = false;
                                            } else {
                                              showuploaddialog = true;
                                              emojiShowing = false;
                                            }
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/cameraicon.svg",
                                          height: 2.5.h,
                                          color: showuploaddialog
                                              ? Appcolors().gradientcolorsecond
                                              : Appcolors().whitecolor,
                                        )),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                  ],
                                ),
                              ),
                              !micstatus && messagecontroller.text.isEmpty
                                  ? GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          showuploaddialog = false;
                                          micstatus = true;
                                          startRecord();
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/micicon.svg",
                                        height: 2.5.h,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (_controller.hasClients) {
                                              _controller.jumpTo(_controller
                                                  .position.maxScrollExtent);
                                            }
                                          });
                                          if (messagecontroller.text
                                              .toString()
                                              .trim()
                                              .isNotEmpty) {
                                            sendmessage();
                                          }
                                          recordingTime = "0:0";
                                          micstatus = false;
                                          // stopRecord();
                                          messagecontroller.text = "";
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/sendicon.svg",
                                        height: 2.5.h,
                                      ),
                                    ),
                              SizedBox(
                                width: 3.w,
                              ),
                            ],
                          ),
                        )),
                    Offstage(
                      offstage: !emojiShowing,
                      child: SizedBox(
                          height: 250,
                          child: EmojiPicker(
                            textEditingController: messagecontroller,
                            config: Config(
                              columns: 7,
                              // Issue: https://github.com/flutter/flutter/issues/28894
                              emojiSizeMax: 32 *
                                  (foundation.defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? 1.30
                                      : 1.0),
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              gridPadding: EdgeInsets.zero,
                              initCategory: Category.RECENT,
                              bgColor: Appcolors().backgroundcolor,
                              indicatorColor: Colors.blue,
                              iconColor: Colors.grey,
                              iconColorSelected: Colors.blue,
                              backspaceColor: Colors.blue,
                              skinToneDialogBgColor:
                                  Appcolors().backgroundcolor,
                              skinToneIndicatorColor: Colors.grey,
                              enableSkinTones: true,
                              // showRecentsTab: true,
                              recentsLimit: 28,
                              replaceEmojiOnLimitExceed: false,
                              noRecents: const Text(
                                'No Recents',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              loadingIndicator: const SizedBox.shrink(),
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL,
                              checkPlatformCompatibility: true,
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadcontainer() {
    return Container(
      margin: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 1.h),
      alignment: Alignment.center,
      height: 15.h,
      decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(
              "assets/images/btnbackgroundgradient.png",
            ),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          usertype != "user"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text(
                        "Add Price",
                        style: TextStyle(
                            fontSize: 14.sp,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w500,
                            color: Appcolors().bottomnavbgcolor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FloatingActionButton.small(
                        elevation: 1.0,
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          setState(() => counter++);
                        },
                        child: const Icon(Icons.add)),
                    SizedBox(
                      width: 25,
                      child: Text(
                        counter.toString(),
                        style: TextStyle(
                            fontSize: 14.sp,
                            // fontFamily: "PulpDisplay",
                            fontWeight: FontWeight.w500,
                            color: Appcolors().bottomnavbgcolor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FloatingActionButton.small(
                        elevation: 1.0,
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          setState(() => counter > 0 ? counter-- : '');
                        },
                        child: const Icon(CupertinoIcons.minus)),
                  ],
                )
              : const Row(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    showuploaddialog = false;
                  });
                  // Navigator.pop(context);
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
                  setState(() {
                    showuploaddialog = false;
                  });
                  // Navigator.pop(context);
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
                  setState(() {
                    showuploaddialog = false;
                  });
                  // Navigator.pop(context);
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
        ],
      ),
    );
  }

  Widget miccontainer() {
    return Container(
      margin: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 1.h),
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
              stopRecorder();
              setState(() {
                micstatus = false;
              });
            },
            child: SvgPicture.asset(
              "assets/images/deleteicon.svg",
              height: 3.h,
              width: 3.w,
              color: Appcolors().bottomnavbgcolor,
            ),
          ),
          GestureDetector(
              onTap: () {
                // Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 4.5.h,
                backgroundColor: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/micicon.svg",
                      height: 2.5.h,
                      color: Appcolors().gradientcolorfirst,
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    StreamBuilder<RecordingDisposition>(
                      builder: (context, snapshot) {
                        final duration = snapshot.hasData
                            ? snapshot.data!.duration
                            : Duration.zero;

                        String twoDigits(int n) => n.toString().padLeft(2, '0');

                        final twoDigitMinutes =
                            twoDigits(duration.inMinutes.remainder(60));
                        final twoDigitSeconds =
                            twoDigits(duration.inSeconds.remainder(60));
                        return Text(
                          '$twoDigitMinutes:$twoDigitSeconds',
                          style: TextStyle(
                              fontSize: 12.sp,
                              // fontFamily: "PulpDisplay",
                              fontWeight: FontWeight.w400,
                              color: Appcolors().gradientcolorfirst),
                        );
                      },
                      stream: recorder.onProgress,
                    ),
                  ],
                ),
              )),
          GestureDetector(
            onTap: () {
              stopandsendRecorder();
              setState(() {
                micstatus = false;
              });
            },
            child: SvgPicture.asset(
              "assets/images/sendicon.svg",
              height: 3.h,
              width: 3.w,
              color: Appcolors().bottomnavbgcolor,
            ),
          ),
        ],
      ),
    );
  }

  Widget receivermessage(int index) {
    // setState((){

    chatcurrentdate = chatmessagespojo!.data!
        .elementAt(index)
        .createdAt
        .toString()
        .substring(0, 10);
    // });
    return Column(
      children: [
        chatmessagespojo!.data!.elementAt(index).messageType.toString() ==
                "loading"
            ? SizedBox(
                height: 200,
                child: Container(
                    margin: EdgeInsets.only(left: 2.w, right: 2.w),
                    alignment: Alignment.centerRight,
                    child: const Center(child: CircularProgressIndicator())))
            : chatmessagespojo!.data!.elementAt(index).messageType.toString() ==
                    "text"
                ? Container(
                    margin: EdgeInsets.only(left: 2.w, right: 2.w),
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(1.5.h),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/images/btnbackgroundgradient.png",
                                  ),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            chatmessagespojo!.data!
                                .elementAt(index)
                                .message
                                .toString(),
                            style: TextStyle(
                                fontSize: 11.sp,
                                // fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                color: Appcolors().blackcolor),
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        messagetime(index),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    ),
                  )
                : chatmessagespojo!.data!.elementAt(index).messageType == "mp4"
                    ? Container(
                        margin: EdgeInsets.only(left: 2.w, right: 2.w),
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                chatmessagespojo!.data!
                                            .elementAt(index)
                                            .paid_status
                                            .toString() ==
                                        'no'
                                    ? showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                            paymentwidgets(ctx, index),
                                      )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Videoscreen(
                                                videopath: chatmessagespojo!
                                                    .data!
                                                    .elementAt(index)
                                                    .message
                                                    .toString())));
                              },
                              child: chatmessagespojo!.data!
                                          .elementAt(index)
                                          .paid_status
                                          .toString() ==
                                      'no'
                                  ? ImageWithLock(
                                      imageUrl:
                                          "assets/images/videodefaultimg.png",
                                      price: chatmessagespojo!.data!
                                          .elementAt(index)
                                          .price
                                          .toString(),
                                      isLocked: chatmessagespojo!.data!
                                                  .elementAt(index)
                                                  .paid_status
                                                  .toString() ==
                                              'no'
                                          ? true
                                          : false)
                                  : Container(
                                      height: 15.h,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                "assets/images/videodefaultimg.png",
                                              ),
                                              fit: BoxFit.fill)),
                                      child: Icon(
                                        Icons.play_circle_outline_rounded,
                                        color: Colors.white,
                                        size: 6.h,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            messagetime(index),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        ),
                      )
                    : chatmessagespojo!.data!
                                .elementAt(index)
                                .messageType
                                .toString() ==
                            "mp3"
                        ? voicemessage(
                            chatmessagespojo!.data!
                                .elementAt(index)
                                .message
                                .toString(),
                            index)
                        : Container(
                            margin: EdgeInsets.only(left: 2.w, right: 2.w),
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    chatmessagespojo!.data!
                                                .elementAt(index)
                                                .paid_status
                                                .toString() ==
                                            'no'
                                        ? showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                paymentwidgets(ctx, index),
                                          )
                                        : Helpingwidgets().mediaimagedialog(
                                            context,
                                            chatmessagespojo!.data!
                                                .elementAt(index)
                                                .message
                                                .toString());
                                  },
                                  child: SizedBox(
                                    height: 15.h,
                                    width: 40.w,
                                    child: SizedBox(
                                      height: 15.h,
                                      width: 40.w,
                                      child: ImageWithLock(
                                          imageUrl: chatmessagespojo!.data!
                                              .elementAt(index)
                                              .message
                                              .toString(),
                                          price: chatmessagespojo!.data!
                                              .elementAt(index)
                                              .price
                                              .toString(),
                                          isLocked: chatmessagespojo!.data!
                                                      .elementAt(index)
                                                      .paid_status
                                                      .toString() ==
                                                  'no'
                                              ? true
                                              : false),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                messagetime(index),
                                SizedBox(
                                  height: 2.h,
                                ),
                              ],
                            ),
                          ),
      ],
    );
  }

  Widget sendermessage(int index) {
    //setState(() {
    chatcurrentdate = chatmessagespojo!.data!
        .elementAt(index)
        .createdAt
        .toString()
        .substring(0, 10);
    //});

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              chatmessagespojo!.data!.elementAt(index).messageType.toString() ==
                      "loading"
                  ? SizedBox(
                      height: 200,
                      child: Container(
                          margin: EdgeInsets.only(left: 2.w, right: 2.w),
                          alignment: Alignment.centerRight,
                          child:
                              const Center(child: CircularProgressIndicator())))
                  : chatmessagespojo!.data!
                              .elementAt(index)
                              .messageType
                              .toString() ==
                          "text"
                      ? Container(
                          // alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 6.w),
                          padding: EdgeInsets.only(
                              right: 4.w, left: 8.w, top: 2.h, bottom: 2.h),
                          decoration: BoxDecoration(
                            color: Appcolors().profileboxcolor,
                            borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                          ),
                          // height: 7.h,
                          // width: 80.w,
                          child: Text(
                            chatmessagespojo!.data!
                                .elementAt(index)
                                .message
                                .toString(),
                            style: TextStyle(
                                fontSize: 11.sp,
                                // fontFamily: "PulpDisplay",
                                fontWeight: FontWeight.w500,
                                // fontStyle: FontStyle.italic,
                                color: Appcolors().whitecolor),
                          ),
                        )
                      : chatmessagespojo!.data!
                                  .elementAt(index)
                                  .messageType
                                  .toString() ==
                              "mp4"
                          ? Container(
                              margin: EdgeInsets.only(left: 6.w),
                              padding: EdgeInsets.only(
                                  right: 4.w, left: 8.w, top: 2.h, bottom: 2.h),
                              decoration: BoxDecoration(
                                color: Appcolors().profileboxcolor,
                                borderRadius: BorderRadius.circular(20),
                                shape: BoxShape.rectangle,
                              ),
                              height: 15.h,
                              width: 40.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      chatmessagespojo!.data!
                                                  .elementAt(index)
                                                  .paid_status
                                                  .toString() ==
                                              'no'
                                          ? showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  paymentwidgets(ctx, index),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Videoscreen(
                                                          videopath:
                                                              chatmessagespojo!
                                                                  .data!
                                                                  .elementAt(
                                                                      index)
                                                                  .message
                                                                  .toString())));
                                    },
                                    child: chatmessagespojo!.data!
                                                .elementAt(index)
                                                .paid_status
                                                .toString() ==
                                            'no'
                                        ? ImageWithLock(
                                            imageUrl:
                                                "assets/images/videodefaultimg.png",
                                            price: chatmessagespojo!.data!
                                                .elementAt(index)
                                                .price
                                                .toString(),
                                            isLocked: chatmessagespojo!.data!
                                                        .elementAt(index)
                                                        .paid_status
                                                        .toString() ==
                                                    'no'
                                                ? true
                                                : false)
                                        : Container(
                                            height: 10.h,
                                            width: 40.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                      "assets/images/videodefaultimg.png",
                                                    ),
                                                    fit: BoxFit.cover)),
                                            child: Icon(
                                              Icons.play_circle_outline_rounded,
                                              color: Colors.white,
                                              size: 3.h,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            )
                          : chatmessagespojo!.data!
                                      .elementAt(index)
                                      .messageType
                                      .toString() ==
                                  "mp3"
                              ? voicemessage(
                                  chatmessagespojo!.data!
                                      .elementAt(index)
                                      .message
                                      .toString(),
                                  index)
                              : Container(
                                  margin: EdgeInsets.only(left: 6.w),
                                  padding: EdgeInsets.only(
                                      right: 4.w,
                                      left: 8.w,
                                      top: 2.h,
                                      bottom: 2.h),
                                  decoration: BoxDecoration(
                                    color: Appcolors().profileboxcolor,
                                    borderRadius: BorderRadius.circular(20),
                                    shape: BoxShape.rectangle,
                                  ),
                                  height: 15.h,
                                  width: 40.w,
                                  child: InkWell(
                                    onTap: () {
                                      chatmessagespojo!.data!
                                                  .elementAt(index)
                                                  .paid_status
                                                  .toString() ==
                                              'no'
                                          ? showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  paymentwidgets(ctx, index),
                                            )
                                          : Helpingwidgets().mediaimagedialog(
                                              context,
                                              chatmessagespojo!.data!
                                                  .elementAt(index)
                                                  .message
                                                  .toString());
                                    },
                                    child: ImageWithLock(
                                        imageUrl: chatmessagespojo!.data!
                                            .elementAt(index)
                                            .message
                                            .toString(),
                                        price: chatmessagespojo!.data!
                                            .elementAt(index)
                                            .price
                                            .toString(),
                                        isLocked: chatmessagespojo!.data!
                                                    .elementAt(index)
                                                    .paid_status
                                                    .toString() ==
                                                'no'
                                            ? true
                                            : false),
                                  ),
                                ),
              Container(
                height: 6.h,
                width: 11.w,
                padding: EdgeInsets.all(0.6.h),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Appcolors().backgroundcolor),
                child: CachedNetworkImage(
                  imageUrl: widget.userimage.toString(),
                  imageBuilder: (context, imageProvider) => Container(
                    width: 10.w,
                    alignment: Alignment.centerLeft,
                    height: 6.h,
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
                        color: Appcolors().gradientcolorfirst,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 15.h,
                    width: 40.w,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/userprofile.png"))),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.w, top: 0.5.h),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: messagetime(index),
        ),
        SizedBox(
          height: 1.5.h,
        ),
      ],
    );
  }

  ///make payment for video image
  payment(id) async {
    Map data = {
      "token": token,
      "id": id.toString(),
    };
    //print("Data:-$data");
    //var jsonResponse;
    var response = await http
        .post(Uri.parse(Networks.baseurl + Networks.messagepaid), body: data);
    //jsonResponse = json.decode(response.body);
    print("json${response}");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Widget paymentwidgets(context, index) {
    return AlertDialog(
      title: const Text("Payment Alert"),
      content: Text(
          "Pay for show content \$${chatmessagespojo!.data!.elementAt(index).price.toString()}"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Color.fromARGB(255, 235, 90, 6),
            padding: const EdgeInsets.all(14),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
        ),
        TextButton(
          onPressed: () {
            var status = payment(chatmessagespojo!.data!.elementAt(index).id);
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.green,
            padding: const EdgeInsets.all(14),
            child: const Text("Pay", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget daydivider(String datedata) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Appcolors().loginhintcolor,
              // alignment: Alignment.centerLeft,
              width: 32.w,
              height: 0.1.h,
            ),
            Text(
              datedata.toString(),
              style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: "PulpDisplay",
                  fontWeight: FontWeight.w400,
                  // fontStyle: FontStyle.italic,
                  color: Appcolors().loginhintcolor),
              textAlign: TextAlign.center,
            ),
            Container(
              color: Appcolors().loginhintcolor,
              // alignment: Alignment.centerLeft,
              width: 32.w,
              height: 0.1.h,
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }

  submit(context, id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map tokenupdate = {
        "token": sharedPreferences.getString("token").toString(),
        "id": id.toString(),
      };
      var jsonResponse;
      var response = await http.post(
          Uri.parse(Networks.baseurl + Networks.videocalltoken),
          body: tokenupdate);
      jsonResponse = json.decode(response.body);
      //final roomModel = await roomBloc.submit();
      if (response.statusCode == 200) {
        print("testt${jsonResponse['data']}");
        var room = {
          'name': jsonResponse['data']['room'].toString(),
          'isLoading': true,
          'isSubmitted': true,
          'token': jsonResponse['data']['token'].toString(),
          'identity': jsonResponse['data']['identity'].toString(),
          'type': TwilioRoomType.groupSmall,
        };

        final roomModel = RoomModel.fromMap(Map<String, dynamic>.from(room));
        var roomData = {
          'calltype': 'video',
          'room': jsonResponse['data']['room'].toString(),
          'token': sharedPreferences.getString("token").toString(),
          'identity': jsonResponse['data']['identity'].toString(),
          'id': id.toString(),
        };

        await http.post(
            Uri.parse(Networks.baseurl + Networks.vidocallwithnotification),
            body: roomData);
        await Navigator.of(context).push(
          MaterialPageRoute<ConferencePage>(
            fullscreenDialog: true,
            builder: (BuildContext context) =>
                ConferencePage(roomModel: roomModel),
          ),
        );
      }
    } catch (err) {
      Debug.log(err);
      await PlatformExceptionAlertDialog(
        exception: err as Exception,
      ).show(context);
      // ignore: use_build_context_synchronously
    }
  }

  _getFromGallery() async {
    final XFile? pickedFile = await ImagePicker().pickMedia(
      maxWidth: 10000,
      maxHeight: 10000,
      imageQuality: 100,
    );
    if (pickedFile != null) {
      setState(() {
        print("filecheck$pickedFile");
        imageFile = File(pickedFile.path);
        //print("Image path:-${pickedFile.path}");
        sendmessage();
      });
    }
  }

  clickphotofromcamera() async {
    final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 10));
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          imageFile = File(pickedFile!.path);
          sendmessage();
        }
      },
    );
  }

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      // print("Video path:-${pickedFile.path}");
      sendmessage();
      // print("Video path:-${pickedFile.path}");
    }
    return;
  }

  Widget voicemessage(String audiosrc, int index) {
    return chatmessagespojo!.data!.elementAt(index).paid_status.toString() ==
            'no'
        ? Container(
            margin: EdgeInsets.only(left: 6.w),
            padding:
                EdgeInsets.only(right: 4.w, left: 8.w, top: 2.h, bottom: 2.h),
            decoration: BoxDecoration(
              color: Appcolors().profileboxcolor,
              borderRadius: BorderRadius.circular(20),
              shape: BoxShape.rectangle,
            ),
            height: 15.h,
            width: 40.w,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => paymentwidgets(ctx, index),
                );
              },
              child: ImageWithLock(
                  imageUrl: chatmessagespojo!.data!
                      .elementAt(index)
                      .message
                      .toString(),
                  price:
                      chatmessagespojo!.data!.elementAt(index).price.toString(),
                  isLocked: chatmessagespojo!.data!
                              .elementAt(index)
                              .paid_status
                              .toString() ==
                          'no'
                      ? true
                      : false),
            ),
          )
        : Container(
            alignment: Alignment.centerRight,
            // width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                VoiceMessage(
                  mePlayIconColor: Appcolors().profileboxcolor,
                  // meFgColor: Appcolors().bottomnavbgcolor,
                  meBgColor: Appcolors().profileboxcolor,
                  contactFgColor: Appcolors().profileboxcolor,
                  audioSrc: audiosrc,
                  // audioSrc: "https://samplelib.com/lib/preview/mp3/sample-9s.mp3",
                  played: true, // To show played badge or not.
                  me: true, // Set message side.
                  onPlay: () {}, // Do something when voice played.
                ),
                messagetime(index)
              ],
            ),
          );
  }

  @override
  void dispose() {
    messagecontroller.dispose();
    messsagefocus.dispose();
    _timer!.cancel();
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    await Permission.microphone.request();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    setState(() {
      imageFile = File(filePath!);
    });
  }

  Future stopandsendRecorder() async {
    final filePath = await recorder.stopRecorder();
    setState(() {
      imageFile = File(filePath!);
    });
    sendmessage();
    //print("Recorded file path:${recordingaudio!.path}");
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  // Future<String> getFilePath() async {
  //   Directory storageDirectory = await getApplicationDocumentsDirectory();
  //   String sdPath = storageDirectory.path + "/record";
  //   var d = Directory(sdPath);
  //   if (!d.existsSync()) {
  //     d.createSync(recursive: true);
  //   }
  //   return sdPath + "/test_${i++}.mp3";
  // }

  Future<void> getsharedpreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token")!;
      userprofilepic = sharedPreferences.getString("profilepic");
      username = sharedPreferences.getString("stagename");
      usertype = sharedPreferences.getString("usertype")!.toString();
    });
    chatconversationlisting();
    //print("Token value:-$token");
    if (!mounted) {
      return;
    }
    setState(() {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        chatconversationlisting();
        //print("Chat conversin api call");
      });
    });
    if (!mounted) {
      return;
    }
  }

  Future<void> chatconversationlisting() async {
    // Helpingwidgets.showLoadingDialog(context, key);
    Map data = {
      "token": token,
      "toid": widget.userid.toString(),
    };
    //print("Data:-$data");
    var jsonResponse;
    var response = await http
        .post(Uri.parse(Networks.baseurl + Networks.chatmessage), body: data);
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == false) {
        setState(() {
          responsestatus = true;
        });
        // Navigator.pop(context);
        Helpingwidgets.failedsnackbar(
            jsonResponse["message"].toString(), context);
        Navigator.pop(context);
      } else {
        setState(() {
          responseSave = jsonResponse;
          responsestatus = true;

          chatmessagespojo = Chatmessagespojo.fromJson(jsonResponse);
          //print("response${chatmessagespojo!.data![0]}");
          //print("323232:-$chatmessagespojo");
          // chatmessagespojo2=chatmessagespojonew;
          //   if(chatmessagespojo!=chatmessagespojo2){
          //     chatmessagespojo=chatmessagespojo2;
          //   }else {
          //     chatmessagespojo ??= chatmessagespojo2;
          //   }
        });

        messageslength = chatmessagespojo!.data!.length;

        if (messageslength < chatmessagespojo!.data!.length &&
            messageslength != 0) {
          //print("Message:-${_controller.position.pixels}");
          _controller.jumpTo(_controller.position.maxScrollExtent);
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: const Duration(milliseconds: 10),
              curve: Curves.easeOut);
          //print("New message received!");
        }

        //messageslength = chatmessagespojo!.data!.length;

        if (_controller.position.pixels ==
                _controller.position.minScrollExtent ||
            _controller.position.pixels ==
                _controller.position.maxScrollExtent) {
          //_controller.jumpTo(_controller.position.maxScrollExtent);
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: const Duration(milliseconds: 10),
              curve: Curves.easeOut);
        }
      }
      //_timer?.cancel();
    } else {
      // Navigator.pop(context);
      setState(() {
        responsestatus = true;
      });
      // ignore: use_build_context_synchronously
      Helpingwidgets.failedsnackbar(
          jsonResponse["message"].toString(), context);
    }
  }

  Future<void> sendmessage() async {
    //print("checkkkkk");
    //Helpingwidgets.showLoadingDialog(context, key);
    var request = http.MultipartRequest(
      'post',
      Uri.parse(Networks.baseurl + Networks.chatmessagesend),
    );

    //var jsonData;
    request.headers["Content-Type"] = "multipart/form-data";
    request.fields["toid"] = widget.userid.toString();
    request.fields["token"] = token!;
    request.fields["price"] = counter.toString();
    //print("testttt${imageFile!.path}");
    //print("fileeee${request}");
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy hh:mm a');
    String formattedDate = formatter.format(now);
    //print("check$formattedDate");
    var chatData = {
      "id": 1000,
      "from_id": int.tryParse(token.toString()),
      "to_id": int.tryParse(widget.userid.toString()),
      "message": imageFile == null ? messagecontroller.text : '',
      "message_type": imageFile != null ? "loading" : 'text',
      "seen": "1",
      "price": "0.00",
      "paid_status": "free",
      "type": "free",
      "created_at": formattedDate.toString()
    };

    responseSave['data'].add(chatData);
    setState(() {
      _timer!.cancel();

      chatmessagespojo = Chatmessagespojo.fromJson(responseSave);

      messageslength = chatmessagespojo!.data!.length;
      if (messageslength < chatmessagespojo!.data!.length &&
          messageslength != 0) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
        _controller.animateTo(_controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 10), curve: Curves.easeOut);
        //print("New message received!");
      }
      //messageslength = chatmessagespojo!.data!.length;
    });

    //print("index:-${responseSave}");

    //print("Message:-${messagecontroller.text.trim()}");
    if (imageFile != null) {
      //print("Image message send");
      //print("File path on api call:-${imageFile!.path}");
      request.files.add(
        await http.MultipartFile.fromPath("file", imageFile!.path,
            filename: imageFile!.path),
      );
    } else {
      //print("Simple message send");
      request.fields["file"] = messagecontroller.text;
    }
    var response = await request.send();
    setState(() {
      imageFile = null;
      messagecontroller.clear();
      //_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //print("Chat conversin api call$response");
      //});
    });

    response.stream.transform(utf8.decoder).listen((value) {
      //jsonData = json.decode(value);

      if (response.statusCode == 200) {
        chatconversationlisting();
        //if (jsonData["status"] == false) {
        //Helpingwidgets.failedsnackbar(
        //jsonData["message"].toString(), context);
        //print("Response:${jsonData["message"]}");
        Navigator.pop(context);
        // } else {
        setState(() {
          imageFile = null;
        });
        messagecontroller.clear();
        //Helpingwidgets.successsnackbar(
        //jsonData["message"].toString(), context);
        //print("Response:${jsonData["message"]}");
        // Navigator.pop(context);
        //}
      }
      //else {
      //Helpingwidgets.failedsnackbar(jsonData["message"].toString(), context);
      // print("Response:${jsonData["message"]}");
      // Navigator.pop(context);
      //}
    });
  }

  Future scrollToBottom(ScrollController scrollController) async {
    while (scrollController.position.pixels !=
        scrollController.position.maxScrollExtent) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      await SchedulerBinding.instance.endOfFrame;
    }
  }

  Widget messagetime(int index) {
    return Text(
      "Sent  ${chatmessagespojo!.data!.elementAt(index).createdAt.toString().substring(11, 19)}",
      // "Send for ${chatmessagespojo!.data!.elementAt(index).type}"=="free"?+chatmessagespojo!.data!.elementAt(index).createdAt.toString().substring(0,10),
      style: TextStyle(
          fontSize: 10.sp,
          // fontFamily: "PulpDisplay",SSS
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: Appcolors().loginhintcolor),
      textAlign: TextAlign.center,
    );
  }
}
