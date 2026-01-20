class AbsentUser {
  final String userId;
  final String name;
  final String reason;

  AbsentUser({
    required this.userId,
    required this.name,
    required this.reason,
  });

  factory AbsentUser.fromJson(Map<String, dynamic> json) {
    return AbsentUser(
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'reason': reason,
    };
  }
}

class Attendance {
  final String id;
  final String mealId;
  final String date;
  final int present;
  final int absent;
  final int totalRegistered;
  final List<AbsentUser> absentUsers;

  Attendance({
    required this.id,
    required this.mealId,
    required this.date,
    required this.present,
    required this.absent,
    required this.totalRegistered,
    required this.absentUsers,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as String? ?? '',
      mealId: json['mealId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      present: json['present'] as int? ?? 0,
      absent: json['absent'] as int? ?? 0,
      totalRegistered: json['totalRegistered'] as int? ?? 0,
      absentUsers: (json['absentUsers'] as List<dynamic>?)
              ?.map((e) => AbsentUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
