abstract class RegisterProductResponse {
  String message;
  bool status;

  RegisterProductResponse({
    required this.message,
    required this.status,
  });

  RegisterProductResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] ?? '',
        status = json['status'] ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
