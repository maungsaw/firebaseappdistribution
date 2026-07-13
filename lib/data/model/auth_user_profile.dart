class UserProfileModel {
  final String? id;
  final String mobileNumber;
  final String? email;
  final String? fullName;

  const UserProfileModel({
    this.id,
    required this.mobileNumber,
    this.email,
    this.fullName,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString(),
      mobileNumber: json['mobileNumber']?.toString() ?? '',
      email: json['email']?.toString(),
      fullName: json['fullName']?.toString(),
    );
  }
}
