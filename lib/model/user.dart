class User {
  final String imagePath;
  final String id;
  final String name;
  final String email;
  final String about;
  final String country;
  int followers = 0;

   User({
    required this.imagePath,
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.country,
    required this.followers,
  });
}
