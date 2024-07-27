import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widget/button.dart';
import 'package:flutter_application_1/Widget/textFeild.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int _signInAttempts = 0;
  final int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    _loadSignInAttempts();
  }

  void _loadSignInAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _signInAttempts = prefs.getInt('signInAttempts') ?? 0;
    });
  }

  void _incrementSignInAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    _signInAttempts++;
    await prefs.setInt('signInAttempts', _signInAttempts);
  }

  void _resetSignInAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    _signInAttempts = 0;
    await prefs.setInt('signInAttempts', _signInAttempts);
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

  void _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_signInAttempts >= _maxAttempts) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'You have exceeded the maximum number of sign-in attempts. Please sign up.'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/signup');
        return;
      }

      bool isAuthenticated =
          _authenticateUser(_emailController.text, _passwordController.text);

      if (isAuthenticated) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        _resetSignInAttempts();
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        _incrementSignInAttempts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect email or password.')),
        );
      }
    }
  }

  bool _authenticateUser(String email, String password) {
    // Replace with your authentication logic
    return email == "test@example.com" && password == "password";
  }

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
                _buildSignInButton(),
                _buildForgotPasswordButton(),
                _buildSocialLoginButtons(),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      width: double.infinity,
      child: Image.asset(
        "images/signup.avif",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: MyButton(
        onTab: _signIn,
        text: 'Sign In',
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/forgotPassword');
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialIconButton(
          onPressed: () {
            // Implement Facebook login logic
          },
          icon: FontAwesomeIcons.facebook,
          color: Color(0xFF3b5998),
        ),
        _socialIconButton(
          onPressed: () {
            // Implement Google login logic
          },
          icon: FontAwesomeIcons.google,
          color: Color(0xFFdb4437),
        ),
        _socialIconButton(
          onPressed: () {
            // Implement Instagram login logic
          },
          icon: FontAwesomeIcons.instagram,
          color: Color(0xFFe4405f),
        ),
      ],
    );
  }

  Widget _socialIconButton({
    required void Function()? onPressed,
    required IconData icon,
    required Color color,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: FaIcon(icon, color: color, size: 30),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signup');
      },
      child: RichText(
        text: const TextSpan(
          text: 'Don\'t have an account? ',
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: 'Create an Account',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
