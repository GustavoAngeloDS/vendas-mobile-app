import 'dart:convert';

class ErrorDTO {
  String message;

  ErrorDTO(this.message);

  ErrorDTO.create(this.message);

  static ErrorDTO fromMap(Map<String, dynamic> map) {
    return ErrorDTO(
        map["message"]
    );
  }

  static ErrorDTO fromJson(String json) => ErrorDTO.fromMap(jsonDecode(json));
}