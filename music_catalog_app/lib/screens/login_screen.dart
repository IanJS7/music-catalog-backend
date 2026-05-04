import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

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
    // Aquí obtenemos el usuario desde la API
    final user = await _apiService.login(_userController.text, _passController.text);

    if (user != null && mounted) {
      // CAMBIO AQUÍ: Pasamos el 'user' a la HomeScreen y quitamos el 'const'
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Error: Credenciales incorrectas"),
              backgroundColor: Colors.redAccent
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF311B92), Color(0xFF121212)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.headset_mic, size: 80, color: Colors.white),
            const Text("Music Catalog", style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  TextField(
                      controller: _userController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Usuario",
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      )
                  ),
                  TextField(
                      controller: _passController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Contraseña",
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      )
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text("INICIAR SESIÓN")
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen())
                    ),
                    child: const Text(
                        "¿No tienes cuenta? Regístrate aquí",
                        style: TextStyle(color: Colors.white)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}