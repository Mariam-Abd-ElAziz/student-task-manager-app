import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import 'signup_screen.dart';
import 'task_management_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        dynamic user;

        // Try local SQLite first
        try {
          user = await DatabaseHelper.instance.getUserByCredentials(
            _emailController.text.trim(),
            _passwordController.text,
          );
        } catch (dbError) {
          print('SQLite not available, trying Firebase...');
        }

        // If SQLite failed or user not found, try Firebase
        if (user == null) {
          try {
            final email = _emailController.text.trim();
            final studentId = email.split('@')[0];
            final firebaseUser = await ApiService().getUser(studentId);

            if (firebaseUser != null &&
                firebaseUser['email'] == email) {
              // Build User object from Firebase data
              final User firebaseUserObj = User(
                fullName: firebaseUser['full_name'] ?? '',
                uniEmail: firebaseUser['uni_email'] ?? '',
                studentId: firebaseUser['student_id'] ?? studentId,
                gender: firebaseUser['gender'],
                academicLevel: firebaseUser['academic_level'] as int?,
                password: firebaseUser['password'] ?? '',
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successful (Firebase)')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                   builder: (_) => TaskManagementScreen(user: firebaseUserObj,),
                  ),
                );
              }
              return;
            }
          } catch (firebaseError) {
            print('Firebase error: $firebaseError');
          }
        }

        if (mounted) {
          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TaskManagementScreen(user: user)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Email or Password')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'University Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text('Don\'t have an account? Sign up here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  