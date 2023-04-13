
import 'dart:ui';
import 'package:data_provider/data_provider.dart';

class GemIcon implements Serializable {
  GemIcon({this.id, required this.color, required this.title});

  factory GemIcon.fromJson(Map<String, dynamic> json) {
    return GemIcon(
      id: json['id'],
      color: json['color'],
      title: json['title'],
    );
  }

  int? id;
  String color;
  String title;

  Color getColor() {
    return Color(int.parse(color, radix: 16) | 0xff000000);
  }

  Map<String, Object?> toJson() {
    return {
      'id': this.id,
      'color': this.color,
      'src': this.title,
    };
  }
}