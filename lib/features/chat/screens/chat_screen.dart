import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/chat_controller.dart';
import '../../login/controllers/login_controller.dart';

class ChatScreen extends StatelessWidget {
  final String groupName;
  final ChatController controller = Get.find<ChatController>();
  final LoginController loginController =
      Get.put(LoginController(), permanent: true);

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
      body: Container(
        color: Colors.amber[50],
        child: Column(
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
                    Map<String, String> reactions = Map<String, String>.from(
                        messageData['reactions'] ?? {});

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
                          child: SizedBox(
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${messageData['userName']}: ${messageData['message']}'),
                                ),
                                if (reactions.isNotEmpty)
                                  Expanded(
                                    child: Wrap(
                                      children: reactions.entries
                                          .map((entry) => Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Chip(
                                                  label: Text(entry.value),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // child:
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
                      ],
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Type a message",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 26,
                    child: Center(
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        iconSize: 18,
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          controller.sendMessage(messageController.text);
                          messageController.clear();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
