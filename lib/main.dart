import 'package:flutter/material.dart';

// import 'package:flutter_app/screen/Home.dart';
// import 'package:flutter_app/screen/LoginScreen.dart';
import "controller/login.dart";
import "controller/webview.dart";
import "controller/self.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message ${message.messageId}");
}


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
// 虛假的要處理掉 使用模擬器開發用一下 清空一下快取
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<MyApp> {
  late String deviceToken;


  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {

    }
  }

  @override
  void initState() {
    super.initState();
    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
    /// 監聽背景推播
    // FCMManager.onMessageOpenedApp(context);
    getToken();
    // getTopics();
  }
  /// 向 FCM 請求 device_token
  void getToken() async {
    //查看內建是否已經有了
    final prefs = await SharedPreferences.getInstance();
    final String? _deviceToken = prefs.getString('deviceToken');
    if(_deviceToken==null || _deviceToken!.isEmpty){
      var token = (await FirebaseMessaging.instance.getToken())!;
      print(token);
      await prefs.setString('deviceToken', token);
    }
    print('QQQQQQQQQQQQQ');
    print(_deviceToken);


  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp
    (
        debugShowCheckedModeBanner: true,
        title: 'Qlinx智慧雲霧平台',
        theme: new ThemeData(
        primarySwatch: Colors.blue,

    ),
    routes: {
  /**
   * 命名导航路由，启动程序默认打开的是以'/'对应的界面LoginScreen()
   * 凡是后面使用Navigator.of(context).pushNamed('/Home')，都会跳转到Home()，
   */
      '/': (BuildContext context) => new LoginScreen(),
      '/Home': (BuildContext context) => new WebviewScreen(),
      '/Self': (BuildContext context) => new SelfScreen(),
    },
    );
  }
}
