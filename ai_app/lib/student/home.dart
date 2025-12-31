//
// import 'package:ai_app/student/send_complaint.dart';
// import 'package:ai_app/student/send_feedback.dart';
// import 'package:ai_app/student/view_doubtreply.dart';
// import 'package:ai_app/student/view_exams.dart';
// import 'package:ai_app/student/view_notification.dart';
// import 'package:ai_app/student/view_profile.dart';
// import 'package:ai_app/student/view_recommended_notes.dart';
// import 'package:ai_app/student/view_result.dart';
// import 'package:ai_app/student/view_staff.dart';
// import 'package:ai_app/student/view_subjects.dart';
// import 'package:flutter/material.dart';
//
// import '../login_page.dart';
// import 'change_pwd.dart';
// import 'chat_bot.dart';
//
// void main() {
//   runApp(const userHome());
// }
//
// class userHome extends StatelessWidget {
//   const userHome({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Home Page Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const userHomePAge(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class userHomePAge extends StatefulWidget {
//   const userHomePAge({super.key});
//
//   @override
//   State<userHomePAge> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<userHomePAge> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Welcome Home'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//         elevation: 4,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//
//             const SizedBox(height: 30),
//             const Text(
//               'Hello, User!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => view_profile_page(title: '')),
//                 );
//               },
//               child: const Text('View Profile'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ViewStaffPage(title: '')),
//                 );
//               },
//               child: const Text('View Staffs'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ViewdoubtReplyPage(title: '')),
//                 );
//               },
//               child: const Text('View Doubt Reply'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => std_changepwdPage(title: '')),
//                 );
//               },
//               child: const Text('Change Password'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Send_complaintPage(title: '')),
//                 );
//               },
//               child: const Text('Send Complaint'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => FeedbackPage()),
//                 );
//               },
//               child: const Text('Send feedback'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ViewSubjectPage(title: '')),
//                 );
//               },
//               child: const Text('View Subject'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ViewNotifPage(title: '')),
//                 );
//               },
//               child: const Text('View Notification'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ViewExamPage(title: '')),
//                 );
//               },
//               child: const Text('View Exams'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RecommendedNotesPage()),
//                 );
//               },
//               child: const Text('View Recommended Notes'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ViewTestResultsPage(title: '')),
//                 );
//               },
//               child: const Text('View Results'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ChatBotPage()),
//                 );
//               },
//               child: const Text('ChatBot'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             // const SizedBox(height: 30),
//             // Center(
//             //   child: TextButton(
//             //     onPressed: () {
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(builder: (context) => user_changepwdPage(title: '')),
//             //       );
//             //     },
//             //     child: const Text(
//             //       'Change Password',
//             //       style: TextStyle(color: Colors.red),
//             //     ),
//             //   ),
//             // ),
//             // const SizedBox(height: 10),
//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MyLoginPage(title: '')),
//                   );
//                 },
//                 child: const Text(
//                   'Log Out',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:ai_app/student/send_complaint.dart';
import 'package:ai_app/student/send_feedback.dart';
import 'package:ai_app/student/view_doubtreply.dart';
import 'package:ai_app/student/view_exams.dart';
import 'package:ai_app/student/view_notification.dart';
import 'package:ai_app/student/view_profile.dart';
import 'package:ai_app/student/view_recommended_notes.dart';
import 'package:ai_app/student/view_result.dart';
import 'package:ai_app/student/view_staff.dart';
import 'package:ai_app/student/view_subjects.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../login_page.dart';
import 'change_pwd.dart';
import 'chat_bot.dart';

void main() {
  runApp(const userHome());
}

