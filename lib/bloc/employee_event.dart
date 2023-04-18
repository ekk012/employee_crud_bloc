import 'package:equatable/equatable.dart';

import '../model/employee_model.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeInitialEvent extends EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {
  const LoadEmployees();

  @override
  List<Object?> get props => [];
}

class LoadSpecificEmployee extends EmployeeEvent {
  final int id;

  const LoadSpecificEmployee({required this.id});

  @override
  List<Object?> get props => [id];
}

class AddEmployee extends EmployeeEvent {
  final Employee employee;

  const AddEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;

  const UpdateEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class DeleteEmployee extends EmployeeEvent {
  final int employeeId;

  const DeleteEmployee(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class LoadCurrentEmployees extends EmployeeEvent {
  const LoadCurrentEmployees();

  @override
  List<Object?> get props => [];
}

class LoadPastEmployees extends EmployeeEvent {
  const LoadPastEmployees();

  @override
  List<Object?> get props => [];
}
