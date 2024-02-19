class HotelSummary {
  final String status;
  final Summary summary;

  HotelSummary({
    required this.status,
    required this.summary,
  });

  factory HotelSummary.fromJson(Map<String, dynamic> json) {
    return HotelSummary(
      status: json['status'],
      summary: Summary.fromJson(json['summary']),
    );
  }
}

class Summary {
  final num totalRoom;
  final num totalGuest;
  final num totalActiveQr;

  Summary({
    required this.totalRoom,
    required this.totalGuest,
    required this.totalActiveQr,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalRoom: json["total_room"],
      totalGuest: json["total_guest"],
      totalActiveQr: json["total_active_qr"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_room'] = totalRoom;
    data['total_guest'] = totalGuest;
    data['total_active_qr'] = totalActiveQr;
    return data;
  }
}
