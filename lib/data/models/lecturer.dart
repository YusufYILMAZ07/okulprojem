/// Simple model for lecturer information.
class Lecturer {
  final String name;
  final String office;
  final String email;

  const Lecturer({
    required this.name,
    required this.office,
    required this.email,
  });

  /// Create from JSON map.
  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      name: json['name'] as String? ?? '',
      office: json['office'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'office': office,
        'email': email,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lecturer &&
          other.name == name &&
          other.office == office &&
          other.email == email;

  @override
  int get hashCode => name.hashCode ^ office.hashCode ^ email.hashCode;
}
