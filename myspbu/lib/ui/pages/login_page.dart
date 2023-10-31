import 'package:flutter/material.dart';
import 'package:myspbu/main.dart';
import 'package:myspbu/provider/login_provider.dart';
import 'package:myspbu/ui/pages/login_admin.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function(int) onTabTapped;

  LoginPage({required this.onTabTapped});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login(LoginProvider loginProvider) async {
    String result = await loginProvider.login(
        _emailController.text, _passwordController.text);

    if (result == "success") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } else {
      _showErrorSnackBar(result);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _navigateToAdminLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminLoginPage(
          onTabTapped: (int) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png', // Ganti dengan path gambar logo.png Anda
              width: 250, // Sesuaikan ukuran gambar
              height: 250,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Margin kanan dan kiri
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
                  horizontal: 16.0), // Margin kanan dan kiri
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
            const SizedBox(height: 20), // Spasi ke bawah 20 piksel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _login(
                      Provider.of<LoginProvider>(context, listen: false)),
                  child: const SizedBox(
                    width: 150, // Sesuaikan lebar sesuai kebutuhan Anda
                    child: Center(
                      child: Text('Login'),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Spasi horizontal antara tombol
                ElevatedButton(
                  onPressed: _navigateToAdminLogin,
                  child: const Row(
                    children: [
                      Icon(Icons.admin_panel_settings),
                      SizedBox(width: 5), // Spasi antara ikon dan teks
                      Text('Admin'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
