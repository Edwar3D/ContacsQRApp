class Contac {
  String name;
  String lastName;
  String number;
  String email;

  Contac(
      {required this.name,
      required this.lastName,
      required this.number,
      required this.email});

  factory Contac.fronJsonMap(Map<String, dynamic> json) {
    return Contac(
      name: json['name'],
      lastName: json['last_name'],
      number: json['number'],
      email: json['email'],
    );
  }
}
