import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user.dart';
import 'apidata.dart';

class TreansfersController extends GetxController {
  Rx<TextEditingController> userId = TextEditingController().obs;
  Rx<TextEditingController> amount = TextEditingController().obs;
  final Rx<User> user = User().obs;

  @override
  void onInit() {
    super.onInit();
    getuserInfo();
  }

  Future getuserInfo() async {
    try {
      var x = await ApiData.getToApi("api/user/viewMy");
      User userz = User.fromJson(jsonDecode(x.body)["data"]);
      user.value = userz;
      // await box.write("user", user);
    } catch (e) {
      throw Exception("ggggg");
    }
  }

  Future sendMoney() async {
    //api call to send amount
    // http.Response x;
    // try {
    await ApiData.postToApi("api/transction/make", {
      "user_id": userId.value.text,
      "amount": amount.value.text,
    });
    getuserInfo();
    // } catch (e) {
    //   rethrow;
    //   // rethrow Exception();
    // }
    // switch (x.statusCode) {
    //   case 200:
    //     break;
    //   default:
    //     var mass = jsonDecode(x.body);
    //     print("==11111111111111111111111111======");
    //     throw Exception(mass["message"]);
    // }
  }
}
