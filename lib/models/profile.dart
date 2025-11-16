import 'package:levelup/models/skill.dart';
import 'package:levelup/models/certification.dart';

class Profile {
  final int id;
  final int user;
  final String fieldOfStudy;
  final double gpa;
  final int score;
  final List<Skill> skills;
  final List<Certification> certifications;

  Profile({
    required this.id,
    required this.user,
    required this.fieldOfStudy,
    required this.gpa,
    required this.score,
    required this.skills,
    required this.certifications,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? 0,
      user: json['user'] ?? 0,
      fieldOfStudy: json['field_of_study'] ?? '',
      gpa: double.tryParse(json['gpa']?.toString() ?? '0.0') ?? 0.0,
      score: json['score'] ?? 0,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((skillJson) => Skill.fromJson(skillJson))
          .toList() ?? [],
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((certJson) => Certification.fromJson(certJson))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'field_of_study': fieldOfStudy,
      'gpa': gpa.toString(),
      'score': score,
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'certifications': certifications.map((cert) => cert.toJson()).toList(),
    };
  }
}