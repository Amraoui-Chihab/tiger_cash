import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controler/apidata.dart';
import '../model/message.dart';
import '../model/user.dart';
import '../utl/colors.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' الدردشة '),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text('كروب الدردشة العام'),
              subtitle: const Text('يرجى الالتزام بل قواعد العامة'),
              onTap: () {
                Get.to(() => ChatScreen());
              },
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  Radius x = const Radius.circular(10);

  ChatScreen({super.key});

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
                  return _buildMessage(message, context);
                },
              );
            }),
          ),
          const Divider(
            color: Ccolors.gay,
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message, BuildContext context) {
    const Radius x = Radius.circular(12);

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
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: message.senderId == chatController.user.value.id
                ? Ccolors.secndry
                : Ccolors.gay, // استخدم اللون الذي تفضله هنا
            borderRadius: BorderRadius.only(
              topLeft: x,
              topRight: x,
              bottomRight: message.senderId == chatController.user.value.id
                  ? x
                  : const Radius.circular(0),
              bottomLeft: message.senderId == chatController.user.value.id
                  ? const Radius.circular(0)
                  : x,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.senderId != chatController.user.value.id)
                Text(
                  message.senderName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              Text(
                message.text,
                style: Theme.of(context).textTheme.titleMedium,
                softWrap: true,
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Text(
              //       message.timestamp.toString().substring(7, 14),
              //       style: Theme.of(context).textTheme.bodySmall,
              //     ),
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [

              //     Column(
              //       children: [
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(
              //           message.timestamp.toString().substring(7, 14),
              //           style: Theme.of(context).textTheme.bodySmall,
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController messageController = TextEditingController();
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
            onPressed: () {
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
            },
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }
}

class ChatController extends GetxController {
  var messages = <Message>[].obs;
  final Rx<User> user = User().obs;

  @override
  void onInit() {
    super.onInit();
    getuserInfo().then(
      (value) => loadMessages(),
    );
    // loadMessages();
  }

  Future getuserInfo() async {
    try {
      var x = await ApiData.getToApi("api/user/viewMy");
      User userz = User.fromJson(jsonDecode(x.body)["data"]);
      user.value = userz;
      // await box.write("user", user);
    } catch (e) {
      throw Exception("ggggg");
    }
  }

  void loadMessages() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(15)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => Message.fromDocumentSnapshot(doc))
          .toList();
    });
    db.settings = const Settings(persistenceEnabled: false);
  }
}
