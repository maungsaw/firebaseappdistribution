import 'package:flutter/material.dart';

class BorderBoxDecoration {
  static BoxDecoration get cellBorder => BoxDecoration(
    border: Border.all(color: Colors.grey.shade100, width: 0.5),
  );
  static BoxDecoration get columnRightBorder => BoxDecoration(
    border: Border(right: BorderSide(color: Colors.grey.shade200, width: 0.8)),
  );
}
