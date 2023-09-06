import 'dart:convert';

class User {
  String name;
  String password;

  User(this.name, this.password);
  String toJson() {
    return jsonEncode({
      'name': name,
      'password': password,
    });
  }
}
