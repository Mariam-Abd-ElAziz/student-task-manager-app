class User {
  final String studentId;
  final String fullName;
  final String uniEmail;
  final String? gender;
  final int? academicLevel;
  final String password;
  final String? profilePhoto;

  User({
    required this.studentId,
    required this.fullName,
    required this.uniEmail,
    this.gender,
    this.academicLevel,
    required this.password,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'full_name': fullName,
      'uni_email': uniEmail,
      'gender': gender,
      'academic_level': academicLevel,
      'password': password,
      'profile_photo': profilePhoto,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      studentId: map['student_id'],
      fullName: map['full_name'],
      uniEmail: map['uni_email'],
      gender: map['gender'],
      academicLevel: map['academic_level'],
      password: map['password'],
      profilePhoto: map['profile_photo'],
    );
  }
}