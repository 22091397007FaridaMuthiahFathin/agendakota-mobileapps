import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> loginUser () async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Email dan password tidak boleh kosong.";
      });
      return;
    }

    try {
      await AuthService.login(email, password);
      final role = await AuthService.getRole(); // Ambil role setelah login
      navigateToDashboard(role); // Navigasi berdasarkan role
    } catch (error) {
      setState(() {
        errorMessage = "Login gagal: ${error.toString()}";
      });
    }
  }

  void navigateToDashboard(String? role) {
    if (role == "Admin") {
      Navigator.pushReplacementNamed(context, '/adminDashboard');
    } else if (role == "Penulis") {
      Navigator.pushReplacementNamed(context, '/penulisDashboard');
    } else {
      setState(() {
        errorMessage = "Role tidak dikenali.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
            ),
            if (errorMessage != null) ...[
              SizedBox(height: 8),
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
