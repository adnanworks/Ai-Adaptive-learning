// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';
//
// import 'home.dart';
//
// void main() {
//   runApp(const ViewStudymtrl());
// }
//
// class ViewStudymtrl extends StatelessWidget {
//   const ViewStudymtrl({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ViewStudymtrlPage(title: 'View Notes'),
//     );
//   }
// }
//
// class ViewStudymtrlPage extends StatefulWidget {
//   const ViewStudymtrlPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ViewStudymtrlPage> createState() => _ViewStudymtrlPageState();
// }
//
// class _ViewStudymtrlPageState extends State<ViewStudymtrlPage> {
//   List<Map<String, dynamic>> users = [];
//
//   @override
//   void initState() {
//     super.initState();
//     viewUsers();
//   }
//
//
//   Future<void> viewUsers() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url') ?? '';
//       String subjectId = sh.getString('subject_id') ?? '';
//
//       String apiUrl = '$urls/student_viewstudymaterial/';
//       var response = await http.post(Uri.parse(apiUrl), body: {
//         'subject_id': subjectId,
//       });
//
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'id': item['id'].toString(),
//             'subject': item['subject'] ?? '',
//             'staff': item['staff'].toString(),
//             'materials': item['materials'], // <-- full URL from backend
//             'date': item['date'].toString(),
//           });
//         }
//         setState(() {
//           users = tempList;
//         });
//       }
//     } catch (e) {
//       print("Error fetching study material: $e");
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
//   Future<void> downloadFile(String url, String fileName) async {
//     bool allowed = await requestStoragePermission();
//
//     if (!allowed) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Permission denied")),
//       );
//       return;
//     }
//
//     Directory downloads;
//
//     if (Platform.isAndroid) {
//       downloads = Directory("/storage/emulated/0/Download");
//       if (!downloads.existsSync()) {
//         downloads.createSync(recursive: true); // create folder if not exists
//       }
//     } else {
//       downloads = await getApplicationDocumentsDirectory();
//     }
//
//     String savePath = "${downloads.path}/$fileName";
//
//     try {
//       await Dio().download(url, savePath);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Downloaded to: $savePath")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Download failed: $e")),
//       );
//     }
//   }
//
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
//         ),
//         body: users.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//           shrinkWrap: true,
//           physics: const BouncingScrollPhysics(),
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//             return Card(
//               margin: const EdgeInsets.all(10),
//               elevation: 5,
//               child: ListTile(
//                 title: Text(
//                   user['subject'],
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Staff: ${user['staff']}"),
//                     GestureDetector(
//                       onTap: () {
//                         downloadFile(
//                           user['materials'],
//                           "material_${user['id']}.pdf",
//                         );
//                       },
//                       child: const Text(
//                         "Download PDF",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                     Text("Date: ${user['date']}"),
//                   ],
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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:iconsax/iconsax.dart';

import 'home.dart';

void main() {
  runApp(const ViewStudymtrl());
}

class ViewStudymtrl extends StatelessWidget {
  const ViewStudymtrl({Key? key}) : super(key: key);

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
      home: const ViewStudymtrlPage(title: 'Study Materials'),
    );
  }
}

class ViewStudymtrlPage extends StatefulWidget {
  const ViewStudymtrlPage({super.key, required this.title});
  final String title;

  @override
  State<ViewStudymtrlPage> createState() => _ViewStudymtrlPageState();
}

class _ViewStudymtrlPageState extends State<ViewStudymtrlPage> {
  List<Map<String, dynamic>> users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    viewUsers();
  }

  Future<void> viewUsers() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String subjectId = sh.getString('subject_id') ?? '';

      if (urls.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String apiUrl = '$urls/student_viewstudymaterial/';
      var response = await http.post(Uri.parse(apiUrl), body: {
        'subject_id': subjectId,
      });

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'].toString(),
            'subject': item['subject'] ?? '',
            'staff': item['staff'].toString(),
            'materials': item['materials'],
            'date': item['date'].toString(),
          });
        }
        setState(() {
          users = tempList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching study material: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var sdk =
          (await SharedPreferences.getInstance()).getInt('android_sdk') ?? 33;

      if (sdk >= 33) {
        // Android 13+
        var perm = await Permission.manageExternalStorage.request();
        var mediaPerm = await Permission.photos.request();
        return perm.isGranted || mediaPerm.isGranted;
      } else {
        var perm = await Permission.storage.request();
        return perm.isGranted;
      }
    }
    return true;
  }

  Future<void> downloadFile(String url, String fileName) async {
    bool allowed = await requestStoragePermission();

    if (!allowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission denied"),
          backgroundColor: Colors.redAccent,
        ),
      );
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
        SnackBar(
          content: Text("Downloaded to: $savePath"),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Download failed: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.withOpacity(0.2),
                    Colors.blueAccent.withOpacity(0.2),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Container(
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
                          MaterialPageRoute(
                              builder: (context) => const userHomePAge()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Study Materials',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${users.length} materials available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Document Icon
                  Container(
                    width: 48,
                    height: 48,
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
                      Iconsax.document_text,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      ),
                    )
                  : users.isEmpty
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
                                  Iconsax.document,
                                  size: 50,
                                  color: Colors.white30,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No Materials Found',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Study materials will appear here',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: Colors.deepPurpleAccent,
                          backgroundColor: const Color(0xFF1A1A2E),
                          onRefresh: viewUsers,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return _buildMaterialCard(user, index);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> user, int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        top: index == 0 ? 0 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            _getCardColor(index).withOpacity(0.2),
            _getCardColor(index).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: _getCardColor(index).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCardColor(index).withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white.withOpacity(0.05),
            ),
            child: Row(
              children: [
                // Material Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _getCardColor(index),
                        _getCardColor(index).withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Iconsax.document_text,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['subject'],
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
                            Iconsax.teacher,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user['staff'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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

          // Material Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.calendar,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user['date'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Download Button
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
                      downloadFile(
                        user['materials'],
                        "material_${user['id']}.pdf",
                      );
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
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Download PDF",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // File Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.03),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.info_circle,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap to download study material PDF',
                          style: TextStyle(
                            fontSize: 12,
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
        ],
      ),
    );
  }

  Color _getCardColor(int index) {
    final colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
    ];
    return colors[index % colors.length];
  }
}
