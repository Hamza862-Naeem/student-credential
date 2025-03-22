import 'package:intl/intl.dart';

class Student {
  int? id;
  String name;
  String rollNo;
  String className;
  String section;
  String subjects;
  String favoriteBook;
  String updatedAt; 

  Student({
    this.id,
    required this.name,
    required this.rollNo,
    required this.className,
    required this.section,
    required this.subjects,
    required this.favoriteBook,
    required this.updatedAt,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roll_no': rollNo,
      'class_name': className,
      'section': section,
      'subjects': subjects,
      'favorite_book': favoriteBook,
      'updated_at': DateFormat('HH:mm:ss').format(DateTime.now()), 
    };
  }

  
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null, 
      name: map['name']?.toString() ?? '',
      rollNo: map['roll_no']?.toString() ?? '',
      className: map['class_name']?.toString() ?? '',
      section: map['section']?.toString() ?? '',
      subjects: map['subjects']?.toString() ?? '',
      favoriteBook: map['favorite_book']?.toString() ?? '',
      updatedAt: map['updated_at']?.toString() ?? DateFormat('HH:mm:ss').format(DateTime.now()), 
    );
  }
}
