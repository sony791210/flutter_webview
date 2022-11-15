import 'dart:convert';

TokenModel tokenModelFromJson(String str) => TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel({
    this.code,
    this.url,
  });

  String? code;
  String? url;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    code: json["code"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "url": url,
  };
}
