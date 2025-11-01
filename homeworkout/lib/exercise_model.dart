

class Exercise {
  final String name;
  final String imageUrl;

  Exercise({
    required this.name,
    required this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? 'No Name Provided',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}