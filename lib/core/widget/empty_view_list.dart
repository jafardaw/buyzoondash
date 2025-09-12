import 'package:flutter/material.dart';

class EmptyListViews extends StatelessWidget {
  const EmptyListViews({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: TextStyle(fontSize: 18)));
  }
}
