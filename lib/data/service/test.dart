import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/data/data.dart';

class TestService extends BaseNetworkService<TestModel>
    implements TestServiceImpl {
  TestService() : super(ClientEndPoint.weather);

  @override
  Future<void> syncTask(String name) async => create({'name': name});

  @override
  TestModel fromJson(Map<String, dynamic> json) => TestModel.fromJson(json);
}

class TestModel {
  int? id;
  String? name;

  TestModel({this.id, this.name});

  TestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
