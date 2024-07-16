import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/comment.dart';
import 'package:tigercashiraq/model/reel.dart';

class VideoController1 extends GetxController {
  RxList<Reel> videoInfo = <Reel>[].obs;
  var currentPage = 0.obs;
  var page = 1.obs;
  var comments = <Comment>[].obs;
  var isComment = false.obs;
  var contentText = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    getReel();
  }

  Future<void> getReel() async {
    try {
      final response =
          await ApiData.getToApi1("api/reel/index?page=${page.value}");

      final data = jsonDecode(response.body);
      final reels =
          List<Reel>.from(data["data"].map((json) => Reel.fromJson(json)));
      videoInfo.addAll(reels);
    } catch (e) {
      if (e is ServerError) {
        final errorData = jsonDecode(e.response.body);
        Get.snackbar("Error", errorData["message"]);
      } else {}
    }
  }

  void onPageChanged(int page) {
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
