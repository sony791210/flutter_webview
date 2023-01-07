import 'dart:convert';

TokenModel tokenModelFromJson(String str) => TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel({
    this.code,
    this.url,
    this.message,
  });

  String? code;
  String? url;
  String? message;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    code: json["code"],
    url: json["url"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "url": url,
    "message": message,
  };
}
