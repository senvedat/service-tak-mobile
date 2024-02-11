class ErrorResponse {
  ErrorResponse({
    required this.message,
  });

  final String? message;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json["message"],
    );
  }
}
