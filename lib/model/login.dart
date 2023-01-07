// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
     this.token,
     this.message,
     this.code,
  });

  String? token;
  String? message;
  String? code;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    token: json["token"],
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "message": message,
    "code": code,
  };
}
