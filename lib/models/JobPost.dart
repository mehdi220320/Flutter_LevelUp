class JobPost {
  final String companyName;
  final String logo;
  final String title;
  final String description;
  final List<String> skills;
  final String experience;
  final String location;
  final int mutualConnections;
  final String image;

  JobPost({
    required this.companyName,
    required this.logo,
    required this.title,
    required this.description,
    required this.skills,
    required this.experience,
    required this.location,
    required this.mutualConnections,
    required this.image,
  });
  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'logo': logo,
      'title': title,
      'description': description,
      'skills': skills,
      'experience': experience,
      'location': location,
      'mutualConnections': mutualConnections,
      'image': image,
    };
  }

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      companyName: json['companyName'],
      logo: json['logo'],
      title: json['title'],
      description: json['description'],
      skills: List<String>.from(json['skills']),
      experience: json['experience'],
      location: json['location'],
      mutualConnections: json['mutualConnections'],
      image: json['image'],
    );
  }
}
