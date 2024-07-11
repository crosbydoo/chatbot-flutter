import 'package:chatbot/core/utils/format_date_ext.dart';
import 'package:chatbot/src/chat/typing_bubble.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message['isUser'] ?? false;

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isUser)
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.bug_report_rounded,
                size: 20,
                color: Colors.purple,
              ),
            ),
          ),
        Container(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(isUser ? 'You' : message['name'] ?? 'Anonymous'),
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.55,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isUser ? Colors.blue : Colors.grey[300]!,
                  ),
                  color: isUser ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(15),
                    topLeft: isUser ? const Radius.circular(15) : Radius.zero,
                    bottomRight:
                        isUser ? Radius.zero : const Radius.circular(15),
                    bottomLeft: const Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: message['isTyping']
                    ? const TypingBubbleIndicator()
                    : Text(
                        message['message'] ?? '',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  message['datetime'] != null
                      ? DateTime.parse(message['datetime'])
                          .toLocal()
                          .formatTimeAgo()
                      : '',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isUser)
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 20,
                color: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }
}
