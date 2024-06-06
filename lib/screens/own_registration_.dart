import 'package:first_project/screens/own_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_project/own_auth_service.dart';
import 'package:first_project/screens/auth_gate.dart';


class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  // Text editing controllers
  // final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Method to handle user registration
  void registerUser() {
    // Implement registration logic
    print('User registered with name: email: ${emailController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // You can add logo here or other icons
                const Icon(
                  Icons.person_add,
                  size: 100,
                ),

                const SizedBox(height: 50),
                Text(
                  'Register on Qawl!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // Name textfield
                // TextFormField(
                //   controller: nameController,
                //   decoration: const InputDecoration(
                //     labelText: 'Name',
                //     hintText: 'Enter your name',
                //   ),
                // ),

                const SizedBox(height: 10),

                // Email textfield
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                  ),
                ),

                const SizedBox(height: 10),

                // Password textfield
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Password',
                  ),
                ),

                const SizedBox(height: 25),

                // Register button
                   ElevatedButton(
              onPressed: () async {
                final message = await AuthService().registration(
                  email: emailController.text,
                  password: passwordController.text,
                );
                if (message!.contains('Success')) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const BeforeHomePage()));
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              },
              child: const Text('Create Account'),
            ),

                const SizedBox(height: 50),

                // Link to login page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a Qawl User?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                     InkWell(
                      onTap: () {
                        // Navigate to the registration page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login in',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),// InkWell(
                    //   Navigator.push (
                    //     context,
                    //     MaterialPageRoute(builder: (context) => LoginPage()),
                    //   ) {
                    //     // Navigate to login page
                    //   },
                    //   child: const Text(
                    //     'Login now',
                    //     style: TextStyle(
                    //       color: Colors.blue,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
