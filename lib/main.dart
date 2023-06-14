import 'dart:io';

import 'package:feed/pages/splash_page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final bool isIOS = Platform.isIOS;
final bool isAndroid = Platform.isAndroid;
const String appName = "SocialMediaFeed";

late Box settingBox;

Future<void> main() async {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocDirectory.path);
  settingBox = await Hive.openBox("setting");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      key: navigatorKey,
      designSize: const Size(375, 907),
      builder: (BuildContext context, Widget? child) => MaterialApp(
        title: appName,
        theme: ThemeData(fontFamily: 'HiraKakuProW6'),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/": (BuildContext context) => const SplashPage(),
        },
        initialRoute: "/",
        builder: (BuildContext context, Widget? child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(data: data.copyWith(textScaleFactor: 1), child: child!);
        },
      ),
    );
  }
}
