import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/student_controller.dart';
import 'student_form.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController studentController = Get.find<StudentController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Student Credentials")),
      body: Obx(() {
        if (studentController.students.isEmpty) {
          return const Center(child: Text("No students found!"));
        }
        return ListView.builder(
          itemCount: studentController.students.length,
          itemBuilder: (context, index) {
            final student = studentController.students[index];
            return ListTile(
              title: Text(student.name),
              subtitle: Text("Roll No: ${student.rollNo} | Class: ${student.className}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Get.to(() => StudentFormScreen(student: student, index: index))
                          ?.then((_) => studentController.loadStudents()); 
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmation(context, studentController, student.id!);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const StudentFormScreen())?.then((_) {
            studentController.loadStudents(); 
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, StudentController controller, int studentId) {
    Get.defaultDialog(
      title: "Delete Student?",
      middleText: "Are you sure you want to delete this student?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteStudent(studentId);
        Get.back(); 
      },
    );
  }
}
