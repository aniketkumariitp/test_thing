class ProfileModel {
  final String name;
  final String email;
  final String password;
  final String profilePic;

  ProfileModel({
    required this.name,
    required this.email,
    required this.password,
    required this.profilePic,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'profilePic': profilePic,
    };
  }
}
