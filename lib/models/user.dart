class User {
  final int? id;
  final String fullName;
  final String uniEmail;
  final String studentId;
  final String? gender;
  final int? academicLevel;
  final String password;
  final String? profilePhoto;

  User({
    this.id,
    required this.fullName,
    required this.uniEmail,
    required this.studentId,
    this.gender,
    this.academicLevel,
    required this.password,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'uni_email': uniEmail,
      'student_id': studentId,
      'gender': gender,
      'academic_level': academicLevel,
      'password': password,
      'profile_photo': profilePhoto,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['full_name'],
      uniEmail: map['uni_email'],
      studentId: map['student_id'],
      gender: map['gender'],
      academicLevel: map['academic_level'],
      password: map['password'],
      profilePhoto: map['profile_photo'],
    );
  }
}