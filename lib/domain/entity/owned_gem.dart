
import 'package:data_provider/data_provider.dart';

class OwnedGem implements Serializable {
  OwnedGem({
    this.id,
    required this.gemId,
    required this.date,
    required this.day,
  });

  factory OwnedGem.fromJson(Map<String, dynamic> json) {
    return OwnedGem(
      id: json['id'],
      gemId: json['gemId'],
      date: json['date'],
      day: json['day'],
    );
  }

  int? id;
  int gemId;
  DateTime date;
  DateTime day;

  Map<String, Object?> toJson() {
    return {
      'id': this.id,
      'gemId': this.gemId,
      'date': this.date,
      'day': this.day,
    };
  }
}