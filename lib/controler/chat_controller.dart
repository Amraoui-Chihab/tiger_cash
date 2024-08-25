import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/model/message.dart';
import 'package:tigercashiraq/model/user.dart';
import 'package:tigercashiraq/view/block_page.dart';

class ChatController extends GetxController {
  var messages = <Message>[].obs;
  final Rx<User> user = User().obs;

  @override
  void onInit() {
    super.onInit();
    getuserInfo().then(
      (value) => loadMessages(),
    );
    // loadMessages();
  }

  // Future getuserInfo() async {
  //   try {
  //     var x = await ApiData.getToApi("api/user/viewMy");
  //     User userz = User.fromJson(jsonDecode(x.body)["data"]);
  //     user.value = userz;
  //   } catch (e) {
  //     throw Exception("ggggg");
  //   }
  // }

  Future getuserInfo() async {
    try {
      var x = await ApiData.getToApi("api/user/viewMy");
      user.value = User.fromJson(jsonDecode(x.body)["data"]);
      if (jsonDecode(x.body)["block"]["is_blocked"]) {
        Get.snackbar("خطا", "لقد تم حضرك من التطبيق",
            backgroundColor: Colors.red);
        Get.offAll(() => BlockPage(
              time: jsonDecode(x.body)["block"]["seconds_rest"],
            ));
      }
    } catch (e) {
      rethrow;
    }
  }

  void loadMessages() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(25)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => Message.fromDocumentSnapshot(doc))
          .toList();
    });
    db.settings = const Settings(persistenceEnabled: false);
  }
}
