import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:ggggg/controler/apidata.dart';
import 'package:ggggg/controler/home_controller.dart';
import 'package:ggggg/error/server_error.dart';
import 'package:ggggg/model/counter.dart';
import 'package:ggggg/view/widget/my_text.dart';
import 'package:http/http.dart' as http;

class CauntrsPage extends StatelessWidget {
  CauntrsPage({super.key});

  final CounterController _ = Get.put(CounterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('متجدر العدادات'),
        ),
        body: Column(children: [
          ListTile(
            title: MyText(
                titel: "متجر العدادات Tiger Cash",
                style: Theme.of(context).textTheme.titleLarge),
            subtitle: MyText(
                titel: "يمكنك شراء تطويرات العدادات من هنا",
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Image.asset("assets/logo.png"),
          ),
          Expanded(
            child: GetBuilder<CounterController>(
              init: CounterController(),
              initState: (_) {},
              builder: (_h) {
                return FutureBuilder(
                    future: _.getdataForomApi(),
                    builder: (context, snabshot) {
                      if (snabshot.hasError) {
                        return const Center(
                            child: Text('حدث خطا في جلب العدادات'));
                      }
                      if (snabshot.hasData) {
                        return ListView.builder(
                            itemCount: snabshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                child: ListTile(
                                  title: Text(snabshot.data![index].name),
                                  subtitle: Text(
                                      "الدنانير اليومية : ${snabshot.data![index].points}"),
                                  trailing: Text(
                                    "السعر : ${snabshot.data![index].price}",
                                  ),
                                  onTap: () {
                                    // here i want to show the  dialog
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (context) {});
                                    Get.defaultDialog(
                                        title: "تأكيد الشراء",
                                        content: Text(
                                          "هل أنت متأكد من شراء ${snabshot.data![index].name}",
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              // here i want to call the function
                                              try {
                                                var x = await _.buyItem(
                                                    snabshot.data![index].id);

                                                if (x.statusCode == 200) {
                                                  Get.snackbar("مبروك",
                                                      "تم شراء العداد بنجاح",
                                                      borderColor:
                                                          Colors.green);
                                                  String? counterAmount =
                                                      Get.find<HomeController>()
                                                          .user
                                                          .value
                                                          .counterAmount;

                                                  Get.find<HomeController>()
                                                          .user
                                                          .value
                                                          .counterAmount =
                                                      (int.parse(counterAmount!) +
                                                              int.parse(snabshot
                                                                  .data![index]
                                                                  .points))
                                                          .toString();
                                                } else {
                                                  Get.snackbar(
                                                      "خطأ",
                                                      jsonDecode(
                                                          x.body)["message"],
                                                      borderColor: Colors.red);
                                                }
                                              } catch (e) {
                                                Get.snackbar(
                                                    "خطا", e.toString(),
                                                    borderColor: Colors.red);
                                              }
                                              Get.back();
                                            },
                                            child: const Text("تاكيد الشراء"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("الغاء"),
                                          ),
                                        ]);
                                  },
                                ),
                              );
                            });
                      }
                      return const Center(child: CircularProgressIndicator());
                    });
              },
            ),
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
      // SmartDialog.showNotify(
      //     msg: "حدث خطا في عملية الشراح", notifyType: NotifyType.error);
      if (e is ServerError) {
        print(jsonDecode(e.response.body));
        // Get.snackbar("خطا", e.toString(), borderColor: Colors.red);
        SmartDialog.showNotify(
            msg: jsonDecode(e.response.body)["message"],
            notifyType: NotifyType.error);
      }
      // print(e);

      rethrow;
    }
  }
}
