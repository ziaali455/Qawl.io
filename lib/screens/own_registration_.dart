// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/auth_gate.dart';
import 'package:first_project/screens/homepage.dart';
import 'package:first_project/screens/own_login_screen.dart';
import 'package:first_project/screens/user_setup_page_content.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

// class RegistrationPage extends StatelessWidget {
//   RegistrationPage({super.key});

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();


//   void registerUser(BuildContext context) async {
//     if (passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Passwords do not match")),
//       );
//       return; // Exit if passwords do not match
//     }

//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );
//       await QawlUser.createQawlUser(
//           userCredential.user); // Ensure this is awaited if asynchronous

//       // Navigate based on user details
//       checkUserDetailsAndNavigate(userCredential.user, context);
//     } catch (error) {
//       debugPrint("Registration failed: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Registration failed: $error")),
//       );
//     }
//   }

//   void checkUserDetailsAndNavigate(User? user, BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => FutureBuilder<QawlUser?>(
//           future: QawlUser.getCurrentQawlUser(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                   child: CircularProgressIndicator(color: Colors.green));
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               final gender = snapshot.data?.gender;
//               final country = snapshot.data?.country;
//               if (gender == null ||
//                   gender == "" ||
//                   gender.isEmpty ||
//                   country == null ||
//                   country.isEmpty) {
                
//                 // print("here going to beforehomepage");
//                 return UserSetupPage();
//               } else {
//                 // print("HERE GOING HOME PAGE");
//                 return const HomePage();
//               }
//             }
//           },
//         ),
//       ),
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     String logoImagePath = 'images/qawl-lime.png';

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 50),
//                   SizedBox(
//                     width: 200.0, // specify the desired width
//                     height: 200.0, // specify the desired height
//                     child: Image.asset(logoImagePath),
//                   ),
//                   const SizedBox(height: 25),
//                   const Text(
//                     'Register on Qawl',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 25),
//                   TextFormField(
//                     controller: emailController,
//                     decoration: const InputDecoration(
//                       labelText: 'Email', hintText: 'Email',
//                       floatingLabelStyle: TextStyle(color: Colors.green),
//                       border: OutlineInputBorder(), // default border
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.green, // set the color to green
//                           width: 2.0, // set the width of the border
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Password', hintText: 'Password',
//                       floatingLabelStyle: TextStyle(color: Colors.green),
//                       border: OutlineInputBorder(), // default border
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.green, // set the color to green
//                           width: 2.0, // set the width of the border
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: confirmPasswordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Confirm Password',
//                       hintText: 'Confirm Password',
//                       floatingLabelStyle: TextStyle(color: Colors.green),
//                       border: OutlineInputBorder(), // default border
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.green, // set the color to green
//                           width: 2.0, // set the width of the border
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   ElevatedButton(
//                     style: const ButtonStyle(
//                       backgroundColor:
//                           WidgetStatePropertyAll<Color>(Colors.green),
//                     ),
//                     onPressed: () => registerUser(context),
//                     child: const Text(
//                       'Create Account',
//                       style:
//                           TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Already a Qawl User?',
//                         style: TextStyle(
//                           color: Colors.green,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginPage()),
//                           );
//                         },
//                         child: const Text(
//                           'Log in',
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


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


//    void registerUser(BuildContext context) async {
//   if (passwordController.text != confirmPasswordController.text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Passwords do not match")),
//     );
//     return; // Exit if passwords do not match
//   }

//   try {
//     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: emailController.text,
//       password: passwordController.text,
//     );
//     await QawlUser.createQawlUser(userCredential.user); // Ensure this is awaited if asynchronous

//     debugPrint("User created with UID: ${userCredential.user?.uid}");
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => UserSetupPage()),
//     );
//   } catch (error) {
//     debugPrint("Registration failed: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Registration failed: $error")),
//     );
//   }
// }

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  void _toggleLoading(bool isLoading) {
    _isLoading.value = isLoading;
  }

  Future<void> registerUser(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return; // Exit if passwords do not match
    }

    _toggleLoading(true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await QawlUser.createQawlUser(userCredential.user); // Ensure this is awaited if asynchronous

      // Navigate based on user details
      await checkUserDetailsAndNavigate(userCredential.user, context);
    } catch (error) {
      debugPrint("Registration failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $error")),
      );
    }

    _toggleLoading(false);
  }

  Future<void> checkUserDetailsAndNavigate(User? user, BuildContext context) async {
    final currentUser = await QawlUser.getCurrentQawlUser();

    if (currentUser == null) {
      // Handle error or navigate to error page
      return;
    }

    if (currentUser.gender == null ||
        currentUser.gender == "" ||
        currentUser.gender.isEmpty ||
        currentUser.country == null ||
        currentUser.country.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserSetupPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String logoImagePath = 'images/qawl-lime.png';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: Image.asset(logoImagePath),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Register on Qawl',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Email',
                          floatingLabelStyle: TextStyle(color: Colors.green),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2.0,
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
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm Password',
                          floatingLabelStyle: TextStyle(color: Colors.green),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      isLoading
                          ? CircularProgressIndicator(color: Colors.green)
                          : ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                              ),
                              onPressed: () => registerUser(context),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already a Qawl User?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
