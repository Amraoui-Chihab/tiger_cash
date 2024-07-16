import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/product.dart';
import 'package:tigercashiraq/utl/colors.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
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
              product.image!,
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
                        product.name!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${product.price}',
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
                        product.description!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
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

  Future<dynamic> showToBuy() {
    ProductdetailsGetx controlr = Get.put(ProductdetailsGetx());
    return Get.dialog(
      AlertDialog(
        title: const Text('طلب الشراء الان'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('يرجى ادخل معلومات لاكمال طلب الشراء'),
            // Text('Product Name: ${product.name}'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controlr.name.value,
              decoration: InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                controlr.name.value.text = value;
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
              onChanged: (value) {
                controlr.phone.value.text = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                SmartDialog.showLoading();
                await controlr.sendToApi(product.id!.toString());
                SmartDialog.dismiss();
                Get.back();
                Get.snackbar("نجاج", "تمت عمليت الشراء بنجاج");
              } catch (e) {
                SmartDialog.dismiss();
                Get.back();
                if (e is ServerError) {
                  Get.snackbar("خطا", jsonDecode(e.response.body)["message"],
                      backgroundColor: Colors.red);
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
      ),
    );
  }
}

class ProductdetailsGetx extends GetxController {
  final product = Product().obs;
  Rx<TextEditingController> name = TextEditingController().obs;
  Rx<TextEditingController> adress = TextEditingController().obs;
  Rx<TextEditingController> phone = TextEditingController().obs;

  Future sendToApi(String id) async {
    //api call here
    await ApiData.postToApiCauntrs("api/proudctPay/create", {
      "product_id": id.toString(),
      'name': name.value.text.toString(),
      'location': adress.value.text.toString(),
      "phone_number": phone.value.text.toString(),
    });
  }
}
