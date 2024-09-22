import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'package:tigercashiraq/controler/store_getx.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/product.dart';
import 'package:tigercashiraq/utl/colors.dart';

class ProductDetailsPage extends StatelessWidget {
  final int index;

  const ProductDetailsPage({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    StoreController c=Get.put(StoreController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              c.products[index].image!,
              // fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "إسم المنتج :${c.products[index].name}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "سعر المنتج :\$${c.products[index].price} نقطة",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'التفاصيل',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c.products[index].description!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      int.parse(c.products[index].price!) != 0
                          ? Text(
                              "  عدد أشهر التقسيط :${c.products[index].month}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text("هذا المنتج بدون تقسيط"),
                      const SizedBox(height: 8),
                      Text("الكمية : " + c.products[index].quntity!),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your buy now logic here
                        showToBuy();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Ccolors.secndry,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'اطلب الان',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showToBuy() async {
    HomeController home_controller = Get.find<HomeController>();
    ProductdetailsGetx controlr = Get.put(ProductdetailsGetx());
     StoreController det_controller = Get.find<StoreController>();
    if (int.parse(home_controller.user.value.counterAmount!) <
        int.parse(det_controller.products[index].price!)) {
      Get.snackbar("Notification", "لا تمتلك عداد كافي لشراء هذا المنتج",
          backgroundColor: Colors.red);
    } else {
      final _formKey = GlobalKey<FormState>();

      Get.dialog(
        AlertDialog(
          title: const Text('طلب الشراء الان'),
          content: Expanded(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('يرجى ادخل معلومات لاكمال طلب الشراء'),
              // Text('Product Name: ${product.name}'),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      initialValue: home_controller.user.value.name,
                      decoration: InputDecoration(
                        labelText: 'الاسم',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: controlr.adress.value,
                      decoration: InputDecoration(
                        labelText: 'العنوان',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال العنوان';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        controlr.adress.value.text = value;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: controlr.phone.value,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رقم الهاتف';
                        } 
                        return null;
                      },
                      onChanged: (value) {
                        controlr.phone.value.text = value;
                      },
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with further actions
                        try {
                          SmartDialog.showLoading();
                          await controlr.sendToApi(det_controller.products[index].id!.toString());
                          det_controller.fetchProducts();
                          SmartDialog.dismiss();
                          Get.back();
                          Get.snackbar("نجاج", "جار معالجة طلبك",backgroundColor: Colors.green);
                        } catch (e) {
                          SmartDialog.dismiss();
                          Get.back();
                          if (e is ServerError) {
                            Get.snackbar(
                                "خطا", jsonDecode(e.response.body)["message"],
                                backgroundColor: Colors.red);
                          }
                        }
                      }
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Cancel')),
                ],
              )
            ],
          ),)
        ),
      );
    }
  }
}

class ProductdetailsGetx extends GetxController {
  HomeController C=Get.find<HomeController>();
  final product = Product().obs;
  Rx<TextEditingController> name = TextEditingController().obs;
  Rx<TextEditingController> adress = TextEditingController().obs;
  Rx<TextEditingController> phone = TextEditingController().obs;

  Future sendToApi(String id) async {
    //api call here
    await ApiData.postToApiCauntrs("api/proudctPay/create", {
      "product_id": id.toString(),
      'user_id': int.parse(C.user.value.id!.toString()),
      'location': adress.value.text.toString(),
      "phone_number": phone.value.text.toString(),
    });
  }
}
