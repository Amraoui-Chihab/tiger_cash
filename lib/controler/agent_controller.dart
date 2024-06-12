import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/agent.dart';
import 'apidata.dart';

class AgentController extends GetxController {
  var agents = <Agent>[].obs;
  var isLoading = true.obs;

  Future<List<dynamic>> fetchAgents() async {
    http.Response response;
    try {
      response = await ApiData.getToApi("api/reseller/index");
    } catch (e) {
      throw Exception(e);
    }

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> agents =
          jsonData.map((json) => Agent.fromJson(json)).toList();
      return agents;
    } else {
      throw Exception('Failed to load images');
    }
  }
}
