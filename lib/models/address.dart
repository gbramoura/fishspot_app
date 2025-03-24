class Address {
  final String street;
  final int number;
  final String neighborhood;
  final String zipCode;

  Address({
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      number: json['number'],
      neighborhood: json['neighborhood'],
      zipCode: json['zipCode'],
    );
  }
}
