class NewGuest {
    NewGuest({
        required this.id,
        required this.roomId,
    });

    final int? id;
    final int? roomId;

    factory NewGuest.fromJson(Map<String, dynamic> json){ 
        return NewGuest(
            id: json["id"],
            roomId: json["room_id"],
        );
    }

}
