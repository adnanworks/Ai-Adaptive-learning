// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class askdoubtPage extends StatefulWidget {
//   const askdoubtPage({super.key});
//
//   @override
//   State<askdoubtPage> createState() => _askdoubtPageState();
// }
//
// class _askdoubtPageState extends State<askdoubtPage> {
//   final TextEditingController doubtController = TextEditingController();
//
//   Future<void> submitFeedback() async {
//     if (doubtController.text.isEmpty) return;
//
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String urls = pref.getString('url') ?? "";
//     String? staff_id = pref.getString('staff_id');
//     String? sid = pref.getString('sid');
//
//
//     var response = await http.post(
//       Uri.parse('$urls/ask_doubt/'),
//       body: {
//         'staff_id': staff_id ?? '',
//         'sid': sid ?? '',
//         'doubt': doubtController.text,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final res = jsonDecode(response.body);
//       if (res['status'] == 'ok') {
//         doubtController.clear();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Doubt")),
//       body: Column(
//         children: [
//           TextField(
//             controller: doubtController,
//             decoration: const InputDecoration(
//               hintText: "Ask your Doubt...",
//             ),
//             maxLines: 3,
//           ),
//           ElevatedButton(
//             onPressed: submitFeedback,
//             child: const Text("Submit"),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';

class askdoubtPage extends StatefulWidget {
  const askdoubtPage({super.key});

  @override
  State<askdoubtPage> createState() => _askdoubtPageState();
}

class _askdoubtPageState extends State<askdoubtPage> {
  final TextEditingController doubtController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitted = false;
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    doubtController.addListener(() {
      setState(() {
        _characterCount = doubtController.text.length;
      });
    });
  }

  @override
  void dispose() {
    doubtController.dispose();
    super.dispose();
  }

  Future<void> submitFeedback() async {
    if (doubtController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter your doubt',
        backgroundColor: Colors.orangeAccent,
        textColor: Colors.black,
      );
      return;
    }

    if (_characterCount < 10) {
      Fluttertoast.showToast(
        msg: 'Please provide more details (at least 10 characters)',
        backgroundColor: Colors.orangeAccent,
        textColor: Colors.black,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String urls = pref.getString('url') ?? "";
      String? staff_id = pref.getString('staff_id');
      String? sid = pref.getString('sid');

      if (urls.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Server configuration error',
          backgroundColor: Colors.redAccent,
        );
        return;
      }

      if (staff_id == null || staff_id.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Please select a staff member first',
          backgroundColor: Colors.redAccent,
        );
        return;
      }

      var response = await http.post(
        Uri.parse('$urls/ask_doubt/'),
        body: {
          'staff_id': staff_id,
          'sid': sid ?? '',
          'doubt': doubtController.text,
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'] == 'ok') {
          setState(() {
            _isSubmitted = true;
            doubtController.clear();
            _characterCount = 0;
          });

          Fluttertoast.showToast(
            msg: 'Doubt submitted successfully!',
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black,
          );

          // Reset success state after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _isSubmitted = false;
              });
            }
          });
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to submit doubt',
            backgroundColor: Colors.redAccent,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Server error: ${response.statusCode}',
          backgroundColor: Colors.redAccent,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        backgroundColor: Colors.redAccent,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                children: [
                  const SizedBox(height: 60),

                  // Back Button
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

                  const SizedBox(height: 40),

                  // Header
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
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
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Iconsax.message_question,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Ask Your Doubt',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Get clarity from your teacher',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Success Message
                  if (_isSubmitted)
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.greenAccent.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.greenAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.tick_circle,
                            color: Colors.greenAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Your doubt has been submitted successfully!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Doubt Form Container
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doubt Label
                        const Text(
                          'Describe Your Doubt',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be specific about the topic or concept you need help with',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Doubt Input
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.07),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: doubtController,
                            maxLines: 6,
                            maxLength: 1000,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type your doubt here...\nExample: I need help understanding quantum physics chapter 3...',
                              hintStyle: TextStyle(
                                color: Colors.white30,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(20),
                              counterStyle: TextStyle(
                                color: _characterCount > 800
                                    ? Colors.orangeAccent
                                    : Colors.white70,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _characterCount = value.length;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Character Counter
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$_characterCount/1000',
                              style: TextStyle(
                                color: _characterCount > 800
                                    ? Colors.orangeAccent
                                    : Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Minimum Length Hint
                        if (_characterCount > 0 && _characterCount < 10)
                          Row(
                            children: [
                              const Icon(
                                Iconsax.info_circle,
                                color: Colors.orangeAccent,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'At least 10 characters required for better understanding',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 32),

                        // Tips Section
                        Container(
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
                                    Iconsax.lamp_charge,
                                    color: Colors.deepPurpleAccent,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Tips for better answers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildTipItem('Mention the specific chapter or topic'),

                              _buildTipItem('Describe where you\'re stuck'),
                              _buildTipItem('Ask specific questions'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : submitFeedback,
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
                                  'Submit Doubt',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Iconsax.send_2,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Response Time Note
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blueAccent.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.blueAccent.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.clock,
                                color: Colors.blueAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your teacher will respond within 24-48 hours',
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Iconsax.tick_circle,
            color: Colors.greenAccent.withOpacity(0.8),
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}