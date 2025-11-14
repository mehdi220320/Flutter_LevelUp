class Offer {
  final int id;
  final String title;
  final String company;
  final String fieldRequired;
  final String description;
  final String location;
  final List<Skill> requiredSkills;

  Offer({
    required this.id,
    required this.title,
    required this.company,
    required this.fieldRequired,
    required this.description,
    required this.location,
    required this.requiredSkills,
  });

  String get logo {
    switch (company.toUpperCase()) {
      case 'GOOGLE':
        return '🔍';
      case 'FACEBOOK':
        return '👤';
      case 'APPLE':
        return '🍎';
      case 'MICROSOFT':
        return '💻';
      case 'AMAZON':
        return '📦';
      default:
        return '🏢';
    }
  }

  String get image {
    switch (company.toUpperCase()) {
      case 'GOOGLE':
        return "assets/images/landingPageHero.png";
      case 'FACEBOOK':
        return "assets/images/landingPageHero2.jpg";
      case 'APPLE':
        return "assets/images/landingPageHero.png";
      case 'MICROSOFT':
        return "assets/images/landingPageHero2.jpg";
      case 'AMAZON':
        return "assets/images/landingPageHero.png";
      default:
        return "assets/images/landingPageHero2.jpg";
    }
  }

  String get experience {
    if (title.toLowerCase().contains('senior')) {
      return "5+ years";
    } else if (title.toLowerCase().contains('mid') ||
        title.toLowerCase().contains('intermediate')) {
      return "3+ years";
    } else if (title.toLowerCase().contains('junior') ||
        title.toLowerCase().contains('entry')) {
      return "1 years";
    } else {
      return "0-1 years";
    }
  }

  int get mutualConnections => (id * 3) % 10;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Offer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'field_required': fieldRequired,
      'description': description,
      'location': location,
      'required_skills': requiredSkills.map((skill) => skill.toJson()).toList(),
    };
  }

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      fieldRequired: json['field_required'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      requiredSkills:
          (json['required_skills'] as List<dynamic>?)
              ?.map((skillJson) => Skill.fromJson(skillJson))
              .toList() ??
          [],
    );
  }
}

class Skill {
  final int id;
  final String name;

  Skill({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
