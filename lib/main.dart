import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textconfidential/utils/Networks.dart';
import '/debug.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'Bottomnavigation.dart';
import 'LoginScreen.dart';
import 'conference/conference_page.dart';
import 'firebase_options.dart';
import 'models/twilio_enums.dart';
import 'room/room_model.dart';
import 'service/NotificationService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['type'] == 'call') {
    showCallkitIncoming(const Uuid().v4(), message);
  }

  //await Firebase.initializeApp();
}

Future<void> showCallkitIncoming(String uuid, data) async {
  final params = CallKitParams(
    id: data!.data['chat_id'],
    nameCaller: data!.data['name'],
    appName: 'Callkit',
    avatar: data!.data['profile_pic'],
    handle: data!.data['body'],
    type: 0,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    extra: data.data,
    headers: <String, dynamic>{'apiKey': uuid, 'platform': 'flutter'},
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: true,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: 'assets/test.png',
      actionColor: '#4CAF50',
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: 'callllll',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //
  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Debug.enabled = true;
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
  NotificationServices notificationServices = NotificationServices();
  FirebaseMessaging.instance.requestPermission();
  notificationServices.requestNotificationPermission();
  notificationServices.forgroundMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Permission.notification.isDenied.then(
    (bool value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Text Confidential',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: Recorddemo(),
        home: MyHomePage(navigation: navigatorKey),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigation;

  const MyHomePage({Key? key, required this.navigation}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  NotificationServices notificationServices = NotificationServices();
  String? token;
  bool? loginstatus = false;

  String textEvents = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    //initDynamicLinks();
    listenerEvent(onEvent);
    getsharedpreference();
    Future.delayed(const Duration(seconds: 3), () {
      if (loginstatus == false) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Bottomnavigation()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/splashscreen.png",
              ),
              fit: BoxFit.fill)),
    ));
  }

  Future<void> getsharedpreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    loginstatus = sharedPreferences.getBool("loginstatus") ?? false;
  }

  Future<void> listenerEvent(void Function(CallEvent) callback) async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        //print("onEvent${event!.body}");
        switch (event!.event) {
          case Event.actionCallIncoming:
            // TODO: received an incoming call
            break;
          case Event.actionCallStart:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case Event.actionCallAccept:
            callPickFunction(event.body['extra']);
            break;
          case Event.actionCallDecline:
            // TODO: declined an incoming call
            // await requestHttp("ACTION_CALL_DECLINE_FROM_DART");
            break;
          case Event.actionCallEnded:
            // TODO: ended an incoming/outgoing call
            break;
          case Event.actionCallTimeout:
            // TODO: missed an incoming call
            break;
          case Event.actionCallCallback:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
          case Event.actionCallToggleHold:
            // TODO: only iOS
            break;
          case Event.actionCallToggleMute:
            // TODO: only iOS
            break;
          case Event.actionCallToggleDmtf:
            // TODO: only iOS
            break;
          case Event.actionCallToggleGroup:
            // TODO: only iOS
            break;
          case Event.actionCallToggleAudioSession:
            // TODO: only iOS
            break;
          case Event.actionDidUpdateDevicePushTokenVoip:
            // TODO: only iOS
            break;
          case Event.actionCallCustom:
            break;
        }
        callback(event);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  callPickFunction(body) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map tokenupdate = {
        "token": sharedPreferences.getString("token").toString(),
        "roomId": body['room'].toString(),
      };
      var jsonResponse;
      var response = await http.post(
          Uri.parse(Networks.baseurl + Networks.videocalltoken),
          body: tokenupdate);
      jsonResponse = json.decode(response.body);
      //final roomModel = await roomBloc.submit();
      if (response.statusCode == 200) {
        var room = {
          'name': body['room'].toString(),
          'isLoading': true,
          'isSubmitted': true,
          'token': jsonResponse['data']['token'].toString(),
          'identity': jsonResponse['data']['identity'].toString(),
          'type': TwilioRoomType.groupSmall,
        };

        final roomModel = RoomModel.fromMap(Map<String, dynamic>.from(room));
        widget.navigation.currentState?.push(
          MaterialPageRoute<ConferencePage>(
            fullscreenDialog: true,
            builder: (BuildContext context) =>
                ConferencePage(roomModel: roomModel),
          ),
        );
      }
    } catch (err) {
      Debug.log(err);
      print("error$err");
      // ignore: use_build_context_synchronously
    }
  }

  void onEvent(CallEvent event) {
    if (mounted) {
      setState(() {
        //onEvent.cancel();
      });
    }
  }
}
