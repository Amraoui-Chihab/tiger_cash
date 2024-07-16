import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/chat_controller.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'package:tigercashiraq/utl/colors.dart';

Widget buildMessageInput(ChatController chatController) {
  final TextEditingController messageController = TextEditingController();
  final SheckTime sheckTime = Get.put(SheckTime());
  final HomeController homeController = Get.find();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'اكتب رسالتك...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Ccolors.secndry),
          ),
          color: Ccolors.primry,
          icon: const Icon(
            Icons.send_outlined,
            size: 30,
          ),
          onPressed: () async {
            try {
              await homeController.getuserInfo();
              if (messageController.text.trim().isNotEmpty) {
                // إرسال الرسالة إلى Firebase
                FirebaseFirestore.instance.collection('messages').add({
                  "id": chatController.user.value.id,
                  'senderName': chatController.user.value.name
                      .toString(), // استبدل هذا بقيمة اسم المرسل الحقيقية
                  'senderImageUrl': chatController.user.value.photoUrl
                      .toString(), // استبدل هذا بعنوان الصورة الحقيقي
                  'text': messageController.text.trim(),
                  'timestamp': Timestamp.now(),
                });
                messageController.clear();
              }
            } catch (e) {
              print(e);
            }
          },
        ),
        const SizedBox(
          width: 5,
        )
      ],
    ),
  );
}
