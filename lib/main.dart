
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'Bottomnavigation.dart';
import 'LoginScreen.dart';
import 'firebase_options.dart';
import 'service/NotificationService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();//
  
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
  
    
final fcmToken = await FirebaseMessaging.instance.getToken();

print("FCMToken $fcmToken");
await Permission.notification.isDenied.then(
(bool value) {
if (value) {
Permission.notification.request();
}
},
);

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
            home: const MyHomePage(),
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
  NotificationServices notificationServices = NotificationServices();
  String? token;
  bool? loginstatus=false;

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    initDynamicLinks();
    getsharedpreference();
    Future.delayed(const Duration(seconds: 3), () {
      if(loginstatus==false){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            const LoginScreen()), (Route<dynamic> route) => false);
      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            const Bottomnavigation()), (Route<dynamic> route) => false);
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
      print("Dynamic link:-${dynamicLinkData.link.path}");
    }).onError((e) {
    });
  }
}
