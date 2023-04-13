
class UpdateGemDto {
  UpdateGemDto({
    required this.id,
    required this.iconId,
    required this.title,
    required this.trigger,
    required this.description,
    required this.goalCount,
    required this.goalPeriod,
    required this.isActive
  });

  final int id;
  final int iconId;
  final String title;
  final String trigger;
  final String description;
  final int goalCount;
  final int goalPeriod;
  final bool isActive;
}