import 'package:firebaseappdistribution/core/core.dart';

class UserModel {
  final int? id;
  final String name;
  final String phone;
  final String nrc;
  final String address;

  const UserModel({
    this.id,
    required this.name,
    required this.phone,
    required this.nrc,
    required this.address,
  });

  Map<String, dynamic> toEncryptedMap(String password) {
    return {
      'id': id,
      'name': EncryptionService.encryptText(name, password),
      'phone': EncryptionService.encryptText(phone, password),
      'nrc': EncryptionService.encryptText(nrc, password),
      'address': address,
    };
  }

  factory UserModel.fromEncryptedMap(
    Map<String, dynamic> map,
    String password,
  ) {
    return UserModel(
      id: map['id'] as int?,
      name: EncryptionService.decryptText(map['name'] as String, password),
      phone: EncryptionService.decryptText(map['phone'] as String, password),
      nrc: EncryptionService.decryptText(map['nrc'] as String, password),
      address: map['address'] as String,
    );
  }
}