class userHome extends StatelessWidget {
  const userHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Student Portal',
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
      home: const userHomePAge(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class userHomePAge extends StatefulWidget {
  const userHomePAge({super.key});

  @override
  State<userHomePAge> createState() => _HomePageState();
}

class _HomePageState extends State<userHomePAge> {
  int _selectedIndex = 0;

  // Bottom Navigation Bar Items
  final List<Map<String, dynamic>> _bottomNavItems = [
    {
      'icon': Iconsax.home,
      'label': 'Home',
    },
    {
      'icon': Iconsax.book_1,
      'label': 'Subjects',
    },
    {
      'icon': Iconsax.document_text,
      'label': 'Exams',
    },
    {
      'icon': Iconsax.chart_2,
      'label': 'Results',
    },
    {
      'icon': Icons.smart_toy_outlined,
      'label': 'ChatBot',
    },
  ];

  // Pages for bottom navigation - Using stateful pages
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize pages
    _pages.addAll([
      HomeContent(key: UniqueKey()), // Stateful home content
      ViewSubjectPage(title: '', key: UniqueKey()),
      ViewExamPage(title: '', key: UniqueKey()),
      ViewTestResultsPage(title: '', key: UniqueKey()),
      ChatBotPage(key: UniqueKey()),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _selectedIndex == 0 ? _buildAppBar() : null,
      drawer: _selectedIndex == 0 ? _buildDrawer(context) : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0B21),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _bottomNavItems.length,
                  (index) => _buildBottomNavItem(
                _bottomNavItems[index]['icon'],
                _bottomNavItems[index]['label'],
                index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        constraints: const BoxConstraints(minWidth: 60),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurpleAccent,
              Colors.blueAccent,
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Iconsax.menu_1, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        'Student Portal',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        // Notification Icon in Top Right Corner
        IconButton(
          icon: const Icon(Iconsax.notification, color: Colors.white70),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewNotifPage(title: '')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.05),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F0B21).withOpacity(0.9),
              const Color(0xFF1A1A2E).withOpacity(0.9),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // Drawer Header with Profile Image
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.withOpacity(0.3),
                    Colors.blueAccent.withOpacity(0.3),
                  ],
                ),
              ),

            ),


            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.profile_circle,
                    title: 'View Profile',
                    route: view_profile_page(title: '', key: UniqueKey()),
                  ),
                  const SizedBox(height: 12),

                  _buildDrawerItem(
                    context,
                    icon: Iconsax.lock_1,
                    title: 'Change Password',
                    route: std_changepwdPage(title: '', key: UniqueKey()),
                  ),
                  const SizedBox(height: 12),

                  _buildDrawerItem(
                    context,
                    icon: Iconsax.message_text_1,
                    title: 'Send Feedback',
                    route: FeedbackPage(key: UniqueKey()),
                  ),
                  const SizedBox(height: 12),


                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyLoginPage(title: '', key: UniqueKey())),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  foregroundColor: Colors.redAccent,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                ),
                icon: const Icon(Iconsax.logout_1, size: 20),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        Widget? route,
      }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurpleAccent),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Iconsax.arrow_right_3, color: Colors.white70, size: 18),
        onTap: () {
          if (route != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => route));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// Stateful Home Content Widget
class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Homepage Feature Items
  final List<Map<String, dynamic>> _featureItems = [
    {
      'title': 'View Staff',
      'icon': Iconsax.teacher,
      'color': Colors.blueAccent,
      'route': ViewStaffPage(title: '', key: UniqueKey()),
    },
    {
      'title': 'View Doubts',
      'icon': Iconsax.message_question,
      'color': Colors.greenAccent,
      'route': ViewdoubtReplyPage(title: '', key: UniqueKey()),
    },
    {
      'title': 'Send Complaint',
      'icon': Iconsax.warning_2,
      'color': Colors.orangeAccent,
      'route': Send_complaintPage(title: '', key: UniqueKey()),
    },
    {
      'title': 'View Recommended Notes',
      'icon': Iconsax.note_2,
      'color': Colors.purpleAccent,

      'route': RecommendedNotesPage(key: UniqueKey()),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Image
            _buildWelcomeSection(),

            const SizedBox(height: 32),




            const SizedBox(height: 32),

            // Quick Access Features
            _buildFeaturesGrid(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.deepPurpleAccent.withOpacity(0.3),
            Colors.blueAccent.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ready to learn today?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Access all your academic resources and tools in one place',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),

            // 🔥 Lottie Animation Instead of Image
            Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.deepPurpleAccent,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Lottie.asset(
                  'assets/Graduation Hat.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )

    );
  }



  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: _featureItems.length,
          itemBuilder: (context, index) {
            final item = _featureItems[index];
            return _buildFeatureCard(item, index);
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> item, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item['route']),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              item['color'].withOpacity(0.2),
              item['color'].withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: item['color'].withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: item['color'].withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item['icon'], color: item['color'], size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                item['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}