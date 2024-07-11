import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TypingBubbleIndicator extends StatelessWidget {
  const TypingBubbleIndicator({
    super.key,
    this.padding,
    this.color,
    this.size = 20,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child: SpinKitThreeBounce(
            size: size,
            color: color ?? Colors.grey,
          ),
        )
      ],
    );
  }
}
