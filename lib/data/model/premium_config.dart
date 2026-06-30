class PremiumConfig {
  final int fromAge;
  final int toAge;
  final String gender;
  final int premiumTerm;
  final double premiumRate;

  PremiumConfig({
    required this.fromAge,
    required this.toAge,
    required this.gender,
    required this.premiumTerm,
    required this.premiumRate,
  });

  /// Factory constructor to convert map representations directly into type-safe entities.
  factory PremiumConfig.fromMap(Map<String, dynamic> map) {
    // Helper to safely parse numbers regardless of whether they come as String, int, double, or custom cell values
    int parseAsInt(dynamic val, String key) {
      if (val == null) return 0;
      // Extract underlying raw value if it's an excel_plus CellValue object
      final raw = val.toString().replaceAll('.0', '');
      return int.tryParse(raw) ?? 0;
    }

    double parseAsDouble(dynamic val, String key) {
      if (val == null) return 0.0;
      final raw = val.toString();
      return double.tryParse(raw) ?? 0.0;
    }

    return PremiumConfig(
      fromAge: parseAsInt(map['FromAge'], 'FromAge'),
      toAge: parseAsInt(map['ToAge'], 'ToAge'),
      gender: map['Gender']?.toString().trim() ?? '',
      premiumTerm: parseAsInt(map['PremiumTerm'], 'PremiumTerm'),
      premiumRate: parseAsDouble(
        map['Premium Rate'],
        'Premium Rate',
      ), // Handles space in key name
    );
  }

  /// Optional: Converts instance back to a JSON Map representation
  Map<String, dynamic> toMap() {
    return {
      'FromAge': fromAge,
      'ToAge': toAge,
      'Gender': gender,
      'PremiumTerm': premiumTerm,
      'Premium Rate': premiumRate,
    };
  }
}
