import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user.dart';
import 'apidata.dart';

class TreansfersController extends GetxController {
  Rx<TextEditingController> userId = TextEditingController().obs;
  Rx<TextEditingController> amount = TextEditingController().obs;
  Rx<TextEditingController> subamount = TextEditingController().obs;
  RxString dvsdr = "0".obs;
  RxString costTran = "0".obs;
  RxString maxTran = "0".obs;
  RxString minTran = "0".obs;
  RxString dvsdr4 = "0".obs;
  final Rx<User> user = User().obs;

  @override
  void onInit() {
    super.onInit();
    getuserInfo();
    generalInformation();
  }

  Future getuserInfo() async {
    try {
      var x = await ApiData.getToApi("api/user/viewMy");
      User userz = User.fromJson(jsonDecode(x.body)["data"]);
      user.value = userz;
    } catch (e) {
      throw Exception("ggggg");
    }
  }

  Future sendMoney() async {
    await ApiData.postToApi("api/transction/make", {
      "user_id": userId.value.text,
      "amount": amount.value.text,
    });
    getuserInfo();
  }

  Future generalInformation() async {
    try {
      var response = await ApiData.getToApi("api/generalInformation/get");
      final data = jsonDecode(response.body);
      dvsdr.value = data["عدد النقاط لكل دولار"].toString();
      costTran.value = data["عمولة التحويل"].toString();
      maxTran.value = data["اعلى حد للتحويل"].toString();
      minTran.value = data["اقل حد للتحويل"].toString();
      print(data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
