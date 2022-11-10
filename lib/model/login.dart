// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
     this.accesstoken,
     this.message,
     this.code,
  });

  String? accesstoken;
  String? message;
  String? code;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    accesstoken: json["accesstoken"],
    message: json["message"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "accesstoken": accesstoken,
    "message": message,
    "code": code,
  };
}
