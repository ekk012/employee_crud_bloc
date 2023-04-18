
import '../repository/repository.dart';
import '../model/employee_model.dart';

class EmployeeService {
  late Repository _repository;
  EmployeeService() {
    _repository = Repository();
  }
  //Save Employee
  saveEmployee(Employee employee) async {
   // print(employee.employeeMap());
    return await _repository.insertData('employees', employee.employeeMap());
  }

  //Read All Employees
  readAllEmployees() async {
    return await _repository.readData('employees');
  }

  //Edit Employee
  updateEmployee(Employee employee) async {
    return await _repository.updateData('employees', employee.employeeMap());
  }

  deleteEmployee(employeeId) async {
    return await _repository.deleteDataById('employees', employeeId);
  }
}
