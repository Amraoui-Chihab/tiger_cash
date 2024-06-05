import 'dart:convert';

import 'package:get/get.dart';
import 'package:ggggg/controler/apidata.dart';
import 'package:ggggg/model/user.dart';

class Profile extends GetxController {
  User user = User();
  @override
  void onInit() {
    super.onInit();
    getdata();
  }

  Future getdata() async {
    try {
      var x = await ApiData.getToApi("api/user/viewMy");
      var i = jsonDecode(x.body);
      user = User.fromJson(i["data"]);
      update();
    } catch (e) {
      rethrow;
    }
  }
}
