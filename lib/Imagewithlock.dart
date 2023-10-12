import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'utils/Appcolors.dart';

class ImageWithLock extends StatefulWidget {
  final String imageUrl;
  final bool isLocked;

  final String price;

  ImageWithLock({
    required this.imageUrl,
    this.isLocked = false,
    required this.price,
  });

  @override
  State<ImageWithLock> createState() => _ImageWithLockState();
}

class _ImageWithLockState extends State<ImageWithLock> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(
      children: [
        widget.isLocked
            ? imageshow()
                .blurred(blur: 4, blurColor: Theme.of(context).primaryColor)
            : imageshow(), // Replace with your image source
        if (widget.isLocked)
          Center(
            //SizedBox Widget
            child: SizedBox(
              width: 290.0,
              height: 70.0,
              //borderRadius: BorderRadius.circular(10)
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color.fromARGB(255, 4, 4, 4),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      '\$${widget.price.toString()}',
                      style: TextStyle(color: Colors.white),
                    ), //Text
                  ),
                ), //Center
              ), //Card
            ), //SizedBox
          ),
      ],
    ));
  }

  Widget imageshow() {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: 15.h,
        width: 40.w,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
                image: AssetImage("assets/images/imageplaceholder.png"),
                fit: BoxFit.cover)),
      ),
    );
  }

  void _openImageDetail(BuildContext context) {
    // Handle the image click event here
    // For example, you can navigate to a detail page or show a larger version of the image.
  }
}
