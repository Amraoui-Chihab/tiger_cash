import 'dart:convert';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:ggggg/model/apiconst.dart';
// import 'package:device_information/device_information.dart';
import 'package:device_imei/device_imei.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as http;
import 'package:tigercashiraq/model/product.dart';

import '../error/server_error.dart';

//   https://tigercashiraq.xyz
//   http://192.168.40.1:8000

class ApiData {
  static const String baseUrl = 'https://bybloncash.fun/public';
  // static const String baseUrl = 'http://192.168.40.1:8000';
  static Future<http.Response> postToApi(
      String endpoint, Map<String, String> body) async {
    http.Response x;
    GetStorage box = GetStorage();
    // User user = User.fromJson(box.read("user"));
    String tokrn = box.read("token");

    try {
      Uri uri = Uri.parse("$baseUrl/$endpoint");
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
      Uri uri = Uri.parse("$baseUrl/$endpoint");
      x = await http.get(uri, headers: {
        'Accept': 'application/json',
        "content-type": "application/json",
        // add token
        "Authorization": "Bearer $tokrn",
      });
    } catch (e) {
      throw Exception(e.toString());
    }
    // print(jsonDecode(x.body));
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
      Uri uri = Uri.parse("$baseUrl/$endpoint");
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
    // print(x.statusCode);
    // print(jsonDecode(x.body));
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

      // String imei = await DeviceImei.
      Uri uri = Uri.parse("$baseUrl/api/user/getToken");
      x = await http.post(uri,
          headers: {
            'Accept': 'application/json',
            "content-type": "application/json",
          },
          body: code == null
              ? jsonEncode({
                  "access_token": endpoint,
                  "device_id": imeiNo,
                  "version": "1"
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
      Uri uri = Uri.parse("$baseUrl/$endpoint");
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

    switch (x.statusCode) {
      case 200:
      case 201:
        return x;
      // break;
      default:
        throw ServerError(x);
    }
  }

  static Future<void> addPhotoFromGallery(
      var pickedFile, Product product) async {
    GetStorage box = GetStorage();
    String tokrn = box.read("token");

    if (pickedFile != null) {
      try {
        var postUri = Uri.parse('$baseUrl/api/product/create');
        http.MultipartRequest request = http.MultipartRequest("POST", postUri);
        request.headers.addAll(
            {"Accept": "application/json", "Authorization": "Bearer $tokrn"});
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath('photo', pickedFile.path);
        request.fields.addAll({
          "name": product.name!,
          "description": product.description!,
          "quntity": product.quntity!,
          "price": product.price!,
          "type": product.type!,
        });

        request.files.add(multipartFile);
        await request.send();
      } catch (e) {
        throw Exception(e);
      }
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
