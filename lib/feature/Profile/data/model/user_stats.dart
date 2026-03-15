class UserStats {
  final UserStatistics statistics;
  final LoyaltyInfo loyalty;
  final int favoritesCount;

  UserStats({
    required this.statistics,
    required this.loyalty,
    required this.favoritesCount,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      statistics: UserStatistics.fromJson(json['statistics'] ?? {}),
      loyalty: LoyaltyInfo.fromJson(json['loyalty'] ?? {}),
      favoritesCount: json['favoritesCount'] ?? 0,
    );
  }
}

class UserStatistics {
  final int totalOrders;
  final int totalReservations;
  final double totalSpent;
  final double averageOrderValue;

  UserStatistics({
    this.totalOrders = 0,
    this.totalReservations = 0,
    this.totalSpent = 0,
    this.averageOrderValue = 0,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalOrders: json['totalOrders'] ?? 0,
      totalReservations: json['totalReservations'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      averageOrderValue: (json['averageOrderValue'] ?? 0).toDouble(),
    );
  }
}

class LoyaltyInfo {
  final int points;
  final String tier;
  final int lifetimePoints;

  LoyaltyInfo({this.points = 0, this.tier = 'Bronze', this.lifetimePoints = 0});

  factory LoyaltyInfo.fromJson(Map<String, dynamic> json) {
    return LoyaltyInfo(
      points: json['points'] ?? 0,
      tier: json['tier'] ?? 'Bronze',
      lifetimePoints: json['lifetimePoints'] ?? 0,
    );
  }
}
