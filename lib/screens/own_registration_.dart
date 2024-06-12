// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/auth_gate.dart';
import 'package:first_project/screens/own_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

   void registerUser(BuildContext context) async {
  if (passwordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Passwords do not match")),
    );
    return; // Exit if passwords do not match
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    await QawlUser.createQawlUser(userCredential.user); // Ensure this is awaited if asynchronous

    debugPrint("User created with UID: ${userCredential.user?.uid}");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => UserSetupPage()),
    );
  } catch (error) {
    debugPrint("Registration failed: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registration failed: $error")),
    );
  }
}



//   void registerUser(BuildContext context) async {
//   if (passwordController.text == confirmPasswordController.text) {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );

//       await QawlUser.createQawlUser(userCredential.user!); // Ensure this is awaited if asynchronous
//       debugPrint("User created with UID: ${userCredential.user!.uid}");

//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const BeforeHomePage()),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Registration failed: $error")),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Passwords do not match")),
//     );
//   }
// }


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
                const Icon(Icons.person_add, size: 100),
                const SizedBox(height: 50),
                Text(
                  'Register on Qawl!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email', hintText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', hintText: 'Password'),
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm Password', hintText: 'Confirm Password'),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => registerUser(context),
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 50),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
