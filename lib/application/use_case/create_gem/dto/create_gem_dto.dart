
class CreateGemDto {
  CreateGemDto({
    required this.iconId,
    required this.title,
    required this.trigger,
    required this.description,
    required this.goalCount,
    required this.goalPeriod,
  });

  final int iconId;
  final String title;
  final String trigger;
  final String description;
  final int goalCount;
  final int goalPeriod;
}