
import 'package:data_provider/data_provider.dart';

class Setting implements Serializable {
  Setting({this.id, required this.name, required this.value});
  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id'],
      name: json['name'],
      value: json['value'].toString(),
    );
  }

  int? id;
  String name;
  String value;

  Map<String, Object?> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'value': this.value,
    };
  }
}