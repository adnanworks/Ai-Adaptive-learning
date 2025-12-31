// import 'dart:convert';
// import 'package:ai_app/student/home.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp( mylogin());
// }
//
// class mylogin extends StatelessWidget {
//   const mylogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyLoginPage(title: 'IP Page'),
//     );
//   }
// }
// class MyLoginPage extends StatefulWidget {
//   const MyLoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyLoginPage> createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> {
//   final TextEditingController _usernametextController = TextEditingController();
//   final TextEditingController _passwordtextController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFF3FF),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 100),
//               const Text(
//                 "Login Page",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF0047AB),
//                 ),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _usernametextController,
//                 decoration: const InputDecoration(
//                   labelText: "Email ID",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordtextController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _sendData,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: const Text("Login", style: TextStyle(fontSize: 16)),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     const Text(
//               //       "Register for Current Student: ",
//               //       style: TextStyle(color: Colors.black87),
//               //     ),
//               //     GestureDetector(
//               //       onTap: () {
//               //         Navigator.push(
//               //           context,
//               //           MaterialPageRoute(builder: (context) => const reg_CurrentStd()),
//               //         );
//               //       },
//               //       child: const Text(
//               //         "Register",
//               //         style: TextStyle(
//               //           fontWeight: FontWeight.bold,
//               //           color: Colors.orange,
//               //         ),
//               //       ),
//               //
//               //
//               //     ),
//               //   ],
//               //
//               // ),
//               const SizedBox(height: 20),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // const Text(
//                   //   "Forgot Password: ",
//                   //   style: TextStyle(color: Colors.black87),
//                   // ),
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(builder: (context) => const forgtPasswordPage(title: '')),
//                   //     );
//                   //   },
//                   //   child: const Text(
//                   //     "Click Here",
//                   //     style: TextStyle(
//                   //       fontWeight: FontWeight.bold,
//                   //       color: Colors.orange,
//                   //     ),
//                   //   ),
//                   //
//                   //
//                   // ),
//                 ],
//
//               ),
//
//
//             ],
//               ),
//
//           ),
//         ),
//
//     );
//   }
//
//   Future<void> _sendData() async {
//     String uname = _usernametextController.text.trim();
//     String password = _passwordtextController.text.trim();
//
//     if (uname.isEmpty || password.isEmpty) {
//       Fluttertoast.showToast(msg: 'Please enter both email and password');
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//
//     if (url == null || url.isEmpty) {
//       Fluttertoast.showToast(msg: 'Server URL not configured');
//       return;
//     }
//
//     final urls = Uri.parse('$url/student_login/');
//     try {
//       final response = await http.post(
//         urls,
//         body: {'Username': uname, 'Password': password},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String status = data['status'].toString();
//         String message = data['message'].toString();
//         String type = data['type'].toString();
//
//         Fluttertoast.showToast(msg: message);
//
//         if (status == 'ok') {
//           String lid = data['lid'].toString();
//           await sh.setString("lid", lid);
//
//           String sid = data['sid'].toString();
//           await sh.setString("sid", sid);
//
//           // String oid = data['oid'].toString();
//           // await sh.setString("oid", oid);
//
//           if(type == "student"){
//            Navigator.push(context, MaterialPageRoute(builder: (context) => userHomePAge(),));
//           }
//           // else if (type == "old student"){
//           //   Navigator.push(context, MaterialPageRoute(builder: (context) => oldstd_homePage(),));
//           //
//           // }
//
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
// }





import 'dart:convert';
import 'package:ai_app/student/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

void main() {
  runApp(const mylogin());
}

class mylogin extends StatelessWidget {
  const mylogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI App Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.dark,
      home: const MyLoginPage(title: 'Login'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _usernametextController = TextEditingController();
  final TextEditingController _passwordtextController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0B21),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  width: 180,
                  height: 180,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Lottie.asset(
                    'assets/Artificial Intelligence.json',
                    fit: BoxFit.contain,

                  ),
                ),

                // Title
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Sign in to continue to your account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 48),

                // Glassmorphism Login Container
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      children: [
                        // Email Field
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white.withOpacity(0.07),
                          ),
                          child: TextField(
                            controller: _usernametextController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email ID',
                              labelStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              hintText: 'Enter your email address',
                              hintStyle: TextStyle(
                                color: Colors.white30,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: Colors.deepPurpleAccent,
                                size: 24,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password Field
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white.withOpacity(0.07),
                          ),
                          child: TextField(
                            controller: _passwordtextController,
                            obscureText: _obscurePassword,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                color: Colors.white30,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: Colors.deepPurpleAccent,
                                size: 24,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: Colors.deepPurpleAccent,
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Register Section

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Additional Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security_rounded,
                        color: Colors.deepPurpleAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your credentials are securely encrypted',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendData() async {
    String uname = _usernametextController.text.trim();
    String password = _passwordtextController.text.trim();

    if (uname.isEmpty || password.isEmpty) {
      _showToast('Please enter both email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');

      if (url == null || url.isEmpty) {
        _showToast('Server URL not configured');
        return;
      }

      final urls = Uri.parse('$url/student_login/');
      final response = await http.post(
        urls,
        body: {'Username': uname, 'Password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String status = data['status'].toString();
        String message = data['message'].toString();
        String type = data['type'].toString();

        _showToast(message);

        if (status == 'ok') {
          String lid = data['lid'].toString();
          await sh.setString("lid", lid);

          String sid = data['sid'].toString();
          await sh.setString("sid", sid);

          // Simulate loading for better UX
          await Future.delayed(const Duration(milliseconds: 500));

          if (type == "student" && mounted) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const userHomePAge(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          }
        }
      } else {
        _showToast('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showToast('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.deepPurpleAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}