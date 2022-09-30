class Customer {
  final String id;
  final String username;
  final String email;
  final String token;

  Customer({required this.id, required this.username, required this.email, required this.token});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'username' : username,
    'email' : email,
    'token' : token,
  };
}