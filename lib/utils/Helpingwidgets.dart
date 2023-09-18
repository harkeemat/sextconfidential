import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sizer/sizer.dart';

import 'Appcolors.dart';

class Helpingwidgets{
  Widget customloader(){
    return Container(
      height: 10.h,
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          size: 50, color: Appcolors().gradientcolorfirst,
        ),
      ),
    );
  }

  static void successsnackbar(String content,BuildContext context){
    var snackbar = SnackBar(
        backgroundColor: Appcolors().bottomnavbgcolor,
        content: Text(content,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),));
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar);
  }
  static void failedsnackbar(String content,BuildContext context){
    var snackbar = SnackBar(
        backgroundColor: Appcolors().bottomnavbgcolor,
        content: Text(content,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color:Colors.red),));
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar);
  }
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.transparent,
                  children: <Widget>[
                    Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: 50, color: Appcolors().gradientcolorfirst,
                      ),
                    )
                  ]));
        });
  }
  static Widget emptydata(String message) {
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
                message,
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
  static Widget emptydatawithoutdivider(String message) {
    return Container(
      alignment: Alignment.center,
      height: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                message,
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
  Future mediaimagedialog(BuildContext context,String imagepath){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              backgroundColor: Colors.transparent,
              //title: Text("Image Picker"),
              content: Container(
                height: 30.h,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 1.h,right: 2.w),
                      height: 30.h,
                      width: 80.w,
                      child: CachedNetworkImage(
                        imageUrl:imagepath.toString(),
                        imageBuilder: (context,
                            imageProvider) =>
                            Container(
                              width: 23.w,
                              alignment: Alignment
                                  .centerLeft,
                              height: 10.h,
                              decoration:
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                shape: BoxShape.rectangle,
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
                          height: 15.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/imageplaceholder.png"),fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                          radius: 1.5.h,
                          backgroundColor: Appcolors().dialogbgcolor,
                          child: Icon(Icons.close,color: Colors.white,)),
                    ),

                  ],
                ),
              ));
        });
  }

}