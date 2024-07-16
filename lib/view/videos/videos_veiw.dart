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
        return RefreshIndicator(
          onRefresh: () async {
            controller.videoInfo.clear();
            controller.page.value = 1;
            controller.getReel();
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
                      )),
                  Positioned(
                    bottom: 60,
                    right: 10,
                    child: Text(
                      "${controller.videoInfo[index].name}\n${controller.videoInfo[index].userId}",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
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
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                  CardPositioned(
                    bottom: 30,
                    icon: const Icon(Icons.card_giftcard, color: Colors.white),
                    onPressed: () {
                      if (controller.videoInfo[index].userId !=
                          homeController.user.value.id.toString()) {
                        SmartDialog.show(
                            alignment: Alignment.center,
                            builder: (cons) {
                              return GifiWidget(
                                userId: controller.videoInfo[index].userId
                                    .toString(),
                              );
                            });
                      }
                    },
                    title: 'أهداء',
                  ),
                  CardPositioned(
                    bottom: 90,
                    icon: const Icon(Icons.comment, color: Colors.white),
                    onPressed: () {
                      controller.isComment.value = true;
                      // controller.controllers[index].pause();
                      controller.update();
                    },
                    title: controller.videoInfo[index].comment.toString(),
                  ),
                  GetBuilder<VideoController1>(
                      init: VideoController1(),
                      builder: (context) {
                        return CardPositioned(
                          bottom: 160,
                          icon: Icon(Icons.favorite,
                              color: controller.videoInfo[index].isLiked
                                  ? Colors.red
                                  : Colors.white),
                          onPressed: () async {
                            try {
                              await controller.addLikes(
                                  controller.videoInfo[index].id.toString(),
                                  controller.videoInfo[index].isLiked,
                                  index);
                              controller.update();
                              // controller.videoInfo[index].isLiked =
                              //     !controller.videoInfo[index].isLiked;
                            } catch (e) {
                              Get.snackbar("خطأ", e.toString());
                            }
                          },
                          title: controller.videoInfo[index].likes.toString(),
                        );
                      }),
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
      }),
    );
  }
}
