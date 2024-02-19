class CurrentHotel {
  CurrentHotel({
    required this.status,
    required this.hotel,
  });

  final String? status;
  final Hotel? hotel;

  factory CurrentHotel.fromJson(Map<String, dynamic> json) {
    return CurrentHotel(
      status: json["status"],
      hotel: json["hotel"] == null ? null : Hotel.fromJson(json["hotel"]),
    );
  }
}

class Hotel {
  Hotel({
    required this.id,
    required this.logo,
    required this.hotelName,
    required this.email,
    required this.type,
    required this.endDate,
    required this.createdAt,
  });

  final num? id;
  final String? logo;
  final String? hotelName;
  final String? email;
  final String type;
  final String? endDate;
  final String? createdAt;

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json["id"],
      logo: json["logo"],
      hotelName: json["hotel_name"],
      email: json["email"],
      type: json["type"],
      endDate: json["end_date"],
      createdAt: json["created_at"],
    );
  }
}
