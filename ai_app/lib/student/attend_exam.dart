// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class QuizPage2 extends StatefulWidget {
//   const QuizPage2({Key? key}) : super(key: key);
//
//   @override
//   State<QuizPage2> createState() => _QuizPage2State();
// }
//
// class _QuizPage2State extends State<QuizPage2> {
//   List<Map<String, dynamic>> questions = [];
//   Map<int, String> selectedAnswers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     fetchQuizQuestions();
//   }
//
//   Future<void> fetchQuizQuestions() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String baseUrl = sh.getString('url').toString();
//       String testId = sh.getString('test_id').toString();
//
//       String apiUrl = '$baseUrl/user_view_question_get/';
//
//       var response = await http.post(Uri.parse(apiUrl), body: {
//         'test_id': testId,
//       });
//
//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);
//
//         if (jsonData['status'] == 'ok') {
//           setState(() {
//             questions = List<Map<String, dynamic>>.from(
//               jsonData['data'].map((q) => {
//                 'id': q['id'],
//                 'question': q['question'],
//                 'date': q['date'],
//                 'options': [
//                   q['option1'],
//                   q['option2'],
//                   q['option3'],
//                   q['option4'],
//                 ],
//               }),
//             );
//           });
//         }
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   void submitQuiz() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String baseUrl = sh.getString('url').toString();
//       String studentId = sh.getString('sid').toString();
//       String testId = sh.getString('test_id').toString();
//
//       final submitUrl = Uri.parse('$baseUrl/submit_answer/');
//
//       final String encodedAnswers = jsonEncode(
//         selectedAnswers.map(
//               (key, value) => MapEntry(key.toString(), value),
//         ),
//       );
//
//       final response = await http.post(
//         submitUrl,
//         body: {
//           'student_id': studentId,
//           'test_id': testId,
//           'answer': encodedAnswers,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: 'Submitted Successfully');
//         } else {
//           Fluttertoast.showToast(msg: 'Submission Failed or already attended');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quiz Page'),
//       ),
//       body: questions.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: questions.length,
//         itemBuilder: (context, index) {
//           var question = questions[index];
//
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     question['question'],
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 10),
//
//                   ...List.generate(
//                     question['options'].length,
//                         (optionIndex) {
//                       String option = question['options'][optionIndex];
//                       return RadioListTile(
//                         title: Text(option),
//                         value: option,
//                         groupValue: selectedAnswers[question['id']],
//                         onChanged: (value) {
//                           setState(() {
//                             selectedAnswers[question['id']] =
//                                 value.toString();
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ElevatedButton(
//           onPressed: submitQuiz,
//           child: const Text('Submit Quiz'),
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

class QuizPage2 extends StatefulWidget {
  const QuizPage2({Key? key}) : super(key: key);

  @override
  State<QuizPage2> createState() => _QuizPage2State();
}

class _QuizPage2State extends State<QuizPage2> {
  List<Map<String, dynamic>> questions = [];
  Map<int, String> selectedAnswers = {};
  bool _isLoading = true;
  int _currentQuestionIndex = 0;
  int _answeredCount = 0;
  int _totalQuestions = 0;

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  Future<void> fetchQuizQuestions() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url').toString();
      String testId = sh.getString('test_id').toString();

      if (baseUrl.isEmpty || testId.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String apiUrl = '$baseUrl/user_view_question_get/';

      var response = await http.post(Uri.parse(apiUrl), body: {
        'test_id': testId,
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == 'ok') {
          setState(() {
            questions = List<Map<String, dynamic>>.from(
              jsonData['data'].map((q) => {
                'id': q['id'],
                'question': q['question'],
                'date': q['date'],
                'options': [
                  q['option1'],
                  q['option2'],
                  q['option3'],
                  q['option4'],
                ],
              }),
            );
            _totalQuestions = questions.length;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void submitQuiz() async {
    if (selectedAnswers.length != questions.length) {
      Fluttertoast.showToast(
        msg: 'Please answer all questions before submitting',
        backgroundColor: Colors.orangeAccent,
        textColor: Colors.black,
      );
      return;
    }

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url').toString();
      String studentId = sh.getString('sid').toString();
      String testId = sh.getString('test_id').toString();

      final submitUrl = Uri.parse('$baseUrl/submit_answer/');

      final String encodedAnswers = jsonEncode(
        selectedAnswers.map(
              (key, value) => MapEntry(key.toString(), value),
        ),
      );

      final response = await http.post(
        submitUrl,
        body: {
          'student_id': studentId,
          'test_id': testId,
          'answer': encodedAnswers,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: 'Submitted Successfully',
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black,
          );
          // Optionally navigate back after submission
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        } else {
          Fluttertoast.showToast(
            msg: 'Submission Failed or already attended',
            backgroundColor: Colors.redAccent,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Network Error',
          backgroundColor: Colors.redAccent,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        backgroundColor: Colors.redAccent,
      );
    }
  }

  void _selectAnswer(String option) {
    setState(() {
      selectedAnswers[questions[_currentQuestionIndex]['id']] = option;
      if (!_isOptionSelected(option)) {
        _answeredCount++;
      }
    });
  }

  bool _isOptionSelected(String option) {
    return selectedAnswers[questions[_currentQuestionIndex]['id']] == option;
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
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
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
            ),
          )
              : questions.isEmpty
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
                    Iconsax.document_text,
                    size: 50,
                    color: Colors.white30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Questions Available',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for the exam',
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
              // App Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Back Button
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
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Online Exam',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Question ${_currentQuestionIndex + 1} of $_totalQuestions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Progress Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.deepPurpleAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '$_answeredCount/$_totalQuestions',
                        style: const TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Question Progress
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _totalQuestions,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  color: Colors.deepPurpleAccent,
                  minHeight: 4,
                ),
              ),

              // Question Card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question Number
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Q${_currentQuestionIndex + 1}',
                                style: const TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Question Text
                            Text(
                              questions[_currentQuestionIndex]['question'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Options
                            Column(
                              children: List.generate(
                                questions[_currentQuestionIndex]['options'].length,
                                    (optionIndex) {
                                  String option = questions[_currentQuestionIndex]['options'][optionIndex];
                                  bool isSelected = _isOptionSelected(option);
                                  return GestureDetector(
                                    onTap: () => _selectAnswer(option),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: isSelected
                                            ? Colors.deepPurpleAccent.withOpacity(0.2)
                                            : Colors.white.withOpacity(0.05),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.deepPurpleAccent
                                              : Colors.white.withOpacity(0.2),
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected
                                                  ? Colors.deepPurpleAccent
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: Colors.white.withOpacity(0.3),
                                              ),
                                            ),
                                            child: isSelected
                                                ? const Icon(
                                              Iconsax.tick_circle,
                                              size: 12,
                                              color: Colors.white,
                                            )
                                                : null,
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.white70,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Navigation Buttons
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: _goToPreviousQuestion,
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
                                      Iconsax.arrow_left_2,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Previous',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.deepPurpleAccent,
                                    Colors.blueAccent,
                                  ],
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: _currentQuestionIndex < questions.length - 1
                                    ? _goToNextQuestion
                                    : null,
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
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Iconsax.arrow_right_3,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Submit Button
      bottomNavigationBar: questions.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: selectedAnswers.length == questions.length
                  ? [Colors.greenAccent, Colors.tealAccent]
                  : [Colors.deepPurpleAccent, Colors.blueAccent],
            ),
          ),
          child: ElevatedButton(
            onPressed: selectedAnswers.length == questions.length
                ? submitQuiz
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.send_2,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  selectedAnswers.length == questions.length
                      ? 'Submit Exam'
                      : 'Complete All Questions ($_answeredCount/$_totalQuestions)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}