import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/screens/chat_screen.dart';
import '../controllers/chat_controller.dart';

class WhatsAppScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  WhatsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController groupController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp Clone"),
      ),
      body: Column(
        children: [
          // Input field to create/join a group
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: groupController,
                    decoration: InputDecoration(
                      labelText: "Enter Group Name",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Call joinGroup with the entered group name
                    String groupName = groupController.text.trim();
                    if (groupName.isNotEmpty) {
                      controller.joinGroup(groupName);
                      groupController.clear();
                    }
                  },
                  child: const Text("Join/Create Group"),
                ),
              ],
            ),
          ),
          // Display the list of groups joined
          Obx(() => Expanded(
                child: ListView.builder(
                  itemCount: controller.groups.length,
                  itemBuilder: (context, index) {
                    String group = controller.groups[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.group, color: Colors.white),
                      ),
                      title: Text(group),
                      trailing: IconButton(
                        icon: const Icon(Icons.exit_to_app, color: Colors.red),
                        onPressed: () {
                          controller.leaveGroup(group);
                        },
                      ),
                      onTap: () {
                        // Navigate to the ChatScreen with the group name
                        Get.to(() => ChatScreen(groupName: group));
                      },
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}
