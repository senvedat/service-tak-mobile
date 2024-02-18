class CurrentWorker {
  CurrentWorker({
    required this.status,
    required this.worker,
  });

  final String? status;
  final Worker? worker;

  factory CurrentWorker.fromJson(Map<String, dynamic> json) {
    return CurrentWorker(
      status: json["status"],
      worker: json["worker"] == null ? null : Worker.fromJson(json["worker"]),
    );
  }
}

class Worker {
  Worker({
    required this.id,
    required this.hotelId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.createdAt,
    required this.hotel,
  });

  final num? id;
  final num? hotelId;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? createdAt;
  final Hotel? hotel;

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json["id"],
      hotelId: json["hotel_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      role: json["role"],
      createdAt: json["created_at"],
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
