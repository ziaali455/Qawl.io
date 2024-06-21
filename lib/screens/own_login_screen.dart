import 'package:first_project/screens/homepage.dart';
import 'package:first_project/screens/own_forgot_password.dart';
import 'package:first_project/screens/own_registration_.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/own_auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  // User is signed in
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  });
                } else {
                  // User is not signed in or has signed out
                  return buildSignInForm(context);
                }
              }

              // Display a loading spinner when checking authentication state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return buildSignInForm(context);
            },
          ),
        ),
      ),
    );
  }

  Widget buildSignInForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        const Icon(Icons.lock, size: 100),
        const SizedBox(height: 50),
        Text(
          'Welcome to Qawl!',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 25),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Email',
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Password',
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  child: Text(
                    'Forgot Password?',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  }
                  // Text(
                  //   'Forgot Password?',
                  //   style: TextStyle(color: Colors.grey[600]),
                  // ),
                  )
            ],
          ),
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () async {
            final message = await AuthService().login(
              email: emailController.text,
              password: passwordController.text,
            );
            if (message!.contains('Success')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Incorrect email or password provided'),
                ),
              );
            }
          },
          child: const Text('Login'),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'New User?',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: const Text(
                'Register now',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
