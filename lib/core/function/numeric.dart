abstract class NumericFun {
  static int parseAsInt(dynamic val, String key) {
    if (val == null) return 0;
    // Extract underlying raw value if it's an excel_plus CellValue object
    final raw = val.toString().replaceAll('.0', '');
    return int.tryParse(raw) ?? 0;
  }

  static double parseAsDouble(dynamic val, String key) {
    if (val == null) return 0.0;
    final raw = val.toString();
    return double.tryParse(raw) ?? 0.0;
  }
}
