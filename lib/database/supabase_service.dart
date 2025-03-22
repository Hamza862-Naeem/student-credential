import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student_model.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String tableName = 'students';

  
  Future<List<Student>> fetchStudents() async {
    try {
      final List<dynamic> response = await _supabase.from(tableName).select();
      
      if (response.isEmpty) return []; 

      return response.map((data) => Student.fromMap(data)).toList();
    } catch (e) {
      print(" Error fetching students: $e");
      return []; 
    }
  }

  
  Future<void> insertStudent(Student student) async {
    try {
      await _supabase.from(tableName).insert(student.toMap());
    } catch (e) {
      print(" Error inserting student: $e");
    }
  }

  
  Future<void> updateStudent(Student student) async {
  if (student.id == null) {
    print("Error: Student ID is null");
    return;
  }

  try {
    
    String updatedTime = DateTime.now().toLocal().toString().split(' ')[1].split('.')[0];

    await _supabase.from(tableName).update({
      'name': student.name,
      'roll_no': student.rollNo,
      'class_name': student.className,
      'section': student.section,
      'subjects': student.subjects,
      'favorite_book': student.favoriteBook,
      'updated_at': updatedTime, 
    }).eq('id', student.id!);
  } catch (e) {
    print(" Error updating student: $e");
  }
}

  
  Future<void> deleteStudent(int id) async {
    try {
      await _supabase.from(tableName).delete().eq('id', id);
    } catch (e) {
      print(" Error deleting student: $e");
    }
  }
}
