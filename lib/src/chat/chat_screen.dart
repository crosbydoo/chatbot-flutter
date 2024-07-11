import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatbot/core/data/local/app_preferences.dart';
import 'package:chatbot/di.dart';
import 'package:chatbot/src/bubble/bubble_dropdown.dart';
import 'package:chatbot/src/bubble/bubble_message.dart';
import 'package:chatbot/src/chat/file_picker_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chatbot/core/utils/websocket_helper.dart';

class ChatScreen extends StatefulWidget {
  static const route = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final prefs = sl<AppPreferences>();

  late WebSocketHelper _webSocketHelper;
  late String _url;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<Map<String, dynamic>> _messages = [];
  bool _showFilePicker = false;
  bool _isHumanTakeover = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _url = 'ws://z72hj9h7-3000.asse.devtunnels.ms/chat/${prefs.getUID()}';
    _webSocketHelper = WebSocketHelper();
    _connectWebSocket();
  }

  void _handleTakeOverByHumans() {
    setState(() {
      if (_isHumanTakeover) {
        _url = 'ws://z72hj9h7-3000.asse.devtunnels.ms/chat/${prefs.getUID()}';
      } else {
        _url =
            'ws://z72hj9h7-3000.asse.devtunnels.ms/livechat/${prefs.getUID()}';
      }
      _isHumanTakeover = !_isHumanTakeover;
    });

    _webSocketHelper.disconnect();

    _reconnectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    final token = prefs.getToken();
    log('Token: $token');
    try {
      if (token == null || token.isEmpty) {
        log('Token is null or empty');
        return;
      }

      await _webSocketHelper.connect(_url, prefs.getToken()!);
      log('Connected to $_url');

      _webSocketHelper.stream.listen(
        (message) => _handleIncomingMessage(message),
        onError: _handleWebSocketError,
        onDone: _handleWebSocketDone,
      );
    } catch (error) {
      log('Failed to connect to WebSocket: $error');
    }
  }

  void _handleIncomingMessage(String message) {
    final decodedMessage = jsonDecode(message);

    if (decodedMessage.containsKey('from') && decodedMessage['from'] == '2') {
      setState(() {
        _addHumanMessage(decodedMessage);
        _scrollToBottom();
      });
    } else {
      setState(() {
        _addTypingMessage(decodedMessage);

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _replaceTypingWithReceivedMessage(decodedMessage);
            _scrollToBottom();
          });
        });
        _scrollToBottom();
      });
    }

    log("Message received: $decodedMessage");
  }

  void _addHumanMessage(Map<String, dynamic> decodedMessage) {
    setState(() {
      _messages.add({
        'uid': decodedMessage['from'],
        'name': 'User 2',
        'user_type': 'sender', // Assuming User 2 is a sender
        'message': decodedMessage['message'],
        'type_bubble': 'bubble',
        'datetime': DateTime.now().toIso8601String(),
        'respond_id': '',
        'options': [],
        'isTyping': false,
        'isUser': true,
      });
      _scrollToBottom();
    });
  }

  void _addTypingMessage(Map<String, dynamic> decodedMessage) {
    setState(() {
      _messages.add({
        'uid': decodedMessage['uid'],
        'name': 'Sinta (Virtual Assistant)',
        'message': 'Typing...',
        'type_bubble': decodedMessage['type_bubble'],
        'datetime': decodedMessage['datetime'],
        'respond_id': decodedMessage['respond_id'],
        'options': decodedMessage['options'],
        'isTyping': true,
        'isUser': false,
      });
    });
  }

  void _replaceTypingWithReceivedMessage(Map<String, dynamic> decodedMessage) {
    _messages.removeLast();
    _messages.add({
      'uid': decodedMessage['uid'],
      'name': 'Sinta (Virtual Assistant)',
      'message': decodedMessage['message'],
      'type_bubble': decodedMessage['type_bubble'],
      'datetime': decodedMessage['datetime'],
      'respond_id': decodedMessage['respond_id'],
      'options': decodedMessage['options'],
      'isTyping': false,
      'isUser': false,
    });
  }

  void _handleWebSocketError(dynamic error) {
    log('Error receiving message: $error');
    _reconnectWebSocket();
  }

  void _handleWebSocketDone() {
    log('WebSocket closed');
    _reconnectWebSocket();
  }

  void _reconnectWebSocket() {
    if (!_webSocketHelper.isConnected) {
      log('Attempting to reconnect...');
      _connectWebSocket();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _sendMessage(String message, {File? imageFile}) async {
    if (message.isEmpty && imageFile == null) {
      log('No message to send');
      return;
    }

    String? imageBase64;
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }

    final data = {
      'message': message,
      if (imageBase64 != null) 'image': imageBase64,
    };

    try {
      await _webSocketHelper.send(jsonEncode(data));
      log('Message sent: $data');

      setState(() {
        _addUserMessage(message, imageFile);
        _controller.clear();
        _scrollToBottom();
      });
    } catch (error) {
      log('Failed to send message: $error');
    }
  }

  void _addUserMessage(String message, File? imageFile) {
    DateTime now = DateTime.now();
    _messages.add({
      'uid': 0,
      'message': message,
      'image': imageFile,
      'type_bubble': 'bubble',
      'datetime': now.toIso8601String(),
      'respond_id': '',
      'isTyping': false,
      'isUser': true,
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      _sendMessage('Image selected', imageFile: imageFile);
    } else {
      log('No image selected.');
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final File file = File(result.files.single.path!);
      _sendMessage('File selected: ${file.path}');
    } else {
      log('No file selected.');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _toggleFilePicker() {
    setState(() {
      _showFilePicker = !_showFilePicker;
    });
    if (_showFilePicker) {
      _showBottomSheet();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FilePickerBottomSheet(
          onPickImage: _pickImage,
          onPickFile: _pickFile,
        );
      },
    ).whenComplete(() {
      if (_showFilePicker) {
        setState(() {
          _showFilePicker = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log('login UID ${prefs.getUID()}');
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return InkWell(
                      onTap: _handleTakeOverByHumans,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            _isHumanTakeover
                                ? 'Connect back with chatbot'
                                : 'Takeover by humans',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    if (message['type_bubble'] == 'dropdown_bubble' ||
        message['type_bubble'] == 'multi_select_bubble') {
      return Column(
        crossAxisAlignment: message['isUser']
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          MessageBubble(message: message),
          BubbleDropdown(
            onOptionSelected: _sendMessage,
            options: message['options'],
            isTyping: message['isTyping'],
          ),
        ],
      );
    } else {
      return MessageBubble(message: message);
    }
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(
                      _showFilePicker ? Icons.keyboard : Icons.attach_file),
                  onPressed: _toggleFilePicker,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
                hintText: 'Type your message...',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              onFieldSubmitted: (value) => _sendMessage(value),
            ),
          ),
        ],
      ),
    );
  }
}
