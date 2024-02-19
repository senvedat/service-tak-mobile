class GeneratedQr {
    GeneratedQr({
        required this.status,
        required this.svg,
    });

    final String? status;
    final String? svg;

    factory GeneratedQr.fromJson(Map<String, dynamic> json){ 
        return GeneratedQr(
            status: json["status"],
            svg: json["svg"],
        );
    }

}
