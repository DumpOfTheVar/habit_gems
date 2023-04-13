import 'package:data_provider/data_provider.dart';

class Gem implements Serializable {
  Gem({
    this.id,
    required this.iconId,
    required this.title,
    required this.trigger,
    required this.description,
    required this.goalCount,
    required this.goalPeriod,
    required this.order,
    required this.isActive
  });

  factory Gem.fromJson(Map<String, dynamic> json) {
    return Gem(
      id: json['id'],
      iconId: json['iconId'],
      title: json['title'],
      trigger: json['trigger'],
      description: json['description'],
      goalCount: json['goalCount'],
      goalPeriod: GoalPeriod.fromDays(json['goalPeriod']),
      order: json['order'],
      isActive: json['isActive'],
    );
  }

  int? id;
  int iconId;
  String title;
  String trigger;
  String description;
  int goalCount;
  GoalPeriod goalPeriod;
  int order;
  bool isActive;

  Map<String, Object?> toJson() {
    return {
      'id': this.id,
      'iconId': this.iconId,
      'title': this.title,
      'trigger': this.trigger,
      'description': this.description,
      'goalCount': this.goalCount,
      'goalPeriod': this.goalPeriod.days,
      'order': this.order,
      'isActive': this.isActive,
    };
  }
}

enum GoalPeriod {
  day(1), week(7), month(30);

  const GoalPeriod(this.days);

  final int days;

  static GoalPeriod fromDays(int days) {
    switch (days) {
      case 1:
        return day;
      case 7:
        return week;
      case 30:
        return month;
    }
    throw Exception('Goal period for $days days is not defined.');
  }
}