import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'package:tigercashiraq/view/videos/widget/card__positioned.dart';
import 'package:tigercashiraq/view/videos/video_capture_page.dart';
import 'package:tigercashiraq/view/videos/widget/comment.dart';

import '../../controler/video_controller1.dart';
import 'widget/gifi_widget.dart';
import 'widget/video_player_page.dart';

class PageViewExample extends StatefulWidget {
  const PageViewExample({super.key});

  @override
  State<PageViewExample> createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample> {
  final VideoController1 controller = Get.put(VideoController1());
  final HomeController homeController = Get.find();
  
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    Get.delete<VideoController1>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        // Check if the list is empty
        if (controller.videoInfo.isEmpty) {
          return Center(
            child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: Colors.white,
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                        "لا يوجد ريلز",
                        style: TextStyle(fontSize: 30, color: Colors.grey),
                      ),
                      Icon(Icons.search_off, color: Colors.red)
                    ]))),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              controller.videoInfo.clear();
              controller.page.value = 1;
              await controller.getReel();
              print('reels');
              print(controller.videoInfo); // Ensure getReel is awaited
            },
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.videoInfo.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      child: VideoPlayerPage(
                        url: controller.videoInfo[index].url.toString(),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            "${controller.videoInfo[index].name}\n${controller.videoInfo[index].userId}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 10,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            Get.to(() => const VideoCapturePage());
                          },
                          icon: Image.asset(
                            "assets/add.png",
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    GetBuilder<VideoController1>(
                      init: VideoController1(),
                      builder: (context) {
                        return Positioned(
                          bottom: 210,
                          left: 25,
                          child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/bc.png",
                                    height: 35,
                                  ),
                                  Text(
                                    "دعم",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                int value = await context.fetchSupport(context
                                    .videoInfo[context.currentPage.value].id);

                                print(value);
                                print('sup');
                                Get.defaultDialog(
                                  title: 'اجمالي الدعم الخاص بهذا الريلز',
                                  content: Column(
                                    children: [
                                      Text('$value نقطة'),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.back(); // Close the dialog
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                    Positioned(
                      child: InkWell(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/gift.png",
                              height: 35,
                            ),
                            Text(
                              "إهداء",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (controller.videoInfo[index].userId !=
                              homeController.user.value.id.toString()) {
                            SmartDialog.show(
                                alignment: Alignment.center,
                                builder: (cons) {
                                  return GifiWidget(
                                    userId: controller.videoInfo[index].userId
                                        .toString(),
                                    reel_id: controller.videoInfo[index].id
                                        .toString(),
                                  );
                                });
                          }
                        },
                      ),
                      bottom: 30,
                      left: 25,
                    ),
                    Positioned(
                      bottom: 90,
                      left: 25,
                      child: InkWell(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/chat.png",
                              height: 35,
                            ),
                            Text(
                              "${controller.videoInfo[index].comment.toString()}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onTap: () {
                          controller.isComment.value = true;
                          controller.update();
                        },
                      ),
                    ),
                    GetBuilder<VideoController1>(
                      init: VideoController1(),
                      builder: (context) {
                        return Positioned(
                          bottom: 150,
                          left: 25,
                          child: InkWell(
                            onTap: () async {
                              try {
                                await controller.addLikes(
                                    controller.videoInfo[index].id.toString(),
                                    controller.videoInfo[index].isLiked,
                                    index);
                                controller.update();
                              } catch (e) {
                                Get.snackbar("خطأ", e.toString());
                              }
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  controller.videoInfo[index].isLiked
                                      ? "assets/like.png"
                                      : "assets/no_like.png",
                                  color: controller.videoInfo[index].isLiked
                                      ? null
                                      : Colors.white,
                                  height: 35,
                                ),
                                Text(
                                  "${controller.videoInfo[index].likes.toString()}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Obx(() {
                      return controller.isComment.value
                          ? Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: commentSection(context, controller, index),
                            )
                          : const SizedBox();
                    })
                  ],
                );
              },
            ),
          );
        }
      }),
    );
  }
}
