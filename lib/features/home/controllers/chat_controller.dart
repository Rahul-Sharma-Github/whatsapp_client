import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart'; // For platform check on web
import 'dart:io' as io; // Only for non-web platforms

class ChatController extends GetxController {
  IO.Socket? socket;
  var groups = <String>[].obs; // List of joined groups
  var groupMessages = <String, List<Map<String, dynamic>>>{}
      .obs; // Map of messages for each group
  var currentGroup = ''.obs; // Tracks the current group
  var userName =
      'User${DateTime.now().millisecondsSinceEpoch}'.obs; // Temporary username

  @override
  void onInit() {
    super.onInit();
    initializeSocket(); // Initialize socket connection on controller initialization
  }

  // Initializes the socket connection based on platform
  void initializeSocket() {
    String serverUrl;

    if (kIsWeb) {
      serverUrl = 'http://localhost:3000';
    } else if (io.Platform.isAndroid) {
      serverUrl = 'http://10.0.2.2:3000';
    } else {
      serverUrl = 'http://localhost:3000';
    }

    socket = IO.io(
        serverUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket?.connect();

    socket?.onConnect((_) {
      print('Connected to the server');
    });

    socket?.onDisconnect((_) {
      print('Disconnected from the server');
    });

    // Listen for messages from the server for the current group
    socket?.on('message', (data) {
      String? groupName = data['groupName'] as String?;
      String? userName = data['userName'] as String?;
      String? message = data['message'] as String?;

      // Ensure data is valid before processing
      if (groupName != null && userName != null && message != null) {
        // Initialize message list for group if it doesn't exist
        if (!groupMessages.containsKey(groupName)) {
          groupMessages[groupName] = [];
        }

        // Add message to the appropriate group
        bool isMe = userName == this.userName.value;
        groupMessages[groupName]!.add({
          'userName': isMe ? 'Me' : userName,
          'message': message,
          'isMe': isMe
        });

        // Update UI
        groupMessages.refresh();
      }
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

  @override
  void onClose() {
    socket?.disconnect(); // Disconnect socket when the controller is destroyed
    super.onClose();
  }
}
