import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../controler/treansfers_controller.dart';
import '../utl/colors.dart';

class TransfersPage extends StatelessWidget {
  TransfersPage({super.key});

  final TreansfersController controller = Get.put(TreansfersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Center(
                  child: SuccessWidget(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'حول النقاط الى اي حساب',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          "نقاطك الاجمالية : ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Obx(() => Text(
                          '${controller.user.value.balance}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0), // Margin horizontal
                      child: TextFormField(
                        controller: controller.userId.value,
                        decoration: InputDecoration(

                          labelText: 'كود الاحالة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Ajout du borderRadius
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent, // Couleur de la bordure
                              width: 2.0, // Taille de la bordure
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors
                                  .lightBlueAccent, // Couleur de la bordure quand le champ est sélectionné
                              width: 2.0, // Taille de la bordure en mode focus
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          controller.userId.value.text = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'مبلغ الإرسال',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Ajout du borderRadius
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent, // Couleur de la bordure
                              width: 2.0, // Taille de la bordure
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors
                                  .lightBlueAccent, // Couleur de la bordure quand le champ est sélectionné
                              width: 2.0, // Taille de la bordure en mode focus
                            ),
                          ),
                        ),
                        controller: controller.amount.value,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          controller.amount.value.text = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Si vous voulez aligner le bouton à droite du Row
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.userId.value.text.isEmpty ||
                            controller.amount.value.text.isEmpty) {
                          Get.snackbar(
                            "خطأ",
                            "الرجاء إدخال كود الإحالة ومبلغ الإرسال",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        // Afficher le dialogue de confirmation
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("تأكيد الحوالة"),
                              content: Text(
                                  "هل أنت متأكد من إرسال ${controller.amount.value.text} إلى ${controller.userId.value.text}?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("إلغاء"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      SmartDialog.showLoading();
                                      await controller.sendMoney();
                                      SmartDialog.dismiss();
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context)
                                          .pop(); // Fermer la boîte de dialogue de confirmation
                                      Get.snackbar(
                                          "تهانيئا", "تمت العملية بنجاح",
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white);
                                      controller.amount.value.clear();
                                      controller.userId.value.clear();
                                    } catch (e) {
                                      SmartDialog.dismiss();
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context)
                                          .pop(); // Fermer la boîte de dialogue de confirmation
                                      var x = jsonDecode(e.toString());
                                      Get.snackbar("خطأ", x["message"],
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white);
                                    }
                                  },
                                  child: const Text("تأكيد"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.lightBlueAccent, // Couleur de fond blanche
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            // Ajout de la bordure violette
                            color: Colors.lightBlueAccent,
                            width: 2, // Taille de la bordure
                          ),
                        ),
                      ),
                      child: const Text(
                        'تحويل المبلغ',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 280,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ملاحظات التحويل",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: Text(
                        " اقصى حد للتحويل هو :  ${controller.maxTran}",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Text("\n  اقل حد للتحويل هو :  ${controller.minTran}"),
                    Text(
                        "\n عمولة التحويل هي :  ${controller.costTran} % من اجمالي المبلغ المرسل. "),
                    Text("\n يمكنك التحويل مرة واحدة في اليوم."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue[300],
        border: Border(top: BorderSide.none),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(12),
            child: Image.asset(
              "assets/transaction.png",
              width: 40,
              height: 40,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'الحوالات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
