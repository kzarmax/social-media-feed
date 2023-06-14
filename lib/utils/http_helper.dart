import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static Future<http.Response?> get(String url, Map<String, String> headers) async {
    http.Client client = http.Client();
    headers.addAll({"accept": "application/json", "Content-Type": "application/json"});
    try {
      var response = await client.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
    } on SocketException catch (socketErr) {
      if (kDebugMode) {
        print("SocketException: $socketErr");
      }
      return null;
    } on TimeoutException catch (timeErr) {
      if (kDebugMode) {
        print("TimeOutException : $timeErr");
      }
      return null;
    } on Exception catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      return null;
    } catch (catchErr) {
      if (kDebugMode) {
        print("Error: $catchErr");
      }
      return null;
    }
  }

  static Future<http.Response?> post(String url, Map<String, dynamic> params, Map<String, String> headers, bool isJson, bool allowUnAuth) async {
    http.Client client = http.Client();
    headers.addAll({"accept": "application/json"});
    try {
      var response = await client.post(Uri.parse(url), headers: headers, body: isJson ? json.encode(params) : params);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (allowUnAuth) {
        return response;
      } else {
        return null;
      }
    } on SocketException catch (socketErr) {
      if (kDebugMode) {
        print("SocketException: $socketErr");
      }
      return null;
    } on TimeoutException catch (timeErr) {
      if (kDebugMode) {
        print("TimeOutException : $timeErr");
      }
      return null;
    } on Exception catch (err) {
      if (kDebugMode) {
        print("Error: $err");
      }
      return null;
    } catch (catchErr) {
      if (kDebugMode) {
        print("Error: $catchErr");
      }
      return null;
    }
  }
}
