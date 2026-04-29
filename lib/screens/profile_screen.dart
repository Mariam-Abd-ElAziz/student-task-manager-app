// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../db/db_helper.dart';
// import '../models/user.dart';

// class ProfileScreen extends StatefulWidget {
//   final User user;

//   const ProfileScreen({super.key, required this.user});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _fullNameController;
//   late TextEditingController _emailController;
//   late TextEditingController _studentIdController;

//   String? _selectedGender;
//   int? _selectedAcademicLevel;
//   String? _profilePhotoPath;

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fullNameController = TextEditingController(text: widget.user.fullName);
//     _emailController = TextEditingController(text: widget.user.uniEmail);
//     _studentIdController = TextEditingController(text: widget.user.studentId);
//     _selectedGender = widget.user.gender;
//     _selectedAcademicLevel = widget.user.academicLevel;
//     _profilePhotoPath = widget.user.profilePhoto;
//   }

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _studentIdController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final ImagePicker picker = ImagePicker();
//     try {
//       final XFile? image = await picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           _profilePhotoPath = image.path;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error picking image: $e')),
//         );
//       }
//     }
//   }

//   void _showImagePickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Take a photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Choose from gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _updateProfile() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final data = {
//           'full_name': _fullNameController.text.trim(),
//           'gender': _selectedGender,
//           'academic_level': _selectedAcademicLevel,
//           'profile_photo': _profilePhotoPath,
//         };

//         if (widget.user.studentId != null) {
//           await DatabaseHelper.instance.updateUser(widget.user.studentId, data);

//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Profile updated successfully')),
//             );
//           }
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to update profile: $e')),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }
//   void _logout() {
//   Navigator.of(context).pushNamedAndRemoveUntil(
//     '/login',
//     (route) => false,
//   );
// }
// void _confirmLogout() {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Logout'),
//       content: const Text('Are you sure you want to logout?'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//             _logout();
//           },
//           child: const Text('Logout'),
//         ),
//       ],
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _isLoading ? null : _updateProfile,
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _confirmLogout,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Stack(
//                         children: [
//                           CircleAvatar(
//                             radius: 60,
//                             backgroundColor: Colors.grey.shade300,
//                             backgroundImage: _profilePhotoPath != null && _profilePhotoPath!.isNotEmpty
//                                 ? FileImage(File(_profilePhotoPath!))
//                                 : null,
//                             child: _profilePhotoPath == null || _profilePhotoPath!.isEmpty
//                                 ? const Icon(Icons.person, size: 60, color: Colors.grey)
//                                 : null,
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).primaryColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(Icons.camera_alt, color: Colors.white),
//                                 onPressed: _showImagePickerOptions,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     TextFormField(
//                       controller: _fullNameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Full Name',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your full name';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(
//                         labelText: 'University Email',
//                         border: OutlineInputBorder(),
//                       ),
//                       enabled: false, // Email is generally non-editable
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _studentIdController,
//                       decoration: const InputDecoration(
//                         labelText: 'Student ID',
//                         border: OutlineInputBorder(),
//                       ),
//                       enabled: false, // Student ID is generally non-editable
//                     ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'Gender',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: _selectedGender,
//                       items: const [
//                         DropdownMenuItem(value: 'Male', child: Text('Male')),
//                         DropdownMenuItem(value: 'Female', child: Text('Female')),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedGender = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<int>(
//                       decoration: const InputDecoration(
//                         labelText: 'Academic Level',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: _selectedAcademicLevel,
//                       items: List.generate(4, (index) {
//                         return DropdownMenuItem(
//                           value: index + 1,
//                           child: Text('Level ${index + 1}'),
//                         );
//                       }),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedAcademicLevel = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _updateProfile,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: const Text('Save Changes', style: TextStyle(fontSize: 18)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _studentIdController;

  String? _selectedGender;
  int? _selectedAcademicLevel;
  String? _profilePhotoPath;

  bool _isLoading = false;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _studentIdController = TextEditingController(text: widget.user.studentId);

    _loadUserFromFirebase();
  }

  // ================= LOAD PROFILE =================
  Future<void> _loadUserFromFirebase() async {
    final doc = await _db
        .collection("users")
        .doc(widget.user.studentId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;

      setState(() {
        _fullNameController.text = data["fullName"] ?? "";
        _emailController.text = data["email"] ?? "";
        _selectedGender = data["gender"];
        _selectedAcademicLevel = int.tryParse(data["academicLevel"].toString());
        _profilePhotoPath = data["profilePhoto"];
      });
    } else {
      // fallback from constructor
      setState(() {
        _fullNameController.text = widget.user.fullName;
        _emailController.text = widget.user.uniEmail;
        _selectedGender = widget.user.gender;
        _selectedAcademicLevel = widget.user.academicLevel;
        _profilePhotoPath = widget.user.profilePhoto;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  // ================= PICK IMAGE =================
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _profilePhotoPath = image.path;
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  // ================= SAVE PROFILE =================
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _db.collection("users").doc(widget.user.studentId).set({
        "studentId": widget.user.studentId,
        "fullName": _fullNameController.text.trim(),
        "email": _emailController.text.trim(),
        "gender": _selectedGender,
        "academicLevel": _selectedAcademicLevel,
        "profilePhoto": _profilePhotoPath,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully ✅")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  // ================= LOGOUT =================
  void _logout() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    // ================= IMAGE =================
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _profilePhotoPath != null
                              ? FileImage(File(_profilePhotoPath!))
                              : null,
                          child: _profilePhotoPath == null
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: _showImagePickerOptions,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ================= NAME =================
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 16),

                    // ================= EMAIL =================
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),

                    const SizedBox(height: 16),

                    // ================= STUDENT ID =================
                    TextFormField(
                      controller: _studentIdController,
                      decoration: const InputDecoration(
                        labelText: "Student ID",
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),

                    const SizedBox(height: 16),

                    // ================= GENDER =================
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "Male", child: Text("Male")),
                        DropdownMenuItem(
                            value: "Female", child: Text("Female")),
                      ],
                      onChanged: (v) {
                        setState(() => _selectedGender = v);
                      },
                    ),

                    const SizedBox(height: 16),

                    // ================= ACADEMIC LEVEL =================
                    DropdownButtonFormField<int>(
                      value: _selectedAcademicLevel,
                      decoration: const InputDecoration(
                        labelText: "Academic Level",
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(4, (i) {
                        return DropdownMenuItem(
                          value: i + 1,
                          child: Text("Level ${i + 1}"),
                        );
                      }),
                      onChanged: (v) {
                        setState(() => _selectedAcademicLevel = v);
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        child: const Text("Save Changes"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
