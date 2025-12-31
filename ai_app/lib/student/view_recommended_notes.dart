



// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_file/open_file.dart'; // To open files
//
// import 'home.dart'; // Your home page
//
// void main() {
//   runApp(const RecommendedNotesApp());
// }
//
// class RecommendedNotesApp extends StatelessWidget {
//   const RecommendedNotesApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: RecommendedNotesPage(),
//     );
//   }
// }
//
// class RecommendedNotesPage extends StatefulWidget {
//   const RecommendedNotesPage({super.key});
//
//   @override
//   State<RecommendedNotesPage> createState() => _RecommendedNotesPageState();
// }
//
// class _RecommendedNotesPageState extends State<RecommendedNotesPage> {
//   List<Map<String, dynamic>> notes = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRecommendedNotes();
//   }
//
//
//   Future<void> fetchRecommendedNotes() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//     String studentId = sh.getString('sid') ?? '';
//
//     final apiUrl = Uri.parse('$url/recommended_notes/');
//
//     try {
//       final response = await http.post(apiUrl, body: {
//         'student_id': studentId,
//       });
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           setState(() {
//             notes = List<Map<String, dynamic>>.from(data['data']);
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("No recommended notes found")));
//         }
//       }
//     } catch (e) {
//       print("Error fetching recommended notes: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: $e")));
//     }
//   }
//
//
//   Future<bool> requestStoragePermission() async {
//     if (Platform.isAndroid) {
//       var sdk = (await SharedPreferences.getInstance()).getInt('android_sdk') ?? 33;
//
//       if (sdk >= 33) {
//         // Android 13+
//         var perm = await Permission.manageExternalStorage.request();
//         var mediaPerm = await Permission.photos.request();
//         return perm.isGranted || mediaPerm.isGranted;
//       } else {
//         // Android 12 and below
//         var perm = await Permission.storage.request();
//         return perm.isGranted;
//       }
//     }
//     return true;
//   }
//
//
//   Future<void> downloadAndOpenFile(String url, String fileName) async {
//     bool allowed = await requestStoragePermission();
//     if (!allowed) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Storage permission denied")));
//       return;
//     }
//
//     Directory downloads;
//
//     if (Platform.isAndroid) {
//       downloads = Directory("/storage/emulated/0/Download");
//       if (!downloads.existsSync()) {
//         downloads.createSync(recursive: true);
//       }
//     } else {
//       downloads = await getApplicationDocumentsDirectory();
//     }
//
//     String savePath = "${downloads.path}/$fileName";
//
//     try {
//       await Dio().download(url, savePath);
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Downloaded to: $savePath")));
//
//
//       OpenFile.open(savePath);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Download failed: $e")));
//     }
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
//           title: const Text("Recommended Notes"),
//           centerTitle: true,
//         ),
//         body: notes.isEmpty
//             ? const Center(child: Text("No recommended notes"))
//             : ListView.builder(
//           shrinkWrap: true,
//           physics: const BouncingScrollPhysics(),
//           itemCount: notes.length,
//           itemBuilder: (context, index) {
//             final note = notes[index];
//             return Card(
//               margin: const EdgeInsets.all(10),
//               elevation: 5,
//               child: ListTile(
//                 title: Text(note['title']),
//                 subtitle: Text("Date: ${note['date']}"),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.download),
//                   onPressed: () {
//                     downloadAndOpenFile(
//                         note['file'], "note_${note['id']}.pdf");
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }




import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart'; // To open files
import 'package:iconsax/iconsax.dart';

import 'home.dart'; // Your home page

void main() {
  runApp(const RecommendedNotesApp());
}

class RecommendedNotesApp extends StatelessWidget {
  const RecommendedNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: const RecommendedNotesPage(),
    );
  }
}

class RecommendedNotesPage extends StatefulWidget {
  const RecommendedNotesPage({super.key});

  @override
  State<RecommendedNotesPage> createState() => _RecommendedNotesPageState();
}

class _RecommendedNotesPageState extends State<RecommendedNotesPage> {
  List<Map<String, dynamic>> notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendedNotes();
  }

  Future<void> fetchRecommendedNotes() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    String studentId = sh.getString('sid') ?? '';

    final apiUrl = Uri.parse('$url/recommended_notes/');

    try {
      final response = await http.post(apiUrl, body: {
        'student_id': studentId,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            notes = List<Map<String, dynamic>>.from(data['data']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No recommended notes found")));
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching recommended notes: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")));
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var sdk = (await SharedPreferences.getInstance()).getInt('android_sdk') ?? 33;

      if (sdk >= 33) {
        // Android 13+
        var perm = await Permission.manageExternalStorage.request();
        var mediaPerm = await Permission.photos.request();
        return perm.isGranted || mediaPerm.isGranted;
      } else {
        // Android 12 and below
        var perm = await Permission.storage.request();
        return perm.isGranted;
      }
    }
    return true;
  }

  Future<void> downloadAndOpenFile(String url, String fileName) async {
    bool allowed = await requestStoragePermission();
    if (!allowed) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")));
      return;
    }

    Directory downloads;

    if (Platform.isAndroid) {
      downloads = Directory("/storage/emulated/0/Download");
      if (!downloads.existsSync()) {
        downloads.createSync(recursive: true);
      }
    } else {
      downloads = await getApplicationDocumentsDirectory();
    }

    String savePath = "${downloads.path}/$fileName";

    try {
      await Dio().download(url, savePath);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Downloaded to: $savePath")));

      OpenFile.open(savePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Download failed: $e")));
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const userHomePAge()),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),


                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
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
                            Iconsax.note_2,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Recommended Notes',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Ai Recommended Study materials for you',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurpleAccent,
                    ),
                  )
                      : notes.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: const Icon(
                            Iconsax.note_remove,
                            size: 50,
                            color: Colors.white30,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No Notes Available',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back later for recommended notes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Column(
                    children: [
                      ...notes.map((note) => _buildNoteCard(note)),
                    ],
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

  Widget _buildNoteCard(Map<String, dynamic> note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Note Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.deepPurpleAccent.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurpleAccent.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Iconsax.note_text,
                    color: Colors.deepPurpleAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.calendar,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            note['date'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Download Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Download this study material',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.deepPurpleAccent,
                        Colors.blueAccent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      downloadAndOpenFile(
                          note['file'], "note_${note['id']}.pdf");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.document_download,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Download Note",
                          style: TextStyle(
                            fontSize: 16,
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
        ],
      ),
    );
  }
}