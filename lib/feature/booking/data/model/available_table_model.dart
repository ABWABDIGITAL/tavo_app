class AvailableTable {
  final String id;
  final String code;
  final int seats;
  final String? type;
  final double? posX;
  final double? posY;

  const AvailableTable({
    required this.id,
    required this.code,
    required this.seats,
    this.type,
    this.posX,
    this.posY,
  });

  factory AvailableTable.fromJson(Map<String, dynamic> json) {
    return AvailableTable(
      id: json['id'] ?? json['_id'] ?? '',
      code: json['code'] ?? '',
      seats: json['seats'] ?? 0,
      type: json['type'],
      posX: json['posX']?.toDouble(),
      posY: json['posY']?.toDouble(),
    );
  }
}

class AvailabilityResponse {
  final bool available;
  final String? message;
  final String? restaurantId;
  final String? date;
  final String? time;
  final WorkingHours? workingHours;
  final AvailabilityData? availability;

  const AvailabilityResponse({
    this.available = false,
    this.message,
    this.restaurantId,
    this.date,
    this.time,
    this.workingHours,
    this.availability,
  });

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponse(
      available: json['available'] ?? false,
      message: json['message'],
      restaurantId: json['restaurantId'],
      date: json['date'],
      time: json['time'],
      workingHours: json['workingHours'] != null
          ? WorkingHours.fromJson(json['workingHours'])
          : null,
      availability: json['availability'] != null
          ? AvailabilityData.fromJson(json['availability'])
          : null,
    );
  }
}

class WorkingHours {
  final String day;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  const WorkingHours({
    required this.day,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      day: json['day'] ?? '',
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
      isClosed: json['isClosed'] ?? false,
    );
  }

  List<String> generateTimeSlots({int intervalMinutes = 30}) {
    if (isClosed) return [];

    final slots = <String>[];
    final openParts = openTime.split(':');
    final closeParts = closeTime.split(':');

    final openMinutes = int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
    final closeMinutes =
        int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);

    for (int mins = openMinutes; mins < closeMinutes; mins += intervalMinutes) {
      final hour = mins ~/ 60;
      final minute = mins % 60;
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      slots.add(
        '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period',
      );
    }

    return slots;
  }
}

class AvailabilityData {
  final int availableTables;
  final int availableSeats;
  final int estimatedWaitMinutes;
  final List<AvailableTable> tables;

  const AvailabilityData({
    this.availableTables = 0,
    this.availableSeats = 0,
    this.estimatedWaitMinutes = 0,
    this.tables = const [],
  });

  factory AvailabilityData.fromJson(Map<String, dynamic> json) {
    final tablesList =
        (json['tables'] as List<dynamic>?)
            ?.map((e) => AvailableTable.fromJson(e))
            .toList() ??
        [];

    return AvailabilityData(
      availableTables: json['availableTables'] ?? 0,
      availableSeats: json['availableSeats'] ?? 0,
      estimatedWaitMinutes: json['estimatedWaitMinutes'] ?? 0,
      tables: tablesList,
    );
  }
}
