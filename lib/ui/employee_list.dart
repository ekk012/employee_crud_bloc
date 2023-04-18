import 'package:employee_crud/constants/colors.dart';
import 'package:employee_crud/model/employee_model.dart';
import 'package:employee_crud/ui/add_employee.dart';
import 'package:employee_crud/ui/employee_details.dart';
import 'package:employee_crud/services/EmployeeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../constants/constants.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  late final List<Employee> _employeeList = <Employee>[];
  late final List<Employee> _employeePastList = <Employee>[];

  final _employeeService = EmployeeService();
  getAllEmployeeDetails() async {
    var employees = await _employeeService.readAllEmployees();
    employees.forEach((e) {
      setState(() {
        var employeeModel = Employee();
        employeeModel.id = e['id'];
        employeeModel.name = e['name'];
        employeeModel.role = e['role'];
        employeeModel.fromDate = e['fromDate'];
        employeeModel.toDate = e['toDate'];
        if (employeeModel.toDate != '') {
          _employeePastList.add(employeeModel);
        } else {
          _employeeList.add(employeeModel);
        }
      });
    });
  }

  @override
  void initState() {
    // getAllEmployeeDetails();

    super.initState();
    context.read<EmployeeBloc>().add(EmployeeInitialEvent());
    // context.read<EmployeeBloc>().add(const LoadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[290],
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is DisplayEmployees) {
            final employeeList = state.currentEmployees;
            final employeePastList = state.pastEmployees;

            return (employeeList.isEmpty && employeePastList.isEmpty)
                ? Center(
                    child: Image(image: AssetImage(BackgroundImage)),
                  )
                : Column(children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Text(
                        'Current Employees',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            color: blue),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: employeeList.length,
                      itemBuilder: ((context, index) {
                        final employee = employeeList[index];

                        return Dismissible(
                            background: Container(),
                            key: Key(employee.id.toString()),
                            direction: DismissDirection.endToStart,
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(
                                      Icons.delete_outlined,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onDismissed: (direction) async {
                              setState(() {
                                employeeList.removeAt(index);
                              });
                              final deletedEmployee = employee;
                              await _employeeService
                                  .deleteEmployee(deletedEmployee.id);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Employee data has been deleted'),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      setState(() {
                                        employeeList.insert(
                                            index, deletedEmployee);
                                      });
                                      _employeeService
                                          .saveEmployee(deletedEmployee);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    height:
                                        MediaQuery.of(context).size.height / 7,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditEmployee(
                                              employee: employee,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            employee.name!,
                                            style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            employee.role!,
                                            style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text("From ${employee.fromDate}",
                                              style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                          const Flexible(
                                              child: Divider(
                                            thickness: 1,
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      }),
                    )),
                    Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Text(
                          'Previous Employees',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              color: blue),
                        )),
                    Expanded(
                      child: ListView.builder(
                          itemCount: employeePastList.length,
                          itemBuilder: ((context, index) {
                            final employee = employeePastList[index];
                            return Dismissible(
                              key: Key(employee.id.toString()),
                              direction: DismissDirection.endToStart,
                              secondaryBackground: Container(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(
                                        Icons.delete_outlined,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              background: Container(),
                              onDismissed: (direction) async {
                                setState(() {
                                  employeePastList.removeAt(index);
                                });
                                final deletedEmployee = employee;
                                context
                                    .read<EmployeeBloc>()
                                    .add(DeleteEmployee(deletedEmployee.id!));
                                // await _employeeService
                                //     .deleteEmployee(deletedEmployee.id);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      'Employee data has been deleted'),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      setState(() {
                                        employeePastList.insert(
                                            index, deletedEmployee);
                                      });
                                      context
                                          .read<EmployeeBloc>()
                                          .add(AddEmployee(deletedEmployee));
                                      // _employeeService
                                      //     .saveEmployee(deletedEmployee);
                                    },
                                  ),
                                ));
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              7,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditEmployee(
                                                employee: employee,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              employee.name!,
                                              style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              employee.role!,
                                              style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              "${employee.fromDate} - ${employee.toDate}",
                                              style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            const Flexible(
                                                child: Divider(
                                              thickness: 1,
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 8,
                      padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Text(
                        'Swipe left to delete',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            color: Colors.grey[600]),
                      ),
                    )
                  ]);
          } else if (state is EmployeeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeErrorState) {
            return const Center(child: Text(' Error !'));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEmployeePage()));
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
