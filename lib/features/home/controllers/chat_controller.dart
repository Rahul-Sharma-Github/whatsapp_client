import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart'; // For platform check on web
import 'dart:io' as io;

import '../../login/controllers/login_controller.dart'; // Only for non-web platforms

final LoginController loginController =
    Get.put(LoginController(), permanent: true);

class ChatController extends GetxController {
  IO.Socket? socket;
  var groups = <String>[].obs;
  var groupMessages = <String, List<Map<String, dynamic>>>{}
      .obs; // Map of messages for each group
  var currentGroup = ''.obs;
  var userName = loginController.mobileNumber.value.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSocket(); // Initialize socket connection on controller initialization
  }

  // Initializes the socket connection based on platform
  void initializeSocket() {
    String serverUrl;

    if (kIsWeb || io.Platform.isAndroid || io.Platform.isIOS) {
      serverUrl = 'https://whatsapp-server-e47u.onrender.com';
    } else {
      serverUrl = 'https://whatsapp-server-e47u.onrender.com';
    }

    socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket?.connect();

    socket?.onConnect((_) {
      print('$userName Connected to the server');
    });

    socket?.onDisconnect((_) {
      print('$userName Disconnected from the server');
    });

    // Listen for messages from the server for the current group
    socket?.on('message', (data) {
      String? groupName = data['groupName'] as String?;
      String? userName = data['userName'] as String?;
      String? message = data['message'] as String?;
      String? messageId = data['id'] as String?;
      Map<String, String>? reactions =
          Map<String, String>.from(data['reactions'] ?? {});

      if (groupName != null &&
          userName != null &&
          message != null &&
          messageId != null) {
        if (!groupMessages.containsKey(groupName)) {
          groupMessages[groupName] = [];
        }

        bool isMe = userName == this.userName.value;
        groupMessages[groupName]!.add({
          'id': messageId,
          'userName': isMe ? 'Me' : userName,
          'message': message,
          'isMe': isMe,
          'reactions': reactions,
        });
        groupMessages.refresh();
      }
    });

    // Listen for reaction updates
    socket?.on('updateMessage', (data) {
      String? groupName = currentGroup.value;
      String? messageId = data['id'] as String?;
      Map<String, String>? reactions =
          Map<String, String>.from(data['reactions'] ?? {});

      if (messageId != null && groupMessages.containsKey(groupName)) {
        var message = groupMessages[groupName]
            ?.firstWhere((msg) => msg['id'] == messageId);
        if (message != null) {
          message['reactions'] = reactions;
          groupMessages.refresh();
        }
      }
    });

    // Listen for previous messages from the server when joining a group
    socket?.on('previousMessages', (messages) {
      String groupName = currentGroup.value;

      if (!groupMessages.containsKey(groupName)) {
        groupMessages[groupName] = [];
      }

      // Clear any existing messages for the group and add the previous messages
      groupMessages[groupName]!.clear();
      for (var msg in messages) {
        groupMessages[groupName]!.add({
          'id': msg['id'],
          'userName': msg['userName'],
          'message': msg['message'],
          'isMe': msg['userName'] == userName.value,
          'reactions': msg['reactions'] ?? {},
        });
      }
      groupMessages.refresh();
    });
  }

  // Method to join or create a group
  void joinGroup(String groupName) {
    if (!groups.contains(groupName)) {
      groups.add(groupName); // Add the group to the list if not already present
      groupMessages[groupName] =
          []; // Initialize an empty message list for the group
      print('Group "$groupName" added to list');
    }

    currentGroup.value = groupName;
    socket?.emit(
        'joinGroup', {'groupName': groupName, 'userName': userName.value});
  }

  // Method to leave a group
  void leaveGroup(String groupName) {
    socket?.emit(
        'leaveGroup', {'groupName': groupName, 'userName': userName.value});
    groups.remove(groupName); // Remove the group from the list
    if (currentGroup.value == groupName) {
      currentGroup.value =
          ''; // Clear the current group if it was the one being left
    }
    groupMessages[groupName] = []; // Clear messages when leaving the group
  }

  // Send a message to the current group
  void sendMessage(String message) {
    if (message.isNotEmpty && currentGroup.value.isNotEmpty) {
      socket?.emit('sendMessage', {
        'groupName': currentGroup.value,
        'message': message,
        'userName': userName.value
      });
    }
  }

  // React to a message in the current group
  void reactToMessage(String messageId, String reaction) {
    socket?.emit('reactToMessage', {
      'groupName': currentGroup.value,
      'messageId': messageId,
      'userName': userName.value,
      'reaction': reaction
    });
  }

  @override
  void onClose() {
    socket?.disconnect(); // Disconnect socket when the controller is destroyed
    super.onClose();
  }
}
