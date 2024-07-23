import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:touristapp/pages/Welcomepage/welcomepage.dart'; // Import your home or main content page

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to HomePage on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    } catch (e) {
      // Handle login error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      // Navigate to HomePage on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    } catch (e) {
      // Handle login error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: const Text('Continue'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _signInWithEmailAndPassword,
                icon: const Icon(Icons.email),
                label: const Text('Login with Email'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: Image.asset(
                  'images/icons8-google-48.png', // Path to your Google icon
                  height: 24.0, // Adjust the size if necessary
                ),
                label: const Text('Continue with Google'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
