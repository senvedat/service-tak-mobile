class HotelRoom {
    HotelRoom({
        required this.status,
        required this.room,
    });

    final String? status;
    final Room? room;

    factory HotelRoom.fromJson(Map<String, dynamic> json){ 
        return HotelRoom(
            status: json["status"],
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

    final int? id;
    final String? roomNumber;
    final String? startDate;
    final String? endDate;
    final List<Guest> guests;

    factory Room.fromJson(Map<String, dynamic> json){ 
        return Room(
            id: json["id"],
            roomNumber: json["room_number"],
            startDate: json["start_date"],
            endDate: json["end_date"],
            guests: json["guests"] == null ? [] : List<Guest>.from(json["guests"]!.map((x) => Guest.fromJson(x))),
        );
    }

}

class Guest {
    Guest({
        required this.id,
        required this.qrId,
        required this.passport,
        required this.roomId,
        required this.qr,
    });

    final int? id;
    final int? qrId;
    final String? passport;
    final int? roomId;
    final Qr? qr;

    factory Guest.fromJson(Map<String, dynamic> json){ 
        return Guest(
            id: json["id"],
            qrId: json["qr_id"],
            passport: json["passport"],
            roomId: json["room_id"],
            qr: json["qr"] == null ? null : Qr.fromJson(json["qr"]),
        );
    }

}

class Qr {
    Qr({
        required this.id,
        required this.url,
    });

    final int? id;
    final String? url;

    factory Qr.fromJson(Map<String, dynamic> json){ 
        return Qr(
            id: json["id"],
            url: json["url"],
        );
    }

}
