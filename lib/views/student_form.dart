import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/student_controller.dart';
import '../models/student_model.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;
  final int? index;

  const StudentFormScreen({super.key, this.student, this.index});

  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _classNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _subjectsController = TextEditingController();
  final _favoriteBookController = TextEditingController();

  final StudentController studentController = Get.find();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _rollNoController.text = widget.student!.rollNo;
      _classNameController.text = widget.student!.className;
      _sectionController.text = widget.student!.section;
      _subjectsController.text = widget.student!.subjects;
      _favoriteBookController.text = widget.student!.favoriteBook;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollNoController.dispose();
    _classNameController.dispose();
    _sectionController.dispose();
    _subjectsController.dispose();
    _favoriteBookController.dispose();
    super.dispose();
  }

  void _saveStudent() {
  if (_formKey.currentState!.validate()) {
    Student newStudent = Student(
      name: _nameController.text,
      rollNo: _rollNoController.text,
      className: _classNameController.text,
      section: _sectionController.text,
      subjects: _subjectsController.text,
      favoriteBook: _favoriteBookController.text,
      updatedAt: DateFormat('HH:mm:ss').format(DateTime.now()), 
    );

    if (widget.student == null) {
      studentController.addStudent(newStudent);
    } else {
      studentController.updateStudent(widget.index!, newStudent);
    }

    Get.back();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? "Add Student" : "Edit Student"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter name" : null,
                autofocus: true,
              ),
              TextFormField(
                controller: _rollNoController,
                decoration: const InputDecoration(labelText: "Roll No"),
                validator: (value) => value!.isEmpty ? "Enter roll no" : null,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _classNameController,
                decoration: const InputDecoration(labelText: "Class Name"),
                validator: (value) => value!.isEmpty ? "Enter class name" : null,
              ),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(labelText: "Section"),
                validator: (value) => value!.isEmpty ? "Enter section" : null,
              ),
              TextFormField(
                controller: _subjectsController,
                decoration: const InputDecoration(
                  labelText: "Subjects (comma separated)",
                ),
                keyboardType: TextInputType.multiline,
                validator: (value) => value!.isEmpty ? "Enter subjects" : null,
              ),
              TextFormField(
                controller: _favoriteBookController,
                decoration: const InputDecoration(labelText: "Favorite Book"),
                validator: (value) => value!.isEmpty ? "Enter favorite book" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStudent,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
