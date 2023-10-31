import 'package:flutter/material.dart';

import 'qrCodeScanner.dart';

class AdminLoginPage extends StatefulWidget {
  final Function(int) onTabTapped;

  AdminLoginPage({required this.onTabTapped});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _emailController = TextEditingController(
      text: 'admin@example.com'); // Ganti dengan alamat email yang diinginkan
  final TextEditingController _passwordController =
      TextEditingController(text: '123');
  bool _isPasswordVisible = false;

  Future<void> _loginAdmin() async {
    // Validasi email dan password
    if (_emailController.text == 'admin@example.com' &&
        _passwordController.text == '123') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodeScannerScreen(
            imageTitle: '',
          ),
        ),
      );
    } else {
      print("Login gagal");
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan email Anda',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  hintText: 'Masukkan password Anda',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
            ),
            ElevatedButton(
              onPressed: _loginAdmin,
              child: Text('Login as Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
