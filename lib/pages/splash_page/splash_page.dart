import 'dart:async';

import 'package:feed/main.dart';
import 'package:feed/pages/main_page/main_page.dart';
import 'package:feed/pages/splash_page/overlay/sync_work_overlay.dart';
import 'package:feed/theme/src/status.dart';
import 'package:feed/utils/constants.dart';
import 'package:feed/utils/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final int waitTime = 2; //seconds
  final DatabaseProvider _databaseProvider = DatabaseProvider.db;

  @override
  void initState() {
    super.initState();
    setOrientationPortrait();
    hideStatusBar();
    Timer(Duration(seconds: waitTime), () => _initApp());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _initApp() async {
    await _databaseProvider.createDatabase();
    int synced = settingBox.get("synced") ?? 0;
    if (synced == 0 && mounted) {
      // sync news and jump to main page
      Navigator.of(context).push(SyncWorkOverlay(
        successHandler: () {
          settingBox.put("synced", 1);
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const MainPage(),
              type: PageTransitionType.rightToLeft,
              duration: Constants.pageTransitionTime,
              reverseDuration: Constants.pageTransitionTime,
            ),
            (route) => false,
          );
        },
        errorHandler: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
      ));
    } else {
      // jump to main page
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const MainPage(),
          type: PageTransitionType.rightToLeft,
          duration: Constants.pageTransitionTime,
          reverseDuration: Constants.pageTransitionTime,
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.cover,
                  width: 300.w,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
