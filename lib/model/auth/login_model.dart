class LoginResponseModel {
  LoginResponseModel({
    required this.status,
    required this.type,
    required this.token,
  });

  final String? status;
  final String? type;
  final String? token;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json["status"],
      type: json["type"],
      token: json["token"],
    );
  }
}
