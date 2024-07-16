import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/sub_many_controller.dart';

class SubMany extends StatelessWidget {
  SubMany({super.key});

  final controller = Get.put(SubManyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Text("data"),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            controller.getdata();
          },
          child: ListView.builder(
              itemCount: controller.subMany.length,
              itemBuilder: (context, index) {
                String state = controller.subMany[index].state.toString();
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                                controller.subMany[index].type.toString() ==
                                        "zain_cash"
                                    ? "assets/zain.jpg"
                                    : "assets/master.jpg"),
                          )),
                    ),
                    //  CircleAvatar(
                    //   backgroundImage: AssetImage(
                    //       controller.subMany[index].type.toString() ==
                    //               "zain_cash"
                    //           ? "assets/zain.jpg"
                    //           : "assets/master.jpg"),
                    // ),
                    title: Text("المبلغ: ${controller.subMany[index].cost}"),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "${controller.subMany[index].type == "zain_cash" ? "رقم المحفظة :" : "رقم البطاقة :"}${controller.subMany[index].cardNumber}"),
                        Text(
                            "تاريخ الارسال : ${controller.subMany[index].createdAt.toString().substring(0, 10)}"),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 17),
                      decoration: BoxDecoration(
                        color: state == "pending"
                            ? Colors.orange
                            : state == "approved"
                                ? Colors.green
                                : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(state == "pending"
                          ? "قيد الانتظار"
                          : state == "approved"
                              ? "تمت الموافقة"
                              : "تم الرفض"),
                    ),
                  ),
                );
              }),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // controller.addSubMany(SubManyModel(name: "name", email: "email"));
          Get.dialog(
            AlertDialog(
              title: const Text("طلب سحب الارباح"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller.subManyNameController.value,
                    decoration: const InputDecoration(
                      hintText: "اسم المستلم",
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  TextField(
                    controller: controller.subManyEmailController.value,
                    decoration: const InputDecoration(
                      hintText: "ادخل مبلغ السحب",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("نوع البطاقة")),
                      Obx(() => DropdownButton(
                          hint:
                              Text(controller.subManyCurrency.value.toString()),
                          items: const [
                            DropdownMenuItem(
                              value: "zain_cash",
                              child: Text("زين كاش"),
                            ),
                            DropdownMenuItem(
                              value: "master_card",
                              child: Text("ماستر كارد الرافدين"),
                            ),
                          ],
                          onChanged: (value) {
                            controller.subManyCurrency.value = value!;
                          })),
                    ],
                  ),
                  TextField(
                    controller: controller.subManyAmountController.value,
                    decoration: const InputDecoration(
                      hintText: "رقم البطاقة",
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      SmartDialog.showLoading();
                      await controller.moneyReqest();
                      SmartDialog.dismiss();
                      Get.snackbar(
                          "تم ارسال الطلب", "يرجى الانتظار للموافقة على الطلب",
                          backgroundColor: Colors.green);
                    } catch (e) {
                      SmartDialog.dismiss();
                      Get.snackbar("خطا", e.toString(),
                          backgroundColor: Colors.red);
                    }
                  },
                  child: const Text("طلب"),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("الغاء"),
                ),
              ],
            ),
          );
        },
        // backgroundColor: Colors.amber,
        tooltip: "اضافة طلب سحب جديد",
        child: const Icon(Icons.add),
      ),
    );
  }
}
