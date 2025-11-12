import 'package:equatable/equatable.dart';

/// Skill entity representing a user skill
/// Immutable and follows Value Object pattern
class Skill extends Equatable {
  final String name;
  final String level; // e.g., "Beginner", "Intermediate", "Expert"
  final double proficiency; // 0.0 to 1.0

  const Skill({
    required this.name,
    required this.level,
    required this.proficiency,
  });

  @override
  List<Object?> get props => [name, level, proficiency];

  @override
  String toString() =>
      'Skill(name: $name, level: $level, proficiency: $proficiency)';
}
