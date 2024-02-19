import 'package:service_tak_mobile/model/worker/qr_bracelet_model.dart';

class QrCard {
  QrCard({
    required this.id,
    required this.url,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.hotelId,
    required this.roomQr,
  });

  final num? id;
  final String? url;
  final String? type;
  final String? status;
  final String? createdAt;
  final num? hotelId;
  final RoomQr? roomQr;

  factory QrCard.fromJson(Map<String, dynamic> json) {
    return QrCard(
      id: json["id"],
      url: json["url"],
      type: json["type"],
      status: json["status"],
      createdAt: json["created_at"],
      hotelId: json["hotel_id"],
      roomQr: json["room_qr"] == null ? null : RoomQr.fromJson(json["room_qr"]),
    );
  }
}

class RoomQr {
  RoomQr({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.qrId,
    required this.roomId,
    required this.room,
  });

  final num? id;
  final String? createdAt;
  final String? updatedAt;
  final num? qrId;
  final num? roomId;
  final Room? room;

  factory RoomQr.fromJson(Map<String, dynamic> json) {
    return RoomQr(
      id: json["id"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      qrId: json["qr_id"],
      roomId: json["room_id"],
      room: json["room"] == null ? null : Room.fromJson(json["room"]),
    );
  }
}

class Room {
  Room({
    required this.id,
    required this.roomNumber,
    required this.startDate,
    required this.endDate,
    required this.guests,
  });

  final num? id;
  final String? roomNumber;
  final String? startDate;
  final String? endDate;
  final List<Guest> guests;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      roomNumber: json["room_number"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      guests: json["guests"] == null
          ? []
          : List<Guest>.from(json["guests"]!.map((x) => Guest.fromJson(x))),
    );
  }
}

class Guest {
  Guest({
    required this.id,
    required this.passport,
    required this.towel,
    required this.roomId,
    required this.towelHistories,
  });

  final num? id;
  final String? passport;
  final bool? towel;
  final num? roomId;
  final List<TowelHistory> towelHistories;

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json["id"],
      passport: json["passport"],
      towel: json["towel"],
      roomId: json["room_id"],
      towelHistories: json["towel_histories"] == null
          ? []
          : List<TowelHistory>.from(
              json["towel_histories"]!.map((x) => TowelHistory.fromJson(x))),
    );
  }
}
