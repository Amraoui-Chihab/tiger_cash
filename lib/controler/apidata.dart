import 'dart:convert';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:ggggg/model/apiconst.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ggggg/error/server_error.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as http;

class ApiData {
  static Future<http.Response> postToApi(
      String endpoint, Map<String, String> body) async {
    http.Response x;
    GetStorage box = GetStorage();
    // User user = User.fromJson(box.read("user"));
    String tokrn = box.read("token");

    try {
      Uri uri = Uri.parse("https://tigercashiraq.xyz/$endpoint");
      x = await http.post(uri,
          headers: {
            'Accept': 'application/json',
            "content-type": "application/json",
            // add token
            "Authorization": "Bearer $tokrn",
          },
          body: jsonEncode(body));
    } catch (e) {
      throw Exception(e.toString());
    }
    print(x.statusCode);
    // print(x.body);
    switch (x.statusCode) {
      case 200:
        return x;
      // break;
      default:
        throw x.body;
    }
  }

  static Future<http.Response> getToApi(String endpoint) async {
    http.Response x;
    GetStorage box = GetStorage();
    // User user = User.fromJson(box.read("user"));
    String tokrn = box.read("token");

    try {
      Uri uri = Uri.parse("https://tigercashiraq.xyz/$endpoint");
      x = await http.get(uri, headers: {
        'Accept': 'application/json',
        "content-type": "application/json",
        // add token
        "Authorization": "Bearer $tokrn",
      });
    } catch (e) {
      throw Exception(e.toString());
    }
    // print(x.body);
    switch (x.statusCode) {
      case 200:
        return x;
      // break;
      default:
        throw Exception(x.body);
    }
  }

  static Future<http.Response> getToApi1(String endpoint) async {
    http.Response x;
    GetStorage box = GetStorage();
    // User user = User.fromJson(box.read("user"));
    String tokrn = box.read("token");

    try {
      Uri uri = Uri.parse("https://tigercashiraq.xyz/$endpoint");
      x = await http.get(uri, headers: {
        'Accept': 'application/json',
        "content-type": "application/json",
        // add token
        "Authorization": "Bearer $tokrn",
      });
    } catch (e) {
      throw Exception(e.toString());
    }
    // print(x.body);
    switch (x.statusCode) {
      case 200:
        return x;
      // break;
      default:
        throw ServerError(x);
    }
  }

  static Future<http.Response> loginToMyApi(String endpoint, var code) async {
    http.Response x;
    try {
      requestPhoneStatePermission();
      var imeiNo = await DeviceInformation.deviceIMEINumber;
      Uri uri = Uri.parse("https://tigercashiraq.xyz/api/user/getToken");
      x = await http.post(uri,
          headers: {
            'Accept': 'application/json',
            "content-type": "application/json",
          },
          body: code == null
              ? jsonEncode({
                  "access_token": endpoint,
                  "device_id": imeiNo,
                })
              : jsonEncode({
                  "code_invite": code,
                  "access_token": endpoint,
                  "device_id": imeiNo,
                }));
    } catch (e) {
      throw Exception(e.toString());
    }
    switch (x.statusCode) {
      case 200:
        return x;
      case 422:
      case 324:
        throw ServerError(x);
      default:
        throw Exception("حصل خطا غير معروف");
    }
  }

  static Future<http.Response> postToApiCauntrs(
      String endpoint, Map<String, String> body) async {
    http.Response x;
    GetStorage box = GetStorage();
    // User user = User.fromJson(box.read("user"));
    String tokrn = box.read("token");

    try {
      Uri uri = Uri.parse("https://tigercashiraq.xyz/$endpoint");
      x = await http.post(uri,
          headers: {
            'Accept': 'application/json',
            "content-type": "application/json",
            // add token
            "Authorization": "Bearer $tokrn",
          },
          body: jsonEncode(body));
    } catch (e) {
      throw Exception(e.toString());
    }
    print(x.statusCode);
    // print(x.body);
    switch (x.statusCode) {
      case 200:
        return x;
      // break;
      default:
        throw ServerError(x);
    }
  }
}

Future<bool> requestPhoneStatePermission() async {
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    // طلب الإذن من المستخدم
    status = await Permission.phone.request();
    if (status.isGranted) {
      if (kDebugMode) {
        print("Permission granted");
      }
      return true;
    } else {
      if (kDebugMode) {
        print("Permission denied");
      }
      return false;
    }
  } else {
    if (kDebugMode) {
      print("Permission already granted");
    }
    return true;
  }
}
