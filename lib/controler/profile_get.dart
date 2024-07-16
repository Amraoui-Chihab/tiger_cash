import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../model/user.dart';
import '../Api Server/apidata.dart';

class Profile extends GetxController {
  User user = User();
  var isloading = false.obs;
  var nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    getdata();
  }

  Future setUserName() async {
    await ApiData.postToApiCauntrs("api/user/update", {
      "name": nameController.text,
    });
  }

  Future addPhotoFromGallery(XFile pickedFile) async {
    GetStorage box = GetStorage();
    // User user = User.fromJson(box.read("user"));
    String tokrn = box.read("token");

    try {
      var postUri = Uri.parse('${ApiData.baseUrl}/api/user/update');
      http.MultipartRequest request = http.MultipartRequest("POST", postUri);
      request.headers.addAll(
          {"Accept": "application/json", "Authorization": "Bearer $tokrn"});
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('photo', pickedFile.path);
      // request.fields.addAll({
      // });

      request.files.add(multipartFile);
      var x = await request.send();
      switch (x.statusCode) {
        case 200:
          return x;
        default:
          throw (jsonDecode(await x.stream.bytesToString())["message"]);
      }
    } catch (e) {
      throw Exception(e);
    }
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
