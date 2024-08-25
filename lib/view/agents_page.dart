import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controler/agent_controller.dart';
import 'sub_many.dart';
import 'widget/my_text.dart';

class AgentsPage extends StatelessWidget {
  const AgentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سحب الأموال'),
          centerTitle: true,
          // leading: IconButton(
          //   icon: const Icon(Icons.close),
          //   onPressed: () {
          //     Get.back();
          //   },
          // ),
          bottom: const TabBar(dividerColor: Colors.white, tabs: [
            Tab(text: 'الوكلاء'),
            Tab(text: 'سحب مباشر'),
          ]),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    title: MyText(
                      titel: "وكلاء بابل كاش",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: MyText(
                      titel: "جميع الوكلاء ومعلوماتهم هنا",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Image.asset("assets/logo.png"),
                  ),
                  Expanded(
                    child: GetBuilder<AgentController>(
                        init: AgentController(),
                        builder: (agentController) {
                          return FutureBuilder(
                              future: agentController.fetchAgents(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text("حصل خطا في تحميل الوكلاء"));
                                }
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text("لايوجد وكلاء الان"));
                                  }
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var agent = snapshot.data![index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          title: Text(agent.name),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'تليجرام: ${agent.location}'),
                                              Text(
                                                  'الرقم واتساب: ${agent.phoneNumber}'),
                                            ],
                                          ),
                                          trailing: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Icon(Icons.call, color: Colors.green),
                                              // SizedBox(height: 8),
                                              // Icon(Icons.location_pin,
                                              //     color: Colors.blue),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                                // });
                              }
                              // }
                              );
                        }),
                  ),
                ],
              ),
            ),
            SubMany()
          ],
        ),
      ),
    );
  }
}
