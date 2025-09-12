import 'package:buyzoonapp/core/style/color.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  static const textStyle18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Palette.primary,
  );
  static const textStyle18Bold = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const textStyle20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    // fontFamily: kGTSectraFineRegular,
  );
  static const textStyle28 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Palette.primary,
  );

  static var textStyle14 = TextStyle(
    color: Colors.grey[600],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static const textStyle16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
