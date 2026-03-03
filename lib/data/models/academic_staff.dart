/// Model for a university academic staff member.
class AcademicStaff {
  final String name;
  final String title; // Unvan: Prof. Dr., Doç. Dr., Dr. Öğr. Üyesi, etc.
  final String email;
  final String office;
  final String? department;
  final String? imageUrl;

  const AcademicStaff({
    required this.name,
    required this.title,
    required this.email,
    required this.office,
    this.department,
    this.imageUrl,
  });

  /// Create from JSON map (local asset).
  factory AcademicStaff.fromJson(Map<String, dynamic> json) {
    return AcademicStaff(
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      email: json['email'] as String? ?? '',
      office: json['office'] as String? ?? '',
      department: json['department'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'email': email,
        'office': office,
        if (department != null) 'department': department,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

  /// Full display name with title: "Prof. Dr. Ahmet Yılmaz"
  String get displayName => title.isNotEmpty ? '$title $name' : name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AcademicStaff &&
          other.name == name &&
          other.title == title &&
          other.email == email;

  @override
  int get hashCode => Object.hash(name, title, email);

  @override
  String toString() => 'AcademicStaff($displayName, $office)';
}
