import 'package:chatbot/src/chat/typing_bubble.dart';
import 'package:flutter/material.dart';

class BubbleDropdown extends StatelessWidget {
  final List<dynamic> options;
  final Function(String) onOptionSelected;
  final bool isTyping;

  const BubbleDropdown(
      {required this.options,
      required this.onOptionSelected,
      super.key,
      required this.isTyping});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: isTyping
          ? const TypingBubbleIndicator()
          : Wrap(
              runSpacing: 4.0,
              spacing: 10,
              children: options.map((option) {
                return InkWell(
                  onTap: () => onOptionSelected(option),
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
