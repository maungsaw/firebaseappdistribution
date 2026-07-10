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

  Map<String, dynamic> toEncryptedMap() {
    return {
      'id': id,
      'name': EncryptionService.encryptField(name, UserField.name),
      'phone': EncryptionService.encryptField(phone, UserField.phone),
      'nrc': EncryptionService.encryptField(nrc, UserField.nrc),
      'address': address,
    };
  }

  factory UserModel.fromEncryptedMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: EncryptionService.decryptField(map['name'] as String, UserField.name),
      phone: EncryptionService.decryptField(
        map['phone'] as String,
        UserField.phone,
      ),
      nrc: EncryptionService.decryptField(map['nrc'] as String, UserField.nrc),
      address: map['address'] as String,
    );
  }
}
