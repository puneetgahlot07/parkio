class ErrorResponse {
  int? statusCode;
  List<String>? message;
  String? error;

  ErrorResponse({this.statusCode, this.message, this.error});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    try {
      statusCode = json['statusCode'];
      message = json['message'].cast<String>();
      error = json['error'];
    } catch (e) {
      statusCode = json['statusCode'];
      message = [json['message']];
      error = json['error'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['error'] = error;
    return data;
  }
}
