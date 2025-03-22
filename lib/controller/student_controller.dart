import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/supabase_service.dart';
import '../models/student_model.dart';
import '../database/student_db_helper.dart';

class StudentController extends GetxController {
  final StudentDBHelper _dbHelper = StudentDBHelper();
  final SupabaseService _supabaseService = SupabaseService();
  RxList<Student> students = <Student>[].obs;

  @override
  void onInit() {
    super.onInit();
    syncSupabaseToLocal(); 
    setupRealtimeListener(); 
  }

  
  Future<void> syncSupabaseToLocal() async {
    final cloudStudents = await _supabaseService.fetchStudents();
    for (var student in cloudStudents) {
      final existingStudent = await _dbHelper.getStudentById(student.id!);
      if (existingStudent == null) {
        await _dbHelper.insertStudent(student);
      } else {
        await _dbHelper.updateStudent(student); 
      }
    }
    await loadStudents();
  }

  
  Future<void> loadStudents() async {
    final studentList = await _dbHelper.getAllStudents();
    students.assignAll(studentList);
  }

 
  Future<void> addStudent(Student student) async {
    final id = await _dbHelper.insertStudent(student);
    student.id = id; 
    await _supabaseService.insertStudent(student); 
    await loadStudents();
  }

  Future<void> updateStudent(int index, Student student) async {
    student.id = students[index].id;
    await _dbHelper.updateStudent(student); 
    await _supabaseService.updateStudent(student); 
    await loadStudents();
  }

  
  Future<void> deleteStudent(int id) async {
    await _supabaseService.deleteStudent(id); 
    await _dbHelper.deleteStudent(id); 
    await loadStudents();
  }

 
  void setupRealtimeListener() {
    Supabase.instance.client
        .from('students')
        .stream(primaryKey: ['id'])
        .listen((data) {
          syncSupabaseToLocal();
        });
  }
}
