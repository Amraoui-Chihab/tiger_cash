import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/gift.dart';

class GiftController extends GetxController {
  Future<List<dynamic>> getgift() async {
    try {
      var response = await ApiData.getToApi1("api/gift/index");
      final jsonData = jsonDecode(response.body);
      List<dynamic> data =
          jsonData["data"].map((json) => Gift.fromJson(json)).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future sendgift(String giftId, String userId, String reel_id) async {
    try {
      SmartDialog.showLoading();
      var response = await ApiData.postToApiCauntrs("api/gift/buy",
          {"gift_id": giftId, "user_id": userId, "reel_id": reel_id});
      // controller.user.value.balance=int.parse(controller.user.value.balance)-int.parse(source)

      // Get.snackbar("نجاح", "تم ارسال الهدية بنجاح");
      SmartDialog.showNotify(
          msg: "تم ارسال الهدية بنجاح", notifyType: NotifyType.success);
    } catch (e) {
      if (e is ServerError) {
        Get.back();
        Get.snackbar("خطا", jsonDecode(e.response.body)["message"],
            backgroundColor: Colors.red);
      } else {
        Get.back();
        Get.snackbar("خطا", e.toString(), backgroundColor: Colors.red);
      }
    } finally {
      SmartDialog.dismiss();
    }
  }
}
