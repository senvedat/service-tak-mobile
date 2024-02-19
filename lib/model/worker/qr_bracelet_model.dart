class QrBracelet {
  QrBracelet({
    required this.id,
    required this.url,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.hotelId,
    required this.guest,
  });

  final num? id;
  final String? url;
  final String? type;
  final String? status;
  final String? createdAt;
  final num? hotelId;
  final Guest? guest;

  factory QrBracelet.fromJson(Map<String, dynamic> json) {
    return QrBracelet(
      id: json["id"],
      url: json["url"],
      type: json["type"],
      status: json["status"],
      createdAt: json["created_at"],
      hotelId: json["hotel_id"],
      guest: json["guest"] == null ? null : Guest.fromJson(json["guest"]),
    );
  }
}

class Guest {
  Guest({
    required this.id,
    required this.passport,
    required this.towel,
    required this.createdAt,
    required this.updatedAt,
    required this.hotelId,
    required this.qrId,
    required this.roomId,
    required this.room,
    required this.towelHistories,
  });

  final num? id;
  final String? passport;
  final bool? towel;
  final String? createdAt;
  final String? updatedAt;
  final num? hotelId;
  final num? qrId;
  final num? roomId;
  final Room? room;
  final List<TowelHistory> towelHistories;

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json["id"],
      passport: json["passport"],
      towel: json["towel"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      hotelId: json["hotel_id"],
      qrId: json["qr_id"],
      roomId: json["room_id"],
      room: json["room"] == null ? null : Room.fromJson(json["room"]),
      towelHistories: json["towel_histories"] == null
          ? []
          : List<TowelHistory>.from(
              json["towel_histories"]!.map((x) => TowelHistory.fromJson(x))),
    );
  }
}

class Room {
  Room({
    required this.id,
    required this.roomNumber,
    required this.startDate,
    required this.endDate,
  });

  final num? id;
  final String? roomNumber;
  final String? startDate;
  final String? endDate;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      roomNumber: json["room_number"],
      startDate: json["start_date"],
      endDate: json["end_date"],
    );
  }
}

class TowelHistory {
  TowelHistory({
    required this.id,
    required this.towel,
    required this.towelGiverName,
    required this.towelGiverRole,
    required this.createdAt,
    required this.updatedAt,
  });

  final num? id;
  final String? towel;
  final String? towelGiverName;
  final String? towelGiverRole;
  final String? createdAt;
  final String? updatedAt;

  factory TowelHistory.fromJson(Map<String, dynamic> json) {
    return TowelHistory(
      id: json["id"],
      towel: json["towel"],
      towelGiverName: json["towel_giver_name"],
      towelGiverRole: json["towel_giver_role"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}
