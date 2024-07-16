import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';
import 'package:tigercashiraq/model/money_reqest.dart';

class SubManyController extends GetxController {
  List subMany = [].obs;

  RxString subManyCurrency = "zain_cash".obs;

  var subManyAmountController = TextEditingController().obs;

  // var subManyType=TextEditingController().obs;

  var subManyEmailController = TextEditingController().obs;

  var subManyNameController = TextEditingController().obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getdata();
  }

  Future getdata() async {
    http.Response response;
    try {
      isLoading(true);
      response = await ApiData.getToApi("api/money_reqest/indexMy");
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
      // products.clear();
    }

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data =
          jsonData.map((json) => MoneyReqest.fromJson(json)).toList();
      subMany.clear();
      subMany.addAll(data);
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future moneyReqest() async {
    try {
      await ApiData.postToApiCauntrs("api/money_reqest/create", {
        "cost": subManyEmailController.value.text.toString(),
        "type": subManyCurrency.value.toString(),
        "card_number": subManyAmountController.value.text.toString(),
        "name": subManyNameController.value.text.toString(),
      });
    } catch (e) {
      if (e is ServerError) {
        throw jsonDecode(e.response.body)["message"];
      } else {
        rethrow;
      }
    }
  }
}
