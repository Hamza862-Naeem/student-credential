import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/student_list.dart';
import 'controller/student_controller.dart'; // Import your controller

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Supabase.initialize(
      url: "https://obgjakoqfigugfuljyjk.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9iZ2pha29xZmlndWdmdWxqeWprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI1OTI1NjgsImV4cCI6MjA1ODE2ODU2OH0.5K5AXLrqtBcvlxhfrdMwo1d0mQWZDhuuj0Ye4_co1f4");

  
  Get.put(StudentController()); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Credentials',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StudentListScreen(),
    );
  }
}
