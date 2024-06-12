import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/user.dart';
import 'apidata.dart';

class HomeController extends GetxController {
  GetStorage box = GetStorage();
  Rx<User> user = User().obs;
  RxInt time = 0.obs;
  RxBool istimeon = false.obs;

  @override
  void onInit() {
    super.onInit();
    getuserInfo();
  }

  Future getuserInfo() async {
    try {
      var x = await ApiData.getToApi("api/user/viewMy");
      time.value = jsonDecode(x.body)["rest_time"];
      user.value = User.fromJson(jsonDecode(x.body)["data"]);
      timeon();
    } catch (e) {
      rethrow;
    }
  }

  Future active() async {
    await ApiData.postToApi("api/counter/active_counter", {});
    time.value = 86400;
    user.value.balance =
        (int.parse(user.value.balance!) + int.parse(user.value.counterAmount!))
            .toString();
  }

  timeon() {
    // SheckTime().setboot(time.value);
    // getx find SheckTime to setboot
    SheckTime controller = Get.find<SheckTime>();
    controller.setboot(time.value);
    Timer.periodic(const Duration(seconds: 1), (e) {
      if (time.value > 0) {
        time.value = time.value - 1;
        // istimeon.value = false;
      } else {
        istimeon.value = true;
        // update();
      }
      // print(time.value);
    });
  }

  Future<List<String>> getImigeFromeApi() async {
    // ignore: prefer_typing_uninitialized_variables
    var response;
    try {
      response = await ApiData.getToApi("api/photos/index");
    } catch (e) {
      throw Exception(e);
    }
    // print(jsonDecode(response.body)["data"]);
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)["data"]);
      List<String> imageList = [];
      var jsonData = jsonDecode(response.body);
      for (var element in jsonData["data"]) {
        imageList.add(element['photo_url']);
      }
      return imageList;
    } else {
      throw Exception('Failed to load images');
    }
  }
}

class SheckTime extends GetxController {
  bool x = false;
  setboot(int v) {
    if (v == 0) {
      x = true;
    } else {
      x = false;
    }
    update();
  }
}
