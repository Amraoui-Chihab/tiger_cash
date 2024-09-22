import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Api Server/apidata.dart';
import '../controler/home_controller.dart';
import '../error/server_error.dart';
import '../model/counter.dart';
import 'widget/my_text.dart';

class CauntrsPage extends StatelessWidget {
  CauntrsPage({super.key});

  final CounterController _ = Get.put(CounterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('متجر العدادات'),
        ),
        body: Column(children: [
          ListTile(
            title: MyText(
                titel: "متجر العدادات بابل كاش",
                style: Theme.of(context).textTheme.titleLarge),
            subtitle: MyText(
                titel: "يمكنك شراء تطويرات العدادات من هنا",
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Image.asset("assets/icons/logo.jpg"),
          ),
          Expanded(
            child: GetBuilder<CounterController>(
  init: CounterController(),
  initState: (_) {},
  builder: (controller) {
    return FutureBuilder(
      future: controller.getdataForomApi(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Center(
            child: Text('حدث خطأ في جلب العدادات'),
          );
        }

        // Check if data is available
        if (snapshot.hasData) {
          final data = snapshot.data;

          if (data != null && data.isNotEmpty) {
            // Display ListView if data is not empty
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      "النقاط اليومية : ${item.points}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      "السعر : ${item.price}",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    onTap: () {
                      // Show confirmation dialog
                      Get.defaultDialog(
                        title: "تأكيد الشراء",
                        content: Text(
                          "هل أنت متأكد من شراء ${item.name}؟",
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                var response = await controller.buyItem(item.id);

                                if (response.statusCode == 200) {
                                  Get.snackbar(
                                    "مبروك",
                                    "تم شراء العداد بنجاح",
                                    borderColor: Colors.green,
                                  );
                                  String? counterAmount = Get.find<HomeController>().user.value.counterAmount;
                                  Get.find<HomeController>().user.value.counterAmount =
                                      (int.parse(counterAmount!) ).toString();
                                } else {
                                  Get.snackbar(
                                    "خطأ",
                                    jsonDecode(response.body)["message"],
                                    borderColor: Colors.red,
                                  );
                                }
                              } catch (e) {
                                Get.snackbar(
                                  "خطأ",
                                  e.toString(),
                                  borderColor: Colors.red,
                                );
                              }
                              Get.back();
                            },
                            child: const Text("تأكيد الشراء"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("إلغاء"),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          } else {
            // Display message when no counters are available
            return const Center(
              child: Text('لا يوجد عدادات'),
            );
          }
        }

        // Display loading indicator when data is not yet available
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  },
)
,
          )
        ]));
  }
}

class CounterController extends GetxController {
  Future<List<Counter>> getdataForomApi() async {
    http.Response x;
    try {
      x = await ApiData.getToApi("api/counter/index");
      List<Counter> counters = [];
      for (var item in jsonDecode(x.body)) {
        counters.add(Counter.fromJson(item));
      }
      return counters;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> buyItem(int id) async {
    http.Response x;
    try {
      x = await ApiData.postToApiCauntrs(
          "api/counter/buy", {"id": id.toString()});
      SmartDialog.showNotify(
          msg: "تم شراء العداد بنجاح", notifyType: NotifyType.success);

      Get.back();
      return x;
    } catch (e) {
      if (e is ServerError) {
        SmartDialog.showNotify(
            msg: jsonDecode(e.response.body)["message"],
            notifyType: NotifyType.error);
      }
      rethrow;
    }
  }
}
