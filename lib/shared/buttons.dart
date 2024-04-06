import 'package:flutter/material.dart';

class ScrollButton extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollButton({Key? key, required this.scrollController, isUpper})
      : super(key: key);

  @override
  State<ScrollButton> createState() => _ScrollButtonState();
}

class _ScrollButtonState extends State<ScrollButton> {
  final isUpper = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: FloatingActionButton(
      onPressed: () {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      },
      child: const Icon(Icons.arrow_circle_down_sharp),
    ));
  }
}
