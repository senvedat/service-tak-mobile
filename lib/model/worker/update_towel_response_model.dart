class UpdateTowelResponse {
    UpdateTowelResponse({
        required this.status,
        required this.message,
    });

    final String? status;
    final String? message;

    factory UpdateTowelResponse.fromJson(Map<String, dynamic> json){ 
        return UpdateTowelResponse(
            status: json["status"],
            message: json["message"],
        );
    }

}
