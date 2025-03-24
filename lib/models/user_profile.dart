import 'package:fishspot_app/models/address.dart';
import 'package:fishspot_app/models/spot_details.dart';

class UserProfile {
  final String username;
  final String name;
  final String email;
  final String? description;
  final String? image;
  final Address? address;
  final SpotDetails? spotDetails;

  UserProfile({
    required this.username,
    required this.name,
    required this.email,
    this.description,
    this.image,
    this.spotDetails,
    this.address,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    Address address = Address(
      street: '',
      number: 0,
      neighborhood: '',
      zipCode: '',
    );

    if (json['address'] != null) {
      address = Address.fromJson(json['address']);
    }

    return UserProfile(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      description: json['description'],
      image: json['image'],
      spotDetails: SpotDetails.fromJson(json['spotDetails']),
      address: address,
    );
  }
}
