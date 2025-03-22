import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student_model.dart';

class StudentDBHelper {
  static final StudentDBHelper _instance = StudentDBHelper._internal();
  static Database? _database;
  final SupabaseClient supabase = Supabase.instance.client;

  StudentDBHelper._internal();
  factory StudentDBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'students.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(_createTableQuery());
      },
    );
  }

  String _createTableQuery() {
    return ''' ''';
  }

  
  Future<Student?> getStudentById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Student.fromMap(result.first);
    }
    return null;
  }

  
  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('students');
    return result.map((e) => Student.fromMap(e)).toList();
  }

  
  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  
  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  
  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  
  Future<void> syncLocalToSupabase() async {
    final students = await getAllStudents();

   for (var student in students) {
  await supabase
      .from('students')
      .upsert(student.toMap(), onConflict: 'id'); // ✅ FIXED
}

  }

  
  Future<void> syncSupabaseToLocal() async {
    final db = await database;
    final response = await supabase.from('students').select();

    for (var data in response) {
      Student student = Student.fromMap(data);

      // Check if student exists in SQLite
      Student? existingStudent = await getStudentById(student.id!);

      
      if (existingStudent == null) {
        await insertStudent(student);
      } else {
        DateTime existingUpdatedAt = DateTime.parse(existingStudent.updatedAt);
        DateTime newUpdatedAt = DateTime.parse(student.updatedAt);

        if (existingUpdatedAt.isBefore(newUpdatedAt)) {
          await updateStudent(student);
        }
      }
    }
  }
}
