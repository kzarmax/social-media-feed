import 'package:feed/pages/splash_page/splash_page.dart';
import 'package:feed/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class Helper {
  static void showExitDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("アプリを閉じますか？"),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("はい"),
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("いいえ"),
          )
        ],
      ),
    );
  }

  static void showToast(String msg, bool success) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 12,
    );
  }

  static finish(BuildContext context, [Object? result]) {
    if (Navigator.canPop(context)) Navigator.pop(context, result);
  }

  static void copyClipBoard(String copyVal) async {
    final data = ClipboardData(text: copyVal);
    await Clipboard.setData(data);
    Helper.showToast("コピーされました。", true);
  }

  static parseToInt(dynamic value, {int defValue = -1}) {
    if (value == null) return defValue;
    if (value is String) {
      return double.parse(value).toInt();
    }

    if (value is double) {
      return value.toInt();
    }

    return value;
  }

  static parseToDouble(dynamic value, {double defValue = -1.0}) {
    if (value == null) return defValue;
    if (value is String) {
      return double.parse(value);
    }
    if (value is int) {
      return value.toDouble();
    }
    return value;
  }

  static parseToString(dynamic value, {String defValue = ""}) {
    if (value == null) return defValue;
    if (value is String) {
      return value;
    }
    return value.toString();
  }

  static void showErrorAlert(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: CupertinoAlertDialog(
          title: const Text("エラー!"),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                const SplashPage().launch(context, isNewTask: true, type: PageTransitionType.fade);
              },
              child: const Text("閉じる"),
            )
          ],
        ),
      ),
    );
  }

  static Future sleep([int milliseconds = 0]) =>
      Future.delayed(Duration(milliseconds: milliseconds));
}
