import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function()? onpressed;
  const MyFloatingActionButton({super.key, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onpressed,
      child: Icon(Icons.add),
    );
  }
}
