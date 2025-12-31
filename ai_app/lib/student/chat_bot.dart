//
//
//
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class ChatBotPage extends StatefulWidget {
//   const ChatBotPage({super.key});
//
//   @override
//   State<ChatBotPage> createState() => _ChatBotPageState();
// }
//
// class _ChatBotPageState extends State<ChatBotPage> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController(); // Scroll controller added
//
//   List<ChatMessage> chatMessages = [];
//
//   //----------------------------------------------
//   // SEND MESSAGE TO BACKEND
//   //----------------------------------------------
//   Future<void> sendMessage() async {
//     if (_controller.text.trim().isEmpty) return;
//
//     String msg = _controller.text.trim();
//
//     setState(() {
//       chatMessages.add(ChatMessage(message: msg, isBot: false));
//     });
//
//     _scrollToBottom(); // scroll after user message
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//
//     try {
//       var response = await http.post(
//         Uri.parse("$url/chatbot_recommend_notes/"),
//         body: {"message": msg},
//       );
//
//       var data = jsonDecode(response.body);
//
//       if (data['status'] == 'ok') {
//         List<RecommendedNote> temp = [];
//         for (var n in data['data']) {
//           temp.add(RecommendedNote.fromJson(n));
//         }
//
//         setState(() {
//           chatMessages.add(ChatMessage(
//               message: temp.isNotEmpty
//                   ? "Here are some recommended notes 👇"
//                   : "I couldn’t find any similar notes.",
//               isBot: true,
//               notes: temp.isNotEmpty ? temp : null));
//         });
//       } else if (data['status'] == 'nomatch') {
//         setState(() {
//           chatMessages.add(ChatMessage(
//               message: "${data['message']}", isBot: true));
//         });
//       } else {
//         setState(() {
//           chatMessages.add(ChatMessage(message: "Something went wrong", isBot: true));
//         });
//       }
//     } catch (e) {
//       setState(() {
//         chatMessages.add(ChatMessage(
//             message: "Error contacting server.", isBot: true));
//       });
//     }
//
//     _controller.clear();
//
//     _scrollToBottom(); // scroll after bot message
//   }
//
//   //----------------------------------------------
//   // SCROLL TO BOTTOM
//   //----------------------------------------------
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   //----------------------------------------------
//   // PERMISSION REQUEST
//   //----------------------------------------------
//   Future<bool> requestStoragePermission() async {
//     if (Platform.isAndroid) {
//       var sdk = (await SharedPreferences.getInstance()).getInt('android_sdk') ?? 33;
//
//       if (sdk >= 33) {
//         var perm = await Permission.manageExternalStorage.request();
//         var mediaPerm = await Permission.photos.request();
//         return perm.isGranted || mediaPerm.isGranted;
//       } else {
//         var perm = await Permission.storage.request();
//         return perm.isGranted;
//       }
//     }
//     return true; // iOS assumed allowed
//   }
//
//   //----------------------------------------------
//   // DOWNLOAD FILE
//   //----------------------------------------------
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
//   //----------------------------------------------
//   // UI
//   //----------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Student ChatBot")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               controller: _scrollController, // assign controller here
//               padding: const EdgeInsets.all(10),
//               children: chatMessages.map((msg) {
//                 return Align(
//                   alignment:
//                   msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
//                   child: Column(
//                     crossAxisAlignment: msg.isBot
//                         ? CrossAxisAlignment.start
//                         : CrossAxisAlignment.end,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         margin: const EdgeInsets.symmetric(vertical: 4),
//                         decoration: BoxDecoration(
//                           color: msg.isBot ? Colors.grey[300] : Colors.blue[200],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           msg.message,
//                           style: const TextStyle(fontSize: 15),
//                         ),
//                       ),
//                       if (msg.notes != null)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: msg.notes!.map((note) {
//                             return GestureDetector(
//                               onTap: () => downloadFile(
//                                   note.file, "${note.title}.pdf"),
//                               child: Container(
//                                 margin: const EdgeInsets.only(top: 6),
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(color: Colors.grey.shade400),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Icon(Icons.download,
//                                         size: 20, color: Colors.blue),
//                                     const SizedBox(width: 6),
//                                     Flexible(
//                                       child: Text(
//                                         note.title,
//                                         style: const TextStyle(fontSize: 14),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: "Ask something...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: sendMessage,
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// //----------------------------------------------------
// // MODELS
// //----------------------------------------------------
// class RecommendedNote {
//   final String title;
//   final String date;
//   final String file;
//
//   RecommendedNote({
//     required this.title,
//     required this.date,
//     required this.file,
//   });
//
//   factory RecommendedNote.fromJson(Map<String, dynamic> json) {
//     return RecommendedNote(
//       title: json['title'],
//       date: json['date'],
//       file: json['file'],
//     );
//   }
// }
//
// class ChatMessage {
//   final String message;
//   final bool isBot;
//   final List<RecommendedNote>? notes;
//
//   ChatMessage({required this.message, required this.isBot, this.notes});
// }
//




import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:iconsax/iconsax.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<ChatMessage> chatMessages = [];
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        chatMessages.add(ChatMessage(
          message: "Hello! I'm your study assistant. Ask me anything about your notes, and I'll find relevant materials for you.",
          isBot: true,
        ));
      });
      _scrollToBottom();
    });
  }


  Future<void> sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String msg = _controller.text.trim();

    setState(() {
      chatMessages.add(ChatMessage(message: msg, isBot: false));
      _isBotTyping = true;
    });

    _scrollToBottom();
    _controller.clear();
    _focusNode.unfocus();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';

    try {
      var response = await http.post(
        Uri.parse("$url/chatbot_recommend_notes/"),
        body: {"message": msg},
      );

      var data = jsonDecode(response.body);

      setState(() {
        _isBotTyping = false;
      });

      if (data['status'] == 'ok') {
        List<RecommendedNote> temp = [];
        for (var n in data['data']) {
          temp.add(RecommendedNote.fromJson(n));
        }

        setState(() {
          chatMessages.add(ChatMessage(
              message: temp.isNotEmpty
                  ? "I found ${temp.length} note(s) that might help you:"
                  : "I couldn't find any notes matching your query. Try asking differently.",
              isBot: true,
              notes: temp.isNotEmpty ? temp : null));
        });
      } else if (data['status'] == 'nomatch') {
        setState(() {
          chatMessages.add(ChatMessage(
              message: "${data['message']}", isBot: true));
        });
      } else {
        setState(() {
          chatMessages.add(ChatMessage(message: "I'm having trouble processing your request. Please try again.", isBot: true));
        });
      }
    } catch (e) {
      setState(() {
        _isBotTyping = false;
        chatMessages.add(ChatMessage(
            message: "⚠️ Connection error. Please check your internet and try again.", isBot: true));
      });
    }

    _scrollToBottom();
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var sdk = (await SharedPreferences.getInstance()).getInt('android_sdk') ?? 33;

      if (sdk >= 33) {
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
        SnackBar(
          content: const Text("Permission required to download"),
          backgroundColor: Colors.orangeAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Downloading..."),
          backgroundColor: Colors.blueAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      await Dio().download(url, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Download completed!"),
          backgroundColor: Colors.greenAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: "Open",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Download failed: ${e.toString()}"),
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
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

                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Study Assistant',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AI-powered note finder',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chat Icon
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
                        Iconsax.message_2,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Chat Messages
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 10),
                    ...chatMessages.map((msg) {
                      return _buildMessageBubble(msg);
                    }).toList(),
                    if (_isBotTyping) _buildTypingIndicator(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Input Area
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.deepPurpleAccent.withOpacity(0.3),
                            width: 2,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.05),
                              Colors.white.withOpacity(0.02),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Ask about your notes...",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              //
                            ),
                            onSubmitted: (_) => sendMessage(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 52,
                      height: 52,
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
                            color: Colors.deepPurpleAccent.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Iconsax.send_2,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: msg.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (msg.isBot)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent,
                    Colors.blueAccent,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.cpu,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: msg.isBot ? 12 : 0,
                right: msg.isBot ? 0 : 12,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: msg.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  // Message Bubble
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(msg.isBot ? 4 : 20),
                        bottomRight: Radius.circular(msg.isBot ? 20 : 4),
                      ),
                      gradient: LinearGradient(
                        colors: msg.isBot
                            ? [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.02),
                        ]
                            : [
                          Colors.deepPurpleAccent.withOpacity(0.3),
                          Colors.blueAccent.withOpacity(0.3),
                        ],
                      ),
                      border: Border.all(
                        color: msg.isBot
                            ? Colors.white.withOpacity(0.1)
                            : Colors.deepPurpleAccent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      msg.message,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Notes List
                  if (msg.notes != null && msg.notes!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: msg.notes!.map((note) {
                          return _buildNoteCard(note);
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!msg.isBot)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent,
                    Colors.pinkAccent,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.user,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(RecommendedNote note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.tealAccent.withOpacity(0.1),
            Colors.blueAccent.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.tealAccent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => downloadFile(note.file, "${note.title}.pdf"),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.tealAccent.withOpacity(0.3),
                        Colors.blueAccent.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Iconsax.document_download,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            note.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.tealAccent.withOpacity(0.1),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.download,
                        size: 14,
                        color: Colors.tealAccent,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.tealAccent,
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

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 48),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.blueAccent,
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Iconsax.cpu,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurpleAccent,
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


class RecommendedNote {
  final String title;
  final String date;
  final String file;

  RecommendedNote({
    required this.title,
    required this.date,
    required this.file,
  });

  factory RecommendedNote.fromJson(Map<String, dynamic> json) {
    return RecommendedNote(
      title: json['title'],
      date: json['date'],
      file: json['file'],
    );
  }
}

class ChatMessage {
  final String message;
  final bool isBot;
  final List<RecommendedNote>? notes;

  ChatMessage({required this.message, required this.isBot, this.notes});
}