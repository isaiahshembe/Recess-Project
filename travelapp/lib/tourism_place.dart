class TourismPlace {
  final String id;
  final String name;
  final String image;
  final String location;
  final double rating;
  final double price;
  final String description;
  final double latitude; // Add latitude
  final double longitude; // Add longitude

  TourismPlace({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.rating,
    required this.price,
    required this.description,
    required this.latitude, // Initialize latitude
    required this.longitude, // Initialize longitude
  });
}
