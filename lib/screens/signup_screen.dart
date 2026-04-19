import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  int? _selectedAcademicLevel;

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        fullName: _fullNameController.text,
        uniEmail: _emailController.text,
        studentId: _studentIdController.text,
        gender: _selectedGender,
        academicLevel: _selectedAcademicLevel,
        password: _passwordController.text,
      );

       try {
      // Try local SQLite first
      try {
        await DatabaseHelper.instance.insertUser(user);
      } catch (dbError) {
        print('Local DB not available on web: $dbError');
      }

      // Always sync to Firebase regardless
      await ApiService().saveUser({
        'fullName': _fullNameController.text,
        'studentId': _studentIdController.text,
        'email': _emailController.text,
        'gender': _selectedGender ?? 'Not specified',
        'academicLevel': _selectedAcademicLevel?.toString() ?? 'Not specified',
      });


  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signup Success')),
    );
    Navigator.pushNamedAndRemoveUntil(
      context, '/login', (route) => false,
    );
          // Navigate to login or home screen
          // Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup Failure: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup Failure: Please fix the validation errors.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full name is mandatory.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Gender (Optional)'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(labelText: 'Student ID *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Student ID is mandatory.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'University Email *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'University Email is mandatory.';
                  }
                  
                  final studentId = _studentIdController.text;
                  final expectedEmail = '$studentId@stud.fci-cu.edu.eg';
                  
                  if (value != expectedEmail) {
                    return 'Email must match: $studentId@stud.fci-cu.edu.eg';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Academic Level (Optional)'),
                value: _selectedAcademicLevel,
                items: [1, 2, 3, 4]
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAcademicLevel = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password *'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is mandatory.';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters.';
                  }
                  if (!value.contains(RegExp(r'\d'))) {
                    return 'Password must contain at least one number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password *'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Password is mandatory.';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _signup,
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
