// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../login_page.dart';
//
//
//
// void main() {
//   runApp(const std_changepwd());
// }
//
// class std_changepwd extends StatelessWidget {
//   const std_changepwd({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ChangePassword',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const std_changepwdPage(title: 'ChangePassword'),
//     );
//   }
// }
//
// class std_changepwdPage extends StatefulWidget {
//   const std_changepwdPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<std_changepwdPage> createState() => cstd_changepwdPageState();
// }
//
// class cstd_changepwdPageState extends State<std_changepwdPage> {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController oldpasswordController = new TextEditingController();
//     TextEditingController newpasswordController = new TextEditingController();
//     TextEditingController confirmpasswordController =new TextEditingController();
//
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: oldpasswordController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("Old Password"),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: newpasswordController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("New Password"),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: confirmpasswordController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("Confirm Password"),
//                   ),
//                 ),
//               ),
//
//               ElevatedButton(
//                 onPressed: () async {
//                   String oldp = oldpasswordController.text.toString();
//                   String newp = newpasswordController.text.toString();
//                   String cnfrmp = confirmpasswordController.text.toString();
//
//                   SharedPreferences sh = await SharedPreferences.getInstance();
//                   String url = sh.getString('url').toString();
//                   String lid = sh.getString('lid').toString();
//                   print(lid);
//
//                   final urls = Uri.parse('$url/std_changepassword/');
//                   try {
//                     final response = await http.post(
//                       urls,
//                       body: {
//                         'oldpassword': oldp,
//                         'newpassword': newp,
//                         'confirmpassword': cnfrmp,
//                         'lid': lid,
//                       },
//                     );
//                     if (response.statusCode == 200) {
//                       String status = jsonDecode(response.body)['status'];
//                       if (status == 'ok') {
//                         Fluttertoast.showToast(
//                           msg: 'Password Changed Successfully',
//                         );
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MyLoginPage(title: 'Login'),
//                           ),
//                         );
//                       } else {
//                         Fluttertoast.showToast(msg: 'Incorrect Password');
//                       }
//                     } else {
//                       Fluttertoast.showToast(msg: 'Network Error');
//                     }
//                   } catch (e) {
//                     Fluttertoast.showToast(msg: e.toString());
//                   }
//                 },
//                 child: Text("ChangePassword"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';
import '../login_page.dart';

void main() {
  runApp(const std_changepwd());
}

class std_changepwd extends StatelessWidget {
  const std_changepwd({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change Password',
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
      home: const std_changepwdPage(title: 'Change Password'),
    );
  }
}

class std_changepwdPage extends StatefulWidget {
  const std_changepwdPage({super.key, required this.title});

  final String title;

  @override
  State<std_changepwdPage> createState() => cstd_changepwdPageState();
}

class cstd_changepwdPageState extends State<std_changepwdPage> {
  final TextEditingController oldpasswordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();
  bool _isLoading = false;
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  // Validation regex for new password only
  final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
  );

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newpasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

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
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 60),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Header
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurpleAccent,
                                Colors.blueAccent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurpleAccent.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Iconsax.lock_1,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Update your account password',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Password Requirements Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Iconsax.info_circle,
                              color: Colors.deepPurpleAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Password Requirements',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildRequirementItem('At least 8 characters', true),
                        _buildRequirementItem('One uppercase letter', true),
                        _buildRequirementItem('One special character', true),
                      ],
                    ),
                  ),

                  // Password Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Old Password Field
                        _buildPasswordField(
                          controller: oldpasswordController,
                          label: 'Old Password',
                          hintText: 'Enter your current password',
                          icon: Iconsax.lock_1,
                          isVisible: _oldPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _oldPasswordVisible = !_oldPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Old password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // New Password Field
                        _buildPasswordField(
                          controller: newpasswordController,
                          label: 'New Password',
                          hintText: 'Enter your new password',
                          icon: Iconsax.lock_1,
                          isVisible: _newPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _newPasswordVisible = !_newPasswordVisible;
                            });
                          },
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 20),

                        // Confirm Password Field
                        _buildPasswordField(
                          controller: confirmpasswordController,
                          label: 'Confirm Password',
                          hintText: 'Confirm your new password',
                          icon: Iconsax.lock_1,
                          isVisible: _confirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                          validator: _validateConfirmPassword,
                        ),
                        const SizedBox(height: 32),

                        // Change Password Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                                : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Update Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Iconsax.lock_1,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Iconsax.tick_circle,
            color: isRequired ? Colors.greenAccent : Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.07),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white30,
                fontSize: 16,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.deepPurpleAccent,
                size: 22,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Iconsax.eye : Iconsax.eye_slash,
                  color: Colors.deepPurpleAccent,
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Future<void> _changePassword() async {
    // 🔹 FIXED: Old password only check empty
    if (oldpasswordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Old password is required');
      return;
    }

    final newPasswordError = _validatePassword(newpasswordController.text);
    if (newPasswordError != null) {
      Fluttertoast.showToast(msg: newPasswordError);
      return;
    }

    // 🔹 Confirm password
    final confirmPasswordError = _validateConfirmPassword(confirmpasswordController.text);
    if (confirmPasswordError != null) {
      Fluttertoast.showToast(msg: confirmPasswordError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String oldp = oldpasswordController.text;
      String newp = newpasswordController.text;
      String cnfrmp = confirmpasswordController.text;

      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();

      final urls = Uri.parse('$url/std_changepassword/');
      final response = await http.post(
        urls,
        body: {
          'oldpassword': oldp,
          'newpassword': newp,
          'confirmpassword': cnfrmp,
          'lid': lid,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: 'Password Changed Successfully',
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyLoginPage(title: 'Login'),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'Incorrect old password');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

