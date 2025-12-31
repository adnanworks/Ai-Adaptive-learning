// import 'dart:convert';
// import 'package:ai_app/student/view_complaints.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'home.dart';
//
// void main() {
//   runApp(const Send_complaint());
// }
//
// class Send_complaint extends StatelessWidget {
//   const Send_complaint({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Send Complaint',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const Send_complaintPage(title: 'Send Complaint'),
//     );
//   }
// }
//
// class Send_complaintPage extends StatefulWidget {
//   const Send_complaintPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<Send_complaintPage> createState() => Send_complaintPageState();
// }
//
// class Send_complaintPageState extends State<Send_complaintPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _nametextController = TextEditingController();
//   bool _isLoading = false;
//
//
//   Future<void> _sendData() async {
//     if (!_formKey.currentState!.validate()) {
//       Fluttertoast.showToast(msg: "Please fix errors in the form");
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       String name = _nametextController.text.trim();
//
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String? url = sh.getString('url');
//       String lid = sh.getString('lid') ?? '';
//       String sid = sh.getString('sid') ?? '';
//
//
//       if (url == null) {
//         Fluttertoast.showToast(msg: "Server URL not found.");
//         return;
//       }
//
//       final uri = Uri.parse('$url/send_complaint/');
//       var request = http.MultipartRequest('POST', uri);
//
//       request.fields['name'] = name;
//       request.fields['lid'] = lid;
//       request.fields['sid'] = sid;
//
//
//
//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();
//       var data = jsonDecode(respStr);
//
//       if (response.statusCode == 200) {
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: "Submitted successfully.");
//           _clearForm();
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const userHomePAge()),
//           );
//         } else {
//           Fluttertoast.showToast(
//               msg: "Submission failed: ${data['message'] ?? 'Unknown error'}");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error sending data: $e");
//       Fluttertoast.showToast(msg: "Error: ${e.toString()}");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _clearForm() {
//     _nametextController.clear();
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const userHomePAge()),
//         );
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: true,
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           foregroundColor: Colors.white,
//         ),
//         body: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _nametextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Send Complaint',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.comment),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter Complaint';
//                     }
//                     if (value.trim().length < 2) {
//                       return 'Field must be at least 2 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _sendData,
//                     child: _isLoading
//                         ? const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor:
//                             AlwaysStoppedAnimation<Color>(
//                                 Colors.white),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text("Submitting..."),
//                       ],
//                     )
//                         : const Text("Submit"),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => cstd_viewComplaintsPage(title: '')),
//                     );
//                   },
//                   child: const Text('View Send Complaints'),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size.fromHeight(50),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _nametextController.dispose();
//     super.dispose();
//   }
// }







import 'dart:convert';
import 'package:ai_app/student/view_complaints.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() {
  runApp(const Send_complaint());
}

class Send_complaint extends StatelessWidget {
  const Send_complaint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Complaint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const Send_complaintPage(title: 'Send Complaint'),
    );
  }
}

class Send_complaintPage extends StatefulWidget {
  const Send_complaintPage({super.key, required this.title});

  final String title;

  @override
  State<Send_complaintPage> createState() => Send_complaintPageState();
}

class Send_complaintPageState extends State<Send_complaintPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nametextController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fix errors in the form");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String name = _nametextController.text.trim();

      SharedPreferences sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');
      String lid = sh.getString('lid') ?? '';
      String sid = sh.getString('sid') ?? '';

      if (url == null) {
        Fluttertoast.showToast(msg: "Server URL not found.");
        return;
      }

      final uri = Uri.parse('$url/send_complaint/');
      var request = http.MultipartRequest('POST', uri);

      request.fields['name'] = name;
      request.fields['lid'] = lid;
      request.fields['sid'] = sid;

      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200) {
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Submitted successfully.");
          _clearForm();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const userHomePAge()),
          );
        } else {
          Fluttertoast.showToast(
              msg: "Submission failed: ${data['message'] ?? 'Unknown error'}");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending data: $e");
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _nametextController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const userHomePAge()),
        );
        return false;
      },
      child: Scaffold(
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

                    // Header
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 70,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurpleAccent.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.deepPurpleAccent.withOpacity(0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.report_problem_outlined,
                              color: Colors.deepPurpleAccent,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Report an Issue',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your feedback helps us improve',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Complaint Form
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Describe your complaint',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Please provide details about the issue',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Complaint Input
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white.withOpacity(0.07),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: TextFormField(
                                controller: _nametextController,
                                maxLines: 5,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Type your complaint here...',
                                  hintStyle: TextStyle(color: Colors.white38),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter complaint';
                                  }
                                  if (value.trim().length < 10) {
                                    return 'Please provide more details (min. 10 characters)';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Submit Button
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.deepPurpleAccent,
                                    Colors.purpleAccent,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _sendData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Submitting...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                                    : const Text(
                                  "Submit Complaint",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // View Complaints Button
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            cstd_viewComplaintsPage(title: '')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white70,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.history_outlined,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "View Previous Complaints",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Info Card
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.deepPurpleAccent.withOpacity(0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.deepPurpleAccent,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your complaint will be reviewed and addressed promptly.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Back Button
              Positioned(
                top: 40,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const userHomePAge()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nametextController.dispose();
    super.dispose();
  }
}