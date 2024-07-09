import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tigercashiraq/controler/apidata.dart';
import 'package:tigercashiraq/error/server_error.dart';

import 'package:tigercashiraq/model/user.dart';

class TimeViow extends StatelessWidget {
  const TimeViow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('فريقي'),
        ),
        body: GetBuilder<TimeController>(
            init: TimeController(),
            builder: (controller) {
              return FutureBuilder(
                  future: controller.frishdata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('حدث خطأ'),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Text((index + 1).toString()),
                                  ),
                                  title: Text(
                                    snapshot.data![index].name.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index].createdAt.toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                  });
            }));
  }
}

class TimeController extends GetxController {
  List<dynamic> tame = <dynamic>[].obs;
  RxBool isloding = false.obs;

  @override
  void onInit() {
    super.onInit();
    frishdata();
  }

  Future<List> frishdata() async {
    try {
      final response = await ApiData.getToApi1("api/user/invited");
      var jsonData = jsonDecode(response.body)["data"];
      // for loop from list jsondata
      // print(jsonData);
      // print(jsonData[0]["user"]);
      List data = jsonData as List;
      print(data.length);
      List time = [];
      for (var i = 0; i < data.length; i++) {
        print("object");
        print(data[i]);
        print(User.fromJson(data[i]));
        time.add(User.fromJson(data[i]["user"]));
        // print(data[i].map((json) => User.fromJson(json)).toList());
      }
      return time;
    } catch (e) {
      if (e is ServerError) {
        // print(e.response.body);
        rethrow;
      }
      // print(e);
      rethrow;
    }
  }
}
