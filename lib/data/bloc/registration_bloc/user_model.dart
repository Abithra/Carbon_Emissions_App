// user_model.dart
class User {
  final int id;
  final String name;
  final String email;
  final String age;
  final String password;
  final String country;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.password,
    required this.country,
  });

  // Add this method to convert User to a map for SQLite operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'password': password,
      'country': country,
    };
  }
}
