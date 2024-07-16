import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/chat_controller.dart';
import 'package:tigercashiraq/model/message.dart';
import 'package:tigercashiraq/utl/colors.dart';

Widget buildMessage(
    Message message, BuildContext context, ChatController chatController) {
  const Radius x = Radius.circular(12);
  var db = FirebaseFirestore.instance;

  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: message.senderId == chatController.user.value.id
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (message.senderId != chatController.user.value.id)
        CircleAvatar(
          backgroundImage: NetworkImage(message.senderImageUrl),
        ),
      const SizedBox(width: 8),
      GestureDetector(
        onLongPress: chatController.user.value.id == "150324"
            ? () {
                Get.dialog(AlertDialog(
                  title: Text(message.senderName.toString()),
                  content: Text("كود الاحالة : ${message.senderId}"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        db.collection("messages").doc(message.id).delete().then(
                              (doc) => Get.snackbar("نجاح", "تم حذف الرسالة"),
                              onError: (e) =>
                                  Get.snackbar("فشل", "فشل حذف الرسالة"),
                            );
                        Get.back();
                      },
                      child: const Text(
                        "حذف الرسالة",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ));
              }
            : null,
        child: Container(
          // constraints: BoxConstraints(
          //   maxWidth: MediaQuery.of(context).size.width * 0.7,
          // ),
          // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // decoration: BoxDecoration(
          //   color: message.senderId == "150324"
          //       ? Colors.green
          //       : message.senderId == chatController.user.value.id
          //           ? Ccolors.secndry
          //           : Ccolors.gay, // استخدم اللون الذي تفضله هنا
          //   borderRadius: BorderRadius.only(
          //     topLeft: x,
          //     topRight: x,
          //     bottomRight: message.senderId == chatController.user.value.id
          //         ? x
          //         : const Radius.circular(0),
          //     bottomLeft: message.senderId == chatController.user.value.id
          //         ? const Radius.circular(0)
          //         : x,
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.senderId != chatController.user.value.id)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    message.senderName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: message.senderId == "150324"
                      ? Colors.green
                      : message.senderId == chatController.user.value.id
                          ? Ccolors.secndry
                          : Ccolors.gay, // استخدم اللون الذي تفضله هنا
                  borderRadius: BorderRadius.only(
                    topLeft: x,
                    topRight: x,
                    bottomRight:
                        message.senderId == chatController.user.value.id
                            ? x
                            : const Radius.circular(0),
                    bottomLeft: message.senderId == chatController.user.value.id
                        ? const Radius.circular(0)
                        : x,
                  ),
                ),
                child: Text(
                  message.text,
                  style: Theme.of(context).textTheme.titleMedium,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
