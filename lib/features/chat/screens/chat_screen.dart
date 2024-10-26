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

    // Join the group when the screen is created
    controller.joinGroup(groupName);

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              var messages = controller.groupMessages[groupName] ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var messageData = messages[index];
                  bool isMe = messageData['isMe'];
                  String messageId = messageData['id'];

                  // Cast the reactions to Map<String, String>
                  Map<String, String> reactions =
                      Map<String, String>.from(messageData['reactions'] ?? {});

                  return Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.greenAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                            '${messageData['userName']}: ${messageData['message']}'),
                      ),
                      Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Text('👍'),
                            onPressed: () =>
                                controller.reactToMessage(messageId, '👍'),
                          ),
                          IconButton(
                            icon: const Text('👏'),
                            onPressed: () =>
                                controller.reactToMessage(messageId, '👏'),
                          ),
                          IconButton(
                            icon: const Text('😊'),
                            onPressed: () =>
                                controller.reactToMessage(messageId, '😊'),
                          ),
                        ],
                      ),
                      if (reactions.isNotEmpty)
                        Wrap(
                          children: reactions.entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Chip(
                                      label:
                                          Text('Reacted with: ${entry.value}'),
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
