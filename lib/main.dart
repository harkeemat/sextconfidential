import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sextconfidential/Chatusersscreen.dart';
import 'package:sextconfidential/utils/Appcolors.dart';
import 'package:sextconfidential/utils/StringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'Bottomnavigation.dart';
import 'CallsScreen.dart';
import 'Changepassword.dart';
import 'ConvertsationScreen.dart';
import 'Deactivateaccscreen.dart';
import 'Editprofilescreen.dart';
import 'FeedScreen.dart';
import 'Feeddetailedpage.dart';
import 'LoginScreen.dart';
import 'MassmessageScreen.dart';
import 'PayoutInfoScreen.dart';
import 'Recorddemo.dart';
import 'TimezoneScreen.dart';
import 'UserprofileScreen.dart';
import 'package:firebase_core/firebase_core.dart'; //
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sext Confidential',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            // home: Recorddemo(),
            home: MyHomePage(),
          );
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? token;
  bool? loginstatus=false;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    getsharedpreference();
    Future.delayed(Duration(seconds: 3), () {
      if(loginstatus==false){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginScreen()), (Route<dynamic> route) => false);
      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            Bottomnavigation()), (Route<dynamic> route) => false);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/splashscreen.png",),fit: BoxFit.fill
              )
          ),
        )
    );
  }
  Future<void> getsharedpreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    loginstatus=sharedPreferences.getBool("loginstatus")??false;
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      // Navigator.pushNamed(context, dynamicLinkData.link.path);
      print("Dynamic link:-"+dynamicLinkData.link.path.toString());
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }
}
