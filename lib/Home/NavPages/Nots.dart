import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/Theming/app_colors.dart';
import '../../core/Theming/app_string.dart';
import '../../core/Theming/font.dart';
import '../../core/Theming/image.dart';
import '../../core/Widgets/Shared_Widgets.dart';

class Nots extends StatefulWidget {
  const Nots({super.key});

  @override
  State<Nots> createState() => _NotsState();
}

class _NotsState extends State<Nots> {
  final TextEditingController _taskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    tasks = prefs.getStringList('tasks') ?? [];
    setState(() {});
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
  }

  Future<void> _addTask(String task) async {
    setState(() {
      tasks.add(task);
    });
    await _saveTasks();
  }

  Future<void> _removeTask(int index) async {
    setState(() {
      tasks.removeAt(index);
    });
    await _saveTasks();
  }

  Future<void> _clearAllTasks() async {
    setState(() {
      tasks.clear();
    });
    await _saveTasks();
  }

  void _showAddTaskSheet() {
    showBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "أضف ملاحظة جديدة",
                  style: getArabLightTextStyle(
                    context: context,
                    color: AppColors.myBlue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _taskController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: "اكتب الملاحظة",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "برجاء كتابة الملاحظة";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _addTask(_taskController.text.trim());
                      _taskController.clear();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.myBlue,
                  ),
                  child: Text(
                    "إضافة",
                    style: getArabLightTextStyle(
                      context: context,
                      color: AppColors.mywhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          EduTrackContainer(),
          LinesImage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                HomeRowNameAndImage(
                  myImage: AppImages.open_book,
                  myWidget: FadeInRight(
                    child: Text(
                      "الملاحظات",
                      style: getArabBoldItalicTextStyle(
                        context: context,
                        color: AppColors.mywhite,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: Text(
                            "لا توجد ملاحظات",
                            style: getArabLightTextStyle(
                              context: context,
                              color: AppColors.myBlue,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                tasks[index],
                                textAlign: TextAlign.right,
                                style: getArabLightTextStyle(
                                  context: context,
                                  color: AppColors.myBlue,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeTask(index),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addTask",
            onPressed: _showAddTaskSheet,
            backgroundColor: AppColors.myBlue,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
