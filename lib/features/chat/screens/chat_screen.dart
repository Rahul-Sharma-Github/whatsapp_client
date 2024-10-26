import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  final String groupName;
  final ChatController controller = Get.find<ChatController>();

  ChatScreen({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    // Join the selected group and set as current
    controller.joinGroup(groupName);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.group, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(groupName),
          ],
        ),
      ),
      body: Column(
        children: [
          // Display chat messages for the specific group
          Expanded(
            child: Obx(() {
              var messages = controller.groupMessages[groupName] ??
                  []; // Get messages for the current group
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var messageData = messages[index];
                  bool isMe = messageData['isMe'];
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.greenAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${messageData['userName']}: ${messageData['message']}',
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          // Input field to send a message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    controller.sendMessage(messageController.text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
