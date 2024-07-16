import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controler/profile/my_video_controller.dart';

class MyVideo extends StatelessWidget {
  MyVideo({super.key});
  final controller = Get.put(MyVideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فديوهاتي'),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.videos.length,
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                    title: Text(controller.videos[index].name.toString()),
                    trailing: IconButton(
                        onPressed: () {
                          controller.deleteVideo(controller.videos[index].id);
                        },
                        icon: const Icon(Icons.delete)),
                  );
                });
      }),
    );
  }
}
