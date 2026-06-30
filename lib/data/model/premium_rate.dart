import 'package:firebaseappdistribution/core/function/funciton.dart';

class PremiumRateModel {
  final int fromAge;
  final int toAge;
  final String gender;
  final int premiumTerm;
  final double premiumRate;

  PremiumRateModel({
    required this.fromAge,
    required this.toAge,
    required this.gender,
    required this.premiumTerm,
    required this.premiumRate,
  });

  /// Factory constructor to convert map representations directly into type-safe entities.
  factory PremiumRateModel.fromMap(Map<String, dynamic> map) {
    // Helper to safely parse numbers regardless of whether they come as String, int, double, or custom cell values

    return PremiumRateModel(
      fromAge: NumericFun.parseAsInt(map['FromAge'], 'FromAge'),
      toAge: NumericFun.parseAsInt(map['ToAge'], 'ToAge'),
      gender: map['Gender']?.toString().trim() ?? '',
      premiumTerm: NumericFun.parseAsInt(map['PremiumTerm'], 'PremiumTerm'),
      premiumRate: NumericFun.parseAsDouble(
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

  Map<String, dynamic> toORM() {
    return {
      'from_age': fromAge,
      'to_age': toAge,
      'gender': gender,
      'premium_term': premiumTerm,
      'premium_rate': premiumRate,
    };
  }

  factory PremiumRateModel.fromORM(Map<String, dynamic> map) {
    // Helper to safely parse numbers regardless of whether they come as String, int, double, or custom cell values

    return PremiumRateModel(
      fromAge: NumericFun.parseAsInt(map['from_age'], 'from_age'),
      toAge: NumericFun.parseAsInt(map['to_age'], 'to_age'),
      gender: map['gender']?.toString().trim() ?? '',
      premiumTerm: NumericFun.parseAsInt(map['premium_term'], 'premium_term'),
      premiumRate: NumericFun.parseAsDouble(
        map['premium_rate'],
        'premium_rate',
      ), // Handles space in key name
    );
  }
}
