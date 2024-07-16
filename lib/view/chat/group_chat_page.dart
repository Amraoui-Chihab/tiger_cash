import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:startapp_sdk/startapp.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'chat_screen.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({super.key});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  var startAppSdk = StartAppSdk();

  StartAppRewardedVideoAd? rewardedVideoAd;
  final HomeController homeController = Get.find();
  @override
  void initState() {
    super.initState();
    startAppSdk.setTestAdsEnabled(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' الترفيه '),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('كروب الدردشة العام'),
              subtitle: const Text('يرجى الالتزام بالقواعد العامة'),
              onTap: () {
                Get.to(() => ChatScreen());
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('الاعلانات اليومية'),
              subtitle: const Text('شاهد الاعلانات لربح نقاط اضافية'),
              onTap: () async {
                SmartDialog.showLoading();
                setState(() {
                  rewardedVideoAd?.dispose();
                  rewardedVideoAd = null;
                });
                try {
                  rewardedVideoAd = await loadRewardedVideoAd();
                  rewardedVideoAd!.show().onError((error, stackTrace) {
                    debugPrint("Error showing Rewarded Video ad: $error");
                    return false;
                  });
                } catch (e) {
                  debugPrint("Error showing Rewarded Video ad: $e");
                }
                SmartDialog.dismiss();
                if (rewardedVideoAd != null) {}
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<StartAppRewardedVideoAd> loadRewardedVideoAd() async {
    try {
      return await startAppSdk.loadRewardedVideoAd(
        onAdNotDisplayed: () {
          debugPrint('onAdNotDisplayed: rewarded video');
          Get.snackbar("خطا", "فشل عملية تشغيل الاعلان",
              backgroundColor: Colors.red);
        },
        onAdHidden: () {
          // Get.snackbar("خطا", "يجب عليك مشاهدة الاعلان بشكل كامل",
          //     backgroundColor: Colors.red);
        },
        onVideoCompleted: () {
          debugPrint(
              'onVideoCompleted: rewarded video completed, user gain a reward');
          setState(() async {
            try {
              var x = await ApiData.getToApi("api/reward/get");
              Get.snackbar(
                  "نجح", "لقد حصلت على ${jsonDecode(x.body)["cost"]} نقطة");
              // homeController.user.value.balance =
              //     (int.parse(homeController.user.value.balance.toString()) +
              //             int.parse(jsonDecode(x.body)["cost"].toString()))
              //         .toString();
            } catch (e) {
              Get.snackbar("خطا", "حصلت مشكلة في الحصول على المكافأه",
                  backgroundColor: Colors.red);
            }
          });
        },
      );
    } catch (e) {
      Get.snackbar("خطا", "حصلت مشكلة في تحميل الاعلان",
          backgroundColor: Colors.red);
      rethrow;
    }
  }
}
