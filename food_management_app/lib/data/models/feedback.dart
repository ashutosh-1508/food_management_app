class MealFeedback {
  final String id;
  final String mealId;
  final String mealType;
  final String date;
  final String time;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String comment;
  final String timestamp;

  MealFeedback({
    required this.id,
    required this.mealId,
    required this.mealType,
    required this.date,
    required this.time,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory MealFeedback.fromJson(Map<String, dynamic> json) {
    return MealFeedback(
      id: json['id'] as String? ?? '',
      mealId: json['mealId'] as String? ?? '',
      mealType: json['mealType'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userAvatar: json['userAvatar'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}
