
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ChatBotPage extends StatefulWidget {
//   const ChatBotPage({super.key});
//
//   @override
//   State<ChatBotPage> createState() => _ChatBotPageState();
// }
//
// class _ChatBotPageState extends State<ChatBotPage> {
//
//   TextEditingController controller = TextEditingController();
//   ScrollController scrollController = ScrollController();
//
//   List<ChatMessage> messages = [];
//
//   bool loading = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     messages.add(ChatMessage(
//         text: "👋 Ask about your notes",
//         isBot: true));
//   }
//
//   /// ===========================
//   /// SEND MESSAGE
//   /// ===========================
//   Future<void> sendMessage() async {
//
//     String msg = controller.text.trim();
//
//     if (msg.isEmpty) return;
//
//     setState(() {
//
//       messages.add(ChatMessage(text: msg, isBot: false));
//       loading = true;
//
//     });
//
//     controller.clear();
//     scrollToBottom();
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String? url = sh.getString('url');
//
//       var response = await http.post(
//         Uri.parse("$url/chatbot_recommend_notes/"),
//         headers: {
//           "Content-Type":
//           "application/x-www-form-urlencoded"
//         },
//         body: {
//           "message": msg
//         },
//       );
//
//       var data = jsonDecode(response.body);
//
//       loading = false;
//
//       if (data["status"] == "ok") {
//
//         List list = data["data"];
//
//         for (var n in list) {
//
//           messages.add(ChatMessage(
//               isBot: true,
//               text: "📘 ${n["title"]}\n\n"
//                   "🧠 Relevant Part:\n${n["snippet"]}\n\n"
//                   "📖 Full Text:\n${n["full_text"]}\n\n"
//                   "⭐ Score: ${n["score"]}",
//               file: n["file"]));
//         }
//
//         setState(() {});
//       }
//       else {
//
//         setState(() {
//           messages.add(ChatMessage(
//               text: data["message"],
//               isBot: true));
//         });
//       }
//
//     } catch (e) {
//
//       loading = false;
//
//       setState(() {
//         messages.add(ChatMessage(
//             text: "⚠️ Network error",
//             isBot: true));
//       });
//     }
//
//     scrollToBottom();
//   }
//
//   void scrollToBottom() {
//
//     Future.delayed(const Duration(milliseconds: 300), () {
//
//       if (scrollController.hasClients) {
//         scrollController.jumpTo(
//             scrollController.position.maxScrollExtent);
//       }
//
//     });
//   }
//
//   /// ===========================
//   /// UI
//   /// ===========================
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       backgroundColor: const Color(0xff0F0B21),
//
//       appBar: AppBar(title: const Text("Notes Chatbot")),
//
//       body: Column(
//
//         children: [
//
//           Expanded(
//             child: ListView.builder(
//               controller: scrollController,
//               padding: const EdgeInsets.all(12),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return buildBubble(messages[index]);
//               },
//             ),
//           ),
//
//           if (loading)
//             const Text("Bot typing...",
//                 style: TextStyle(color: Colors.white54)),
//
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: [
//
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                         hintText: "Ask notes...",
//                         hintStyle: TextStyle(color: Colors.white54)),
//                   ),
//                 ),
//
//                 IconButton(
//                     onPressed: sendMessage,
//                     icon: const Icon(Icons.send,
//                         color: Colors.white))
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget buildBubble(ChatMessage msg) {
//
//     return Align(
//       alignment:
//       msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 15),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//             color: msg.isBot
//                 ? Colors.white.withOpacity(0.06)
//                 : Colors.deepPurpleAccent,
//             borderRadius: BorderRadius.circular(16)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Text(msg.text,
//                 style: const TextStyle(color: Colors.white)),
//
//             if (msg.file != null)
//               Text("PDF: ${msg.file}",
//                   style: const TextStyle(
//                       color: Colors.orangeAccent,
//                       fontSize: 12))
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ChatMessage {
//
//   final String text;
//   final bool isBot;
//   final String? file;
//
//   ChatMessage({
//     required this.text,
//     required this.isBot,
//     this.file,
//   });
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {

  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<ChatMessage> messages = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    messages.add(
      ChatMessage(
        text: "👋 Ask about your notes",
        isBot: true,
      ),
    );
  }

  /// ===========================
  /// OPEN PDF
  /// ===========================
  Future<void> openPdf(String file) async {

    final Uri pdfUrl = Uri.parse(file);

    if (!await launchUrl(pdfUrl, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not open PDF");
    }
  }

  /// ===========================
  /// SEND MESSAGE
  /// ===========================
  Future<void> sendMessage() async {

    String msg = controller.text.trim();

    if (msg.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text: msg, isBot: false));
      loading = true;
    });

    controller.clear();
    scrollToBottom();

    try {

      SharedPreferences sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');

      var response = await http.post(
        Uri.parse("$url/chatbot_recommend_notes/"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "message": msg
        },
      );

      var data = jsonDecode(response.body);

      loading = false;

      if (data["status"] == "ok") {

        List list = data["data"];

        for (var n in list) {

          messages.add(
            ChatMessage(
              isBot: true,
              text:
              "📘 ${n["title"]}\n\n"
                  "🧠 Relevant Part:\n${n["snippet"]}\n\n"
                  "📖 Full Text:\n${n["full_text"]}\n\n"
                  "⭐ Score: ${n["score"]}",
              file: n["file"],
            ),
          );
        }

        setState(() {});

      } else {

        setState(() {
          messages.add(
            ChatMessage(
              text: data["message"],
              isBot: true,
            ),
          );
        });

      }

    } catch (e) {

      loading = false;

      setState(() {
        messages.add(
          ChatMessage(
            text: "⚠️ Network error",
            isBot: true,
          ),
        );
      });
    }

    scrollToBottom();
  }

  void scrollToBottom() {

    Future.delayed(const Duration(milliseconds: 300), () {

      if (scrollController.hasClients) {

        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );

      }

    });
  }

  /// ===========================
  /// UI
  /// ===========================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xff0F0B21),

      appBar: AppBar(
        title: const Text("Notes Chatbot"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildBubble(messages[index]);
              },
            ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "Bot typing...",
                style: TextStyle(color: Colors.white54),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Ask notes...",
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget buildBubble(ChatMessage msg) {

    return Align(
      alignment:
      msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: msg.isBot
              ? Colors.white.withOpacity(0.06)
              : Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              msg.text,
              style: const TextStyle(color: Colors.white),
            ),

            if (msg.file != null)
              GestureDetector(
                onTap: () {
                  openPdf(msg.file!);
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "📄 View PDF",
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )

          ],
        ),
      ),
    );
  }
}

class ChatMessage {

  final String text;
  final bool isBot;
  final String? file;

  ChatMessage({
    required this.text,
    required this.isBot,
    this.file,
  });
}