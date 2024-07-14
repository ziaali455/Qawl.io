import 'package:first_project/screens/homepage.dart';
import 'package:first_project/screens/own_forgot_password.dart';
import 'package:first_project/screens/own_registration_.dart';
import 'package:first_project/size_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/own_auth_service.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                return const CircularProgressIndicator(color: Colors.green);
              }

              return buildSignInForm(context);
            },
          ),
        ),
      ),
    );
  }

  Widget buildSignInForm(BuildContext context) {
    String logoImagePath = 'images/qawl-lime.png';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          WidgetAnimator(
            incomingEffect: WidgetTransitionEffects.incomingSlideInFromTop(),
            child: SizedBox(
              width: 200.0, // specify the desired width
              height: 200.0, // specify the desired height
              child: Image.asset(logoImagePath),
            ),
          ),
          const SizedBox(height: 25),
           Text(
            'Welcome to Qawl!',
            style: TextStyle(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Email',
              floatingLabelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(), // default border
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green, // set the color to green
                  width: 2.0, // set the width of the border
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Password',
                floatingLabelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(), // default border
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green, // set the color to green
                    width: 2.0, // set the width of the border
                  ),
                ),
              )),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  )
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
            style: const ButtonStyle(
              
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
            ),
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
                  const SnackBar(
                    content: Text('Incorrect email or password provided'),
                  ),
                );
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'New User?',
                style: TextStyle(color: Colors.white),
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
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
