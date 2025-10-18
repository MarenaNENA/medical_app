class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String email;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.email,
  });

  factory Doctor.fromMap(Map<String, dynamic> data, String docId) {
    return Doctor(
      id: docId,
      name: data['firstName'] + ' ' + (data['lastName'] ?? ''),
      specialization: data['department'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': name.split(' ').first,
      'lastName': name.split(' ').length > 1 ? name.split(' ').last : '',
      'department': specialization,
      'email': email,
    };
  }
}
