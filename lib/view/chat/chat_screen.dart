import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/utl/colors.dart';
import 'package:tigercashiraq/view/chat/build_message.dart';
import 'package:tigercashiraq/view/chat/build_message_input.dart';

import '../../controler/chat_controller.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final chatController = Get.put(ChatController());
  Radius x = const Radius.circular(10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كروب الدردشة العام'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  return buildMessage(message, context, chatController);
                },
              );
            }),
          ),
          const Divider(
            color: Ccolors.gay,
          ),
          buildMessageInput(chatController),
        ],
      ),
    );
  }
}
