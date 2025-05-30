import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:firebase_task_manager/reusables/color_gradiant_bg.dart';
import 'package:firebase_task_manager/constants.dart';
import 'package:firebase_task_manager/l10n/app_localizations.dart';
import 'package:firebase_task_manager/providers/app_settings_provider.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  DateTime? _deadline;
  Duration? _expectedDuration;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _title = '';
    _description = '';
    _deadline = DateTime.now();
    _expectedDuration = const Duration(minutes: 60);
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        setState(() {
          _deadline = DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': _title,
        'description': _description,
        'deadline': _deadline,
        'expectedDuration': _expectedDuration?.inMinutes,
        'isComplete': _isComplete,
        'timestamp': Timestamp.now(),
        'uid': user.uid,
      });
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 6.0,
        backgroundColor: bgColor,
        shadowColor: Colors.black,
        title: Text(
          'New Task',
          style: TextStyle(
            fontFamily:
                GoogleFonts.ubuntu(fontWeight: FontWeight.bold).fontFamily,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submit,
          ),
        ],
      ),
      body: Container(
        decoration: gradientBGDecoration(
            appBgColor, appBgColor),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!,
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                ),
                ListTile(
                  title: Text('Deadline: ${DateFormat.yMd().format(_deadline!)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDeadline(context),
                ),
                TextFormField(
                  initialValue: _expectedDuration!.inMinutes.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Expected Duration (in minutes)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _expectedDuration = Duration(minutes: int.parse(value!));
                  },
                ),
                SwitchListTile(
                  title: const Text('Complete'),
                  value: _isComplete,
                  onChanged: (value) {
                    setState(() => _isComplete = value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
