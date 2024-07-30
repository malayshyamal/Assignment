import 'package:flutter/material.dart';
import 'package:flutter_assigment/employee_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //I am Using Seprate Page to make clean architechture
      home: EmployeeList(),
    );
  }
}
