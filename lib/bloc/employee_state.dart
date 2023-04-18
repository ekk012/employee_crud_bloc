

import 'package:equatable/equatable.dart';

import '../model/employee_model.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitialState extends EmployeeState {}

class DisplayEmployees extends EmployeeState {
  final List<Employee> currentEmployees;
  final List<Employee> pastEmployees;

  const DisplayEmployees({
    required this.currentEmployees,
    required this.pastEmployees,
  });

  @override
  List<Object> get props => [currentEmployees, pastEmployees];
}

class EmployeeLoadingState extends EmployeeState {}

class DisplaySpecificEmployee extends EmployeeState {
  final Employee employee;

  const DisplaySpecificEmployee({required this.employee});

  @override
  List<Object> get props => [employee];
}

class EmployeeErrorState extends EmployeeState {
  final String errorMessage;

  const EmployeeErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
