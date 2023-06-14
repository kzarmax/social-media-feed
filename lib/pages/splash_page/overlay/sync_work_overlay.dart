import 'dart:convert';

import 'package:feed/utils/database_provider.dart';
import 'package:feed/utils/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SyncWorkOverlay extends ModalRoute<void> {
  final VoidCallback successHandler;
  final VoidCallback errorHandler;

  SyncWorkOverlay({required this.successHandler, required this.errorHandler});

  @override
  Color? get barrierColor => Colors.white.withOpacity(0.5);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => "";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SyncWorkWidget(
              successHandler: () {
                Navigator.pop(context);
                successHandler();
              },
              errorHandler: () {
                Navigator.pop(context);
                errorHandler();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class SyncWorkWidget extends StatefulWidget {
  final VoidCallback successHandler;
  final VoidCallback errorHandler;

  const SyncWorkWidget({Key? key, required this.successHandler, required this.errorHandler}) : super(key: key);

  @override
  State<SyncWorkWidget> createState() => _SyncWorkWidgetState();
}

class _SyncWorkWidgetState extends State<SyncWorkWidget> {
  final DatabaseProvider _databaseProvider = DatabaseProvider.db;

  @override
  void initState() {
    super.initState();
    _startSync();
  }

  Future<void> _startSync() async {
    String url = "https://newsapi.org/v2/top-headlines?country=jp&apiKey=df5313e8705a4474bd22906a30f1f80b&pageSize=100";
    var response = await HttpHelper.get(url, {});
    if (mounted) {
      if (response != null) {
        var results = json.decode(response.body);
        for (var item in results["articles"]) {
          Map<String, dynamic> record = {};
          record["title"] = item["title"] ?? "";
          record["description"] = item["description"] ?? "";
          record["url"] = item["url"] ?? "";
          record["image"] = item["urlToImage"] ?? "";
          record["author"] = item["author"] ?? "";
          record["created_at"] = item["publishedAt"] ?? "";
          await _databaseProvider.insertPost(record);
        }
        widget.successHandler();
      } else {
        // on Failed
        widget.errorHandler();
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.w),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Initializing...",
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            SizedBox(
              width: 30.w,
              height: 30.w,
              child: SpinKitDualRing(
                duration: const Duration(milliseconds: 1500),
                size: 20.w,
                lineWidth: 1.w,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
