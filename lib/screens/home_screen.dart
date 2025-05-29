import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:firebase_task_manager/constants.dart';
import 'package:firebase_task_manager/screens/task_form_screen.dart';
import 'package:firebase_task_manager/reusables/shimmering_text_widget.dart';
import 'package:firebase_task_manager/screens/login_screen.dart';
import 'package:firebase_task_manager/screens/settings_screen.dart';
import 'package:firebase_task_manager/l10n/app_localizations.dart';
import 'package:firebase_task_manager/providers/app_settings_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool settingsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!settingsLoaded) {
      final settingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('preferences')
            .get()
            .then((doc) {
          if (doc.exists) {
            final lang = doc['language'] ?? 'en';
            final theme = doc['isDarkTheme'] ?? false;

            settingsProvider.loadAll(
              locale: Locale(lang),
              isDark: theme,
            );
          }
        }).whenComplete(() {
          setState(() {
            settingsLoaded = true;
          });
        });
      } else {
        settingsLoaded = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final loc = AppLocalizations.of(context);
    final isDark = settings.isDarkTheme;
    final bgColor = isDark ? Colors.brown[900] : homeScreenSecondaryBGColor;
    final appBgColor = isDark ? const Color.fromARGB(255, 34, 21, 19) : homeScreenPrimaryBGColor;
    final drawerColor = isDark ? Colors.grey[900]! : secondaryBGColor;
    final textColor = isDark ? Colors.white : Colors.black;
    

    return Scaffold(
      backgroundColor: bgColor,
      drawer: Drawer(
        backgroundColor: drawerColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
              child: Text(
                user?.displayName ?? loc.get('welcome'),
                style: TextStyle(
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black54, indent: 30, endIndent: 30),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
              child: Row(
                children: [
                  Icon(Icons.settings, color: textColor),
                  const SizedBox(width: 8),
                  Text(loc.get('settings'), style: TextStyle(fontFamily: GoogleFonts.ubuntu().fontFamily, fontSize: 20, color: textColor)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout_outlined, color: textColor),
                          const SizedBox(width: 8),
                          Text(loc.get('logout'), style: TextStyle(fontFamily: GoogleFonts.ubuntu().fontFamily, fontSize: 20, color: textColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Made by Biloshchytskyi Yevhenii, Biloshchytskyi Artem, Batyr Nursaya, Lisnevskyi Vitalii',
                style: TextStyle(fontFamily: GoogleFonts.notoSerif().fontFamily, fontSize: 15, color: Colors.black38),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: appBgColor,
        elevation: 6.0,
        shadowColor: Colors.black,
        title: ShimmeringTextWidget(
          text: loc.get('title'),
          style: TextStyle(
            fontFamily: GoogleFonts.ubuntu(fontWeight: FontWeight.bold).fontFamily,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TaskFormScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('uid', isEqualTo: uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(loc.get('no_tasks'), style: TextStyle(color: textColor)));
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final deadline = data['deadline'] as Timestamp?;
              final deadlineText = deadline != null
                ? 'Deadline: ${DateFormat.yMd().add_jm().format(deadline.toDate())}'
                : 'No deadline';

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  FirebaseFirestore.instance.collection('tasks').doc(doc.id).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${data['title']} deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  elevation: 4,
                  color: isDark
                      ? (data['isComplete'] == true ? Colors.grey.shade800 : Colors.black)
                      : (data['isComplete'] == true ? Colors.grey.shade400 : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data['title'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              data['isComplete'] == true ? "(Completed)" : "",
                              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: textColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['description'] ?? '',
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              deadlineText,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Checkbox(
                              value: data['isComplete'] ?? false,
                              onChanged: (value) {
                                FirebaseFirestore.instance.collection('tasks').doc(doc.id).update({'isComplete': value});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBgColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
