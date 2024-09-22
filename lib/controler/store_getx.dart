import 'package:get/get.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tigercashiraq/model/user.dart';

class StoreController extends GetxController {
  var categories =
      ["ملابس و اكسسوارات", "اجهزة كهربائية", "منتجات اخرى"].obs;
  var selectedCategory = 0.obs;
  var selectedTipy = "clothes".obs;
  var products = <dynamic>[].obs;
  var isLoading = true.obs;
  final Rx<User> user = User().obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void selectCategory(int index) {
    selectedCategory.value = index;
    // fetchProducts();
  }

  void srtselcetedTipy(int index) {
    if (index == 0) {
      selectedTipy.value = "clothes";
    }
    if (index == 1) {
      selectedTipy.value = "electronic";
    }
    if (index == 2) {
      selectedTipy.value = "food";
    }
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    var xx = selectedTipy.value.toString();
    http.Response response;
    try {
      isLoading(true);
      response = await ApiData.getToApi(
          "api/product/viewall?type=${selectedTipy.value}");
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
      // products.clear();
    }

    if (response.statusCode == 200 && selectedTipy.value == xx) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data =
          jsonData["data"].map((json) => Product.fromJson(json)).toList();
      products.clear();
      products.addAll(data);
    } else {
      throw Exception('Failed to load images');
    }
  }

  void addProduct(Product product, var pickedFile) async {
    try {
      await ApiData.addPhotoFromGallery(pickedFile, product);
      Get.back();
    } catch (e) {
      if (e is ServerError) {}
      throw Exception("حدث خطا ما");
    }
  }

  Future<void> addPhotoFromGallery(var pickedFile) async {
    try {
      // var x = await ApiData.addPhotoFromGallery(pickedFile);
      // print(x);
    } catch (e) {
      throw Exception(e);
    }
  }
}
