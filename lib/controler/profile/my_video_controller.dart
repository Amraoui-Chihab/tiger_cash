import 'dart:convert';
import 'package:get/get.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/reel.dart';

class MyVideoController extends GetxController {
  RxList<Reel> videos = <Reel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future getData() async {
    try {
      isLoading(true);
      final response = await ApiData.getToApi1("api/reel/index_my");
      final data = jsonDecode(response.body);
      final reels =
          List<Reel>.from(data["data"].map((json) => Reel.fromJson(json)));
      videos.value = reels;
    } catch (e) {
      if (e is ServerError) {
        final errorData = jsonDecode(e.response.body);
        Get.snackbar("Error", errorData["message"]);
      } else {}
    } finally {
      isLoading(false);
    }
  }

  Future deleteVideo(int id) async {
    try {
      isLoading(true);
      final response = await ApiData.postToApiCauntrs("api/reel/delete/", {
        "reel_id": id.toString(),
      });
      jsonDecode(response.body);
      Get.snackbar("نجاج", "تم حذف الفديو");
    } catch (e) {
      if (e is ServerError) {
        final errorData = jsonDecode(e.response.body);
        Get.snackbar("خطا", errorData["message"]);
      } else {}
    } finally {
      isLoading(false);
    }
  }
}
