class SpotLocation {
  final String id;
  final String title;
  final String? image;
  final List<num> coordinates;

  SpotLocation({
    required this.id,
    required this.title,
    required this.coordinates,
    this.image,
  });

  factory SpotLocation.fromJson(Map<String, dynamic> json) {
    return SpotLocation(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      coordinates: List<num>.from(json['coordinates']),
    );
  }
}
