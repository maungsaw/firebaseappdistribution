class PremiumTermModel {
  final int? id;
  final String label;
  final int value;

  PremiumTermModel({this.id, required this.label, required this.value});
  Map<String, dynamic> toMap() {
    return {'id': id, 'label': label, 'value': value};
  }

  factory PremiumTermModel.fromMap(Map<String, dynamic> map) {
    // Helper to safely parse numbers regardless of whether they come as String, int, double, or custom cell values

    return PremiumTermModel(
      id: map['id'],
      label: map['label'],
      value: map['value'],
      // Handles space in key name
    );
  }
}
