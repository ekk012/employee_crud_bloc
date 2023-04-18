

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employee_crud/bloc/employee_event.dart';
import '../model/employee_model.dart';
import '../services/EmployeeService.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeService employeeService;
  final List<Employee> _currentEmployees = [];
  final List<Employee> _pastEmployees = [];

  EmployeeBloc({required this.employeeService})
      : super(EmployeeInitialState()) {
    on<LoadEmployees>((event, emit) async {
      try {
        final employees = await employeeService.readAllEmployees();
        _currentEmployees.clear();
        _pastEmployees.clear();
        for (var e in employees) {
          var employeeModel = Employee();
          employeeModel.id = e['id'];
          employeeModel.name = e['name'];
          employeeModel.role = e['role'];
          employeeModel.fromDate = e['fromDate'];
          employeeModel.toDate = e['toDate'];
          if (employeeModel.toDate == '') {
            _currentEmployees.add(employeeModel);
          } else {
            _pastEmployees.add(employeeModel);
          }
        }
        emit(DisplayEmployees(
            currentEmployees: _currentEmployees,
            pastEmployees: _pastEmployees));
      } catch (e) {
        emit(EmployeeErrorState(errorMessage: e.toString()));
      }
    });

    on<EmployeeInitialEvent>((event, emit) async {
      emit(EmployeeLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      try {
        final employees = await employeeService.readAllEmployees();
        _currentEmployees.clear();
        _pastEmployees.clear();
        for (var e in employees) {
          var employeeModel = Employee();
          employeeModel.id = e['id'];
          employeeModel.name = e['name'];
          employeeModel.role = e['role'];
          employeeModel.fromDate = e['fromDate'];
          employeeModel.toDate = e['toDate'];
          if (employeeModel.toDate == '') {
            _currentEmployees.add(employeeModel);
          } else {
            _pastEmployees.add(employeeModel);
          }
        }
        emit(DisplayEmployees(
            currentEmployees: _currentEmployees,
            pastEmployees: _pastEmployees));
      } catch (e) {
        emit(EmployeeErrorState(errorMessage: e.toString()));
      }
    });

    on<AddEmployee>((event, emit) async {
      try {
        await employeeService.saveEmployee(event.employee);
        add(const LoadEmployees());
      } catch (e) {
        emit(EmployeeErrorState(errorMessage: e.toString()));
      }
    });

    on<UpdateEmployee>((event, emit) async {
      try {
        await employeeService.updateEmployee(event.employee);
        add(const LoadEmployees());
      } catch (e) {
        emit(EmployeeErrorState(errorMessage: e.toString()));
      }
    });

    on<DeleteEmployee>((event, emit) async {
      try {
        await employeeService.deleteEmployee(event.employeeId);
        add(const LoadEmployees());
      } catch (e) {
        emit(EmployeeErrorState(errorMessage: e.toString()));
      }
    });
  }
}
