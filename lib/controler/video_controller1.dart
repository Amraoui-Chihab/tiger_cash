import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/comment.dart';
import 'package:tigercashiraq/model/reel.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class VideoController1 extends GetxController {
  RxList<Reel> videoInfo = <Reel>[].obs;

  var currentPage = 0.obs;
  var page = 1.obs;
  var comments = <Comment>[].obs;
  var isComment = false.obs;
  var contentText = TextEditingController().obs;

  Rx<int> support = 0.obs;

  @override
  void onInit() {
    super.onInit();

    getReel();
  }

  Future<RxList<Reel>> getReel() async {
    try {
      // Fetch data from the API
      final response =
          await ApiData.getToApi1("api/reel/index?page=${page.value}");
      
      // Decode the response body
      final data = jsonDecode(response.body);

      // Ensure 'data["data"]' is a List and convert each item to a Reel object
      final List<dynamic> dynamicReels = data["data"];
      final List<Reel> reels =
          dynamicReels.map((json) => Reel.fromJson(json)).toList();

      if (reels.isEmpty) {
        // Handle the case where no reels are returned
      } else {
        // If there are reels, add them to videoInfo

        videoInfo.addAll(reels);

        //   print(await fetchSupport(int.parse(videoInfo[currentPage.value].userId)));
      }

      // Return the updated RxList
      videoInfo.sort((a, b) => b.likes.compareTo(a.likes));
      return videoInfo;
    } catch (e) {
      if (e is ServerError) {
        final errorData = jsonDecode(e.response.body);
        Get.snackbar("Error", errorData["message"]);
      } else {}

      // Return the RxList, which might be empty or in an error state

      return videoInfo;
    }
  }

  Future<int> fetchSupport(int userId) async {
    print(userId);
    print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    GetStorage box = GetStorage();
    // User user = User.fromJson(box.read("user"));
    String tokrn = box.read("token");
    try {
      final response = await http.post(
          Uri.parse('https://bybloncash.fun/public/api/support'),
          headers: {
            'Accept': 'application/json',
            "content-type": "application/json",
            // add token
            "Authorization": "Bearer $tokrn",
          },
          body: jsonEncode({
            "id": userId,
          }));
      if (response.statusCode == 200) {
        // Successfully got a response
        var data = jsonDecode(response.body);
        print('Response data: $data');
        return int.parse(data['total_cost']);
      } else {
        print(response.body);
        // Handle errors
        print('Request failed with status: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  void onPageChanged(int page) async {
    currentPage.value = page;
    if (page == videoInfo.length - 1) {
      this.page.value = this.page.value + 1;
      getReel();
    }
  }

  Future<void> addLikes(String id, bool islike, int index) async {
    try {
      if (islike) {
        await ApiData.postToApiCauntrs("api/reel/like/delete", {"id": id});
        videoInfo[index].isLiked = false;
        videoInfo[index].likes -= 1;
      } else {
        await ApiData.postToApiCauntrs("api/reel/like/create", {"reel_id": id});
        videoInfo[index].isLiked = true;
        videoInfo[index].likes += 1;
      }
    } catch (e) {
      if (e is ServerError) {
        final errorData = jsonDecode(e.response.body);
        throw errorData["message"];
      } else {
        rethrow;
      }
    }
  }

  Future<void> addComment(String id, String content) async {
    try {
      await ApiData.postToApiCauntrs("api/reel/comment/create", {
        "reel_id": id,
        "content": content,
      });
    } catch (e) {
      if (e is ServerError) {
        final errorData = jsonDecode(e.response.body);
        throw errorData["message"];
      } else {
        rethrow;
      }
    }
  }

  Future<List<Comment>> getComment(String id) async {
    try {
      final response =
          await ApiData.getToApi1("api/reel/comment/index?reel_id=$id");
          
        
      final data = jsonDecode(response.body);
      print(data);
      print("DATA DATA DATA DATA DATA");
      
      final comments = List<Comment>.from(
          data["data"].map((json) => Comment.fromJson(json)));
      this.comments.clear();
      this.comments.addAll(comments);
      return this.comments;
    } catch (e) {
      if (e is ServerError) {
        final errorData = jsonDecode(e.response.body);
        throw errorData["message"];
      } else {
        rethrow;
      }
    }
  }
}
