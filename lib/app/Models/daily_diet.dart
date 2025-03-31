class DailyDiet {
  final String id;
  final String userId;
  final String date;
  final Map<String, List<dynamic>> meals;

  DailyDiet({
    required this.id,
    required this.userId,
    required this.date,
    required this.meals,
  });
}
