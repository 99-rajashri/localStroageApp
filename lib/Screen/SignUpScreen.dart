import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widget/button.dart';
import 'package:flutter_application_1/Widget/textFeild.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildImageSection(),
                _buildFormSection(),
                _buildTermsAndConditions(),
                _buildSignUpButton(),
                _buildSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      width: double.infinity,
      child: Image.asset("images/signIn.avif", fit: BoxFit.cover),
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 16),
          TextFeildInput(
            textEditingController: _nameController,
            hintText: "Enter Name",
            icon: Icons.person,
            validator: _validateName,
          ),
          SizedBox(height: 16),
          TextFeildInput(
            textEditingController: _emailController,
            hintText: "Enter Email",
            icon: Icons.email,
            validator: _validateEmail,
          ),
          SizedBox(height: 16),
          TextFeildInput(
            textEditingController: _passwordController,
            hintText: "Enter Password",
            icon: Icons.lock,
            isPass: true,
            validator: _validatePassword,
          ),
          SizedBox(height: 16),
          TextFeildInput(
            textEditingController: _confirmPasswordController,
            hintText: "Confirm Password",
            icon: Icons.lock,
            isPass: true,
            validator: _validateConfirmPassword,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (value) {
            setState(() {
              _termsAccepted = value ?? false;
            });
          },
        ),
        const Expanded(
          child: Text('I accept the Terms and Conditions'),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: MyButton(
        onTab: _signUp,
        text: 'Sign Up',
      ),
    );
  }

  Widget _buildSignInButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Already have an account? Sign In'),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must accept the terms and conditions')),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('userEmail', _emailController.text);
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
}
