import '../../domain/entities/skill.dart';

/// Skill Model for data layer
/// Extends entity and adds JSON serialization capability
/// Follows Open/Closed Principle - extends without modifying entity
class SkillModel extends Skill {
  const SkillModel({
    required super.name,
    required super.level,
    required super.proficiency,
  });

  /// Factory constructor from JSON
  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] as String,
      level: json['level'] as String,
      proficiency: (json['proficiency'] as num).toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'level': level, 'proficiency': proficiency};
  }

  /// Convert model to entity
  Skill toEntity() {
    return Skill(name: name, level: level, proficiency: proficiency);
  }

  /// Create model from entity
  factory SkillModel.fromEntity(Skill skill) {
    return SkillModel(
      name: skill.name,
      level: skill.level,
      proficiency: skill.proficiency,
    );
  }
}
