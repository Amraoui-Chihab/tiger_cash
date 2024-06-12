import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tigercashiraq/controler/apidata.dart';
import 'package:tigercashiraq/model/product.dart';
import 'package:tigercashiraq/model/proudct_pay.dart';

class MyItimPage extends StatelessWidget {
  const MyItimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("معرض منتوجاتي"),
      ),
      body: GetBuilder<MyItimGetx>(
          init: MyItimGetx(),
          builder: (context) {
            return FutureBuilder(
                future: context.fetchProducts(),
                builder: (context1, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context1, index) {
                        return ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: snapshot.data![index].image,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: SizedBox(
                                // width: 70,
                                // height: 70,
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          title: Text(snapshot.data![index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(snapshot.data![index].price),
                              Text(snapshot.data![index].quntity),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text("تأكيد الحذف"),
                                    content: const Text(
                                        "هل أنت متأكد من حذف المنتج"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            SmartDialog.showLoading();
                                            await context.deleteProduct(
                                                snapshot.data![index].id);
                                            SmartDialog.dismiss();
                                            Get.back();
                                            Get.snackbar(
                                                "نجاج", "تم الحذف بنجاح");
                                          } catch (e) {
                                            SmartDialog.dismiss();
                                            Get.back();
                                            Get.snackbar(
                                                "نجاج", "تم الحذف بنجاح",
                                                backgroundColor: Colors.red);
                                          }
                                        },
                                        child: const Text("نعم"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text("لا"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              )),
                          onTap: () {
                            Get.to(() => ViewProudCtpay(
                                  id: snapshot.data![index].id,
                                ));
                          },
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                });
          }),
    );
  }
}

class ViewProudCtpay extends StatelessWidget {
  const ViewProudCtpay({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("قائمة العروض"),
        ),
        body: GetBuilder<MyItimGetx>(
            init: MyItimGetx(),
            builder: (context) {
              return FutureBuilder(
                  future: context.freshdata(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("حصل خطا غير متوقع"));
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Text("لا توجد عروض بعد");
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text((index + 1).toString()),
                              title:
                                  Text(snapshot.data![index].name.toString()),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "رقم الهاتف : ${snapshot.data![index].phoneNumber}"),
                                  Text(
                                      "العنوان : ${snapshot.data![index].location}")
                                ],
                              ),
                            );
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  });
            }));
  }
}

class MyItimGetx extends GetxController {
  Future<List<dynamic>> fetchProducts() async {
    http.Response response;
    try {
      response = await ApiData.getToApi("api/product/viewOwn");
    } catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      List products =
          jsonData["data"].map((json) => Product.fromJson(json)).toList();
      return products;
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<List<dynamic>> freshdata(String id) async {
    http.Response response;
    try {
      response =
          await ApiData.getToApi("api/proudctPay/viewall?product_id=$id");
    } catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // print(jsonData);

      List<dynamic> products =
          jsonData.map((json) => ProudctPay.fromJson(json)).toList();
      return products;
    } else {
      throw Exception('حصل خدا ما');
    }
  }

  Future<void> deleteProduct(id) async {
    http.Response response;
    try {
      response =
          await ApiData.postToApiCauntrs("api/product/delete", {"id": id});
    } catch (e) {
      throw Exception(e);
    }
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete');
    }
  }
}
