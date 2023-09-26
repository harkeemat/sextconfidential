import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'Appcolors.dart';

class Progressdialog {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.transparent,
                  children: <Widget>[
                    Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: 50, color: Appcolors().whitecolor,
                      ),
                    )
                  ]));
        });
  }
}
