import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/screens/chat_screen.dart';
import '../controllers/chat_controller.dart';

class WhatsAppScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController(), permanent: true);

  WhatsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController groupController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp Clone"),
      ),
      body: Container(
        color: Colors.cyan[900],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input field to create/join a group
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: groupController,
                      decoration: InputDecoration(
                        labelText: "Enter Group Name",
                        labelStyle: const TextStyle(color: Colors.white),
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
                      } else {
                        Get.snackbar(
                          'First, enter group name !',
                          '',
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text("Join/Create Group"),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Groups',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              // Display the list of groups joined
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    itemCount: controller.groups.length,
                    itemBuilder: (context, index) {
                      String group = controller.groups[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12.0)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.group, color: Colors.white),
                            ),
                            title: Text(
                              group,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.exit_to_app,
                                  color: Colors.red),
                              onPressed: () {
                                controller.leaveGroup(group);
                              },
                            ),
                            onTap: () {
                              // Navigate to the ChatScreen with the group name
                              Get.to(() => ChatScreen(groupName: group));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
