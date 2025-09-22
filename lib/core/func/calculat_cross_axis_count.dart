import 'package:flutter/material.dart';

int calculateCrossAxisCount(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width > 1200) {
    return 8;
  } else if (width > 850) {
    return 6;
  } else if (width > 550) {
    return 4;
  } else {
    return 3;
  }
}
