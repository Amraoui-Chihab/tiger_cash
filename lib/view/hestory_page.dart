import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/history.dart';
import 'package:tigercashiraq/model/user.dart';

class HestoryPage extends StatelessWidget {
  HestoryPage({super.key, required this.user});
  final controller = Get.put(HestoryController());
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل العمليات المالية'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isloding.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.tame.isNotEmpty) {
          return ListView.builder(
              controller: controller.listController,
              itemCount: controller.tame.length,
              itemBuilder: (context, index) {
                String data = chackData(
                        controller.tame[index].ownerId, user.id.toString())
                    .toString();
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: data == "تحويل"
                            ? Colors.red
                            : data == "استلام"
                                ? Colors.green
                                : null,
                        child:
                            // data == "تفعيل العداد"
                            //     ? Icon(Ic)
                            // :
                            Icon(data == "تحويل"
                                ? Icons.arrow_upward
                                : data == "استلام"
                                    ? Icons.arrow_downward
                                    : Icons.access_time),
                      ),
                      title: Text(
                        data,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: data == "تفعيل العداد"
                          ? Text(" ")
                          : Text(
                              data == "تحويل"
                                  ? "الى صاحب كود الاحالة : ${controller.tame[index].userId}"
                                  : "من قبل صاحب كود الاحالة : ${controller.tame[index].ownerId}",
                              style: const TextStyle(fontSize: 15),
                            ),
                      trailing: Text(
                        // "TCI " +
                        "${controller.tame[index].amount} TCI\n${controller.tame[index].createdAt.substring(0, 10)}",
                        style: const TextStyle(fontSize: 15),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                        color: Colors.grey.shade300,
                      ),
                    )
                  ],
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

String chackData(String id, String myid) {
  if (id == myid) {
    return "تحويل";
  } else if (id == "1") {
    return "تفعيل العداد";
  } else {
    return "استلام";
  }
}

class HestoryController extends GetxController {
  List<dynamic> tame = <dynamic>[].obs;
  RxBool isloding = false.obs;
  var listController = ScrollController();
  RxInt page = 1.obs;

  @override
  void onInit() {
    super.onInit();
    frishdata();
    oo();
  }

  Future frishdata() async {
    // isloding.value = true;
    try {
      final response =
          await ApiData.getToApi1("api/transactions/get?page=$page");
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      // tame.clear();
      List<dynamic> data = jsonData["data"]
          .map((json) => History.fromDocumentSnapshot(json))
          .toList();
      print(data);
      tame.addAll(data);
      isloding.value = false;
    } catch (e) {
      if (e is ServerError) {
        print(e.response.body);
      }
      isloding.value = false;
      print(e);
    }
  }

  Future oo() async {
    listController.addListener(() {
      if (listController.position.atEdge) {
        print("1");
        if (listController.position.pixels != 0) {
          print("2");
          print(page.value);
          page.value++;
          frishdata();
        }
      }
    });
  }
}
