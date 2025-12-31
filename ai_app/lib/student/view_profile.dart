// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const C_std_viewProfile());
// }
//
// class C_std_viewProfile extends StatelessWidget {
//   const C_std_viewProfile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'View Profile',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const view_profile_page(title: 'View Profile'),
//     );
//   }
// }
//
// class view_profile_page extends StatefulWidget {
//   const view_profile_page({super.key, required this.title});
//   final String title;
//
//   @override
//   State<view_profile_page> createState() => C_std_viewProfilePageState();
// }
//
// class C_std_viewProfilePageState extends State<view_profile_page> {
//   C_std_viewProfilePageState() {
//     _send_data();
//   }
//
//   String name_ = "";
//   String email_ = "";
//   String place_ = "";
//   String dob_ = "";
//   String semester_ = "";
//
//   String phone_ = "";
//   String photo_ = "";
//   String img_url_ = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         // appBar: AppBar(
//         //   leading: const BackButton(),
//         //   backgroundColor: Theme.of(context).colorScheme.primary,
//         //   title: Text(widget.title),
//         // ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//
//               if (photo_.isNotEmpty)
//                 Center(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(75),
//                     child: Image.network(
//                       _buildImageUrl(),
//                       width: 150,
//                       height: 150,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return const SizedBox(
//                           width: 150,
//                           height: 150,
//                           child: Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) =>
//                       const Icon(Icons.account_circle, size: 150),
//                     ),
//                   ),
//                 )
//               else
//                 const Center(
//                   child: Icon(Icons.account_circle, size: 150),
//                 ),
//
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Name: $name_'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Email: $email_'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Place: $place_'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text(' Date of Birth: $dob_'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Semester: $semester_'),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Phone: $phone_'),
//               ),
//
//               const SizedBox(height: 20),
//               Center(
//                 // child: ElevatedButton(
//                 //   onPressed: () {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => const cstd_profile_editPage(),
//                 //       ),
//                 //     );
//                 //   },
//                 //   child: const Text("Edit Profile"),
//                 // ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   String _buildImageUrl() {
//     if (img_url_.isEmpty || photo_.isEmpty) return '';
//     if (img_url_.endsWith('/')) {
//       return "${img_url_}media/$photo_";
//     } else {
//       return "$img_url_/media/$photo_";
//     }
//   }
//
//   void _send_data() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String img_url = sh.getString('img_url') ?? '';
//
//     setState(() {
//       img_url_ = img_url;
//     });
//
//     final urls = Uri.parse('$url/std_viewprofile/');
//     try {
//       final response = await http.post(urls, body: {
//         'lid': lid,
//       });
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           setState(() {
//             name_ = data['name'];
//             email_ = data['email'];
//             place_ = data['place'];
//             dob_ = data['dob'].toString();
//             semester_ = data['semester'];
//
//             phone_ = data['phone'];
//             photo_ = data['photo'];
//           });
//         } else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }
//
//



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';

void main() {
  runApp(const C_std_viewProfile());
}

class C_std_viewProfile extends StatelessWidget {
  const C_std_viewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
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
      home: const view_profile_page(title: 'Profile'),
    );
  }
}

class view_profile_page extends StatefulWidget {
  const view_profile_page({super.key, required this.title});
  final String title;

  @override
  State<view_profile_page> createState() => C_std_viewProfilePageState();
}

class C_std_viewProfilePageState extends State<view_profile_page> {
  C_std_viewProfilePageState() {
    _send_data();
  }

  String name_ = "";
  String email_ = "";
  String place_ = "";
  String dob_ = "";
  String semester_ = "";
  String phone_ = "";
  String photo_ = "";
  String img_url_ = "";
  bool _isLoading = true;

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
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurpleAccent,
          ),
        )
            : Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Profile Header Section
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurpleAccent.withOpacity(0.4),
                          Colors.blueAccent.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background Pattern
                        Positioned(
                          right: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),

                        // Profile Content
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Profile Image
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurpleAccent.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: photo_.isNotEmpty
                                      ? Image.network(
                                    _buildImageUrl(),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.deepPurpleAccent,
                                                Colors.blueAccent,
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Iconsax.profile_circle,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ),
                                  )
                                      : Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.deepPurpleAccent,
                                          Colors.blueAccent,
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Iconsax.profile_circle,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Name
                              Text(
                                name_.isNotEmpty ? name_ : 'Student Name',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Email
                              Text(
                                email_.isNotEmpty ? email_ : 'student@email.com',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Semester Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.deepPurpleAccent,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  semester_.isNotEmpty ? 'Semester $semester_' : 'Semester',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Profile Details Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Details Cards
                        _buildDetailCard(
                          icon: Iconsax.location,
                          title: 'Location',
                          value: place_.isNotEmpty ? place_ : 'Not specified',
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 16),

                        _buildDetailCard(
                          icon: Iconsax.calendar,
                          title: 'Date of Birth',
                          value: dob_.isNotEmpty ? dob_ : 'Not specified',
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(height: 16),

                        _buildDetailCard(
                          icon: Iconsax.call,
                          title: 'Phone Number',
                          value: phone_.isNotEmpty ? phone_ : 'Not specified',
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(height: 16),

                        _buildDetailCard(
                          icon: Iconsax.book,
                          title: 'Academic Level',
                          value: semester_.isNotEmpty ? 'Semester $semester_' : 'Not specified',
                          color: Colors.purpleAccent,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildImageUrl() {
    if (img_url_.isEmpty || photo_.isEmpty) return '';
    if (img_url_.endsWith('/')) {
      return "${img_url_}media/$photo_";
    } else {
      return "$img_url_/media/$photo_";
    }
  }

  void _send_data() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url') ?? '';

    setState(() {
      img_url_ = img_url;
    });

    final urls = Uri.parse('$url/std_viewprofile/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            name_ = data['name'];
            email_ = data['email'];
            place_ = data['place'];
            dob_ = data['dob'].toString();
            semester_ = data['semester'];
            phone_ = data['phone'];
            photo_ = data['photo'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Profile not found');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}