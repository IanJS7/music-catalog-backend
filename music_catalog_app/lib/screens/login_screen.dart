import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _apiService = ApiService();

  void _handleLogin() async {
    final user = await _apiService.login(_userController.text, _passController.text);
    if (user != null && mounted) {
      Navigator.pushReplacement( // Usamos pushReplacement para que no pueda volver atrás al login
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(

        )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Credenciales incorrectas"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF311B92), Color(0xFF121212)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.headset_mic, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text("Music Catalog", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(labelText: "Usuario", prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña", prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                  onPressed: _handleLogin,
                  child: const Text("INICIAR SESIÓN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}