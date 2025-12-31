// import 'dart:convert';
// import 'package:ai_app/student/home.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const ViewTestResults());
// }
//
// class ViewTestResults extends StatelessWidget {
//   const ViewTestResults({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ViewTestResultsPage(title: 'Test Results'),
//     );
//   }
// }
//
// class ViewTestResultsPage extends StatefulWidget {
//   const ViewTestResultsPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ViewTestResultsPage> createState() => _ViewTestResultsPageState();
// }
//
// class _ViewTestResultsPageState extends State<ViewTestResultsPage> {
//   List<Map<String, dynamic>> results = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchResults();
//   }
//
//   Future<void> fetchResults() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url') ?? '';
//       String sid = sh.getString('sid') ?? '';
//
//       String apiUrl = '$urls/student_view_results/';
//       var response = await http.post(Uri.parse(apiUrl), body: {
//         'sid': sid,
//       });
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'id': item['id'].toString(),
//             'subject': item['subject'].toString(),
//             'score': item['score'].toString(),
//             'total': item['total'].toString(),
//             'date': item['date'].toString(),
//           });
//         }
//         setState(() {
//           results = tempList;
//         });
//       }
//     } catch (e) {
//       print("Error fetching test results: $e");
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
//           title: Text(widget.title),
//           centerTitle: true,
//         ),
//         body: results.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//           shrinkWrap: true,
//           physics: const BouncingScrollPhysics(),
//           itemCount: results.length,
//           itemBuilder: (context, index) {
//             final result = results[index];
//             return Card(
//               margin: const EdgeInsets.all(10),
//               elevation: 5,
//               child: ListTile(
//                 title: Text(
//                   "Subject: ${result['subject']}",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Score: ${result['score']} / ${result['total']}"),
//                     Text("Date: ${result['date']}"),
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



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:ai_app/student/home.dart'; // your home page import

void main() {
  runApp(const ViewTestResults());
}

class ViewTestResults extends StatelessWidget {
  const ViewTestResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

      ),
      home: const ViewTestResultsPage(title: 'Test Results'),
    );
  }
}

class ViewTestResultsPage extends StatefulWidget {
  const ViewTestResultsPage({super.key, required this.title});
  final String title;

  @override
  State<ViewTestResultsPage> createState() => _ViewTestResultsPageState();
}

class _ViewTestResultsPageState extends State<ViewTestResultsPage> {
  List<Map<String, dynamic>> results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String sid = sh.getString('sid') ?? '';

      var response = await http.post(
        Uri.parse('$urls/student_view_results/'),
        body: {'sid': sid},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        setState(() {
          results = List<Map<String, dynamic>>.from(jsonData['data']);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching results: $e");
      setState(() => _isLoading = false);
    }
  }

  double _calculatePercentage(String score, String total) {
    try {
      double s = double.parse(score);
      double t = double.parse(total);
      return t > 0 ? (s / t) * 100 : 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  Color _getScoreColor(double percent) {
    if (percent >= 80) return Colors.greenAccent;
    if (percent >= 60) return Colors.yellowAccent;
    if (percent >= 40) return Colors.orangeAccent;
    return Colors.redAccent;
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

  String _getGrade(double percent) {
    if (percent >= 90) return 'Excellent';
    if (percent >= 80) return 'Very Good';
    if (percent >= 70) return 'Good';
    if (percent >= 60) return 'Satisfactory';
    if (percent >= 50) return 'Needs Improvement';
    return 'Poor';
  }

  IconData _getResultIcon(double percent) {
    if (percent >= 80) return Iconsax.star;
    if (percent >= 60) return Iconsax.tick_circle;
    if (percent >= 40) return Iconsax.info_circle;
    return Iconsax.close_circle;
  }

  String _calculateAverageScore() {
    if (results.isEmpty) return '0%';
    double total = 0;
    for (var r in results) {
      total += _calculatePercentage(r['score'], r['total']);
    }
    return '${(total / results.length).toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const userHomePAge()));
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F0B21), Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              if (!_isLoading && results.isNotEmpty) _buildStats(),
              Expanded(child: _buildResultList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent.withOpacity(0.2), Colors.blueAccent.withOpacity(0.2)],
        ),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Test Results', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white)),
                const SizedBox(height: 4),
                Text('${results.length} test records', style: const TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Colors.deepPurpleAccent, Colors.blueAccent]),
            ),
            child: const Icon(Iconsax.chart_square, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent.withOpacity(0.2), Colors.blueAccent.withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Iconsax.book, 'Subjects', results.length.toString(), Colors.blueAccent),
          _buildStatItem(Iconsax.trend_up, 'Avg Score', _calculateAverageScore(), Colors.greenAccent),
          _buildStatItem(Iconsax.calendar, 'Latest', results.first['date'], Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.1)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildResultList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent));
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
                child: const Icon(Iconsax.note_remove, size: 50, color: Colors.white30)),
            const SizedBox(height: 20),
            const Text('No Test Results', style: TextStyle(fontSize: 20, color: Colors.white70, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Your test results will appear here', style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 20),
            TextButton(
              onPressed: fetchResults,
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Refresh', style: TextStyle(color: Colors.white70)),
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.deepPurpleAccent,
      backgroundColor: const Color(0xFF1A1A2E),
      onRefresh: fetchResults,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: results.length,
        itemBuilder: (context, index) => _buildResultCard(results[index], index),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result, int index) {
    double percentage = _calculatePercentage(result['score'], result['total']);
    Color scoreColor = _getScoreColor(percentage);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [_getCardColor(index).withOpacity(0.15), _getCardColor(index).withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _getCardColor(index).withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(result['subject'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                Text(result['date'], style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white.withOpacity(0.05),
              color: scoreColor,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: ${result['score']} / ${result['total']}', style: const TextStyle(color: Colors.white70)),
                Text('${percentage.toStringAsFixed(1)}%', style: TextStyle(fontWeight: FontWeight.bold, color: scoreColor)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: scoreColor.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: scoreColor)),
                      const SizedBox(width: 8),
                      Text(_getGrade(percentage), style: TextStyle(color: scoreColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(_getResultIcon(percentage), color: scoreColor, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



