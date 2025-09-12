import 'package:flutter/material.dart';

int calculateCrossAxisCount(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width > 1200) {
    return 8;
  } else if (width > 800) {
    return 6;
  } else if (width > 500) {
    return 4;
  } else {
    return 3;
  }
}
