import 'package:employee_crud/bloc/employee_bloc.dart';
import 'package:employee_crud/services/EmployeeService.dart';

import 'package:employee_crud/ui/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final EmployeeService employeeService = EmployeeService();
  runApp(MyApp(employeeService: employeeService));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.employeeService}) : super(key: key);

  final EmployeeService employeeService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc(employeeService: employeeService),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const EmployeeListPage(),
      ),
    );
  }
}
