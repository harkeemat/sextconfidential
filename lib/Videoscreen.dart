import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import '/utils/Appcolors.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class Videoscreen extends StatefulWidget {
  String videopath;
  Videoscreen({super.key, required this.videopath});

  @override
  VideoscreenState createState() => VideoscreenState();
}

class VideoscreenState extends State<Videoscreen> {
  late VideoPlayerController _controller;
  late CustomVideoPlayerController _customVideoPlayerController;
  late final VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startvideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            print("Click back");
          },
          child: Text(
            "Back",
            style: TextStyle(
                fontSize: 8.sp,
                fontFamily: "PulpDisplay",
                fontWeight: FontWeight.w500,
                color: Appcolors().whitecolor),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
            color: Colors.black,
            width: double.infinity,
            height:
                (MediaQuery.of(context).size.height / 100) * double.infinity,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController,
              ),

              // VideoPlayer(
              //     _controller),
            )),
      ),
    );
  }

  void startvideo() {
    videoPlayerController = VideoPlayerController.network(widget.videopath)
      ..initialize().then((value) => setState(() {
            print("Video working");
            var durationOfVideo =
                videoPlayerController.value.position.inSeconds.round();
            print("Duration of video:-$durationOfVideo");
            debugPrint("========${_controller.value.duration}");
          }));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );

    _controller = VideoPlayerController.network(widget.videopath)
      ..initialize().then(
        (_) {
          videoPlayerController.play();
          debugPrint("========${_controller.value.duration}");
          print("Video Started");
          var durationOfVideo =
              videoPlayerController.value.position.inSeconds.round();
          print("Duration of videos:-$durationOfVideo");
        },
      );
  }
}
