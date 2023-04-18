import 'package:employee_crud/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../constants/colors.dart';
import 'employee_list.dart';

class EditEmployee extends StatefulWidget {
  final Employee employee;
  const EditEmployee({super.key, required this.employee});

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  void updateControllers() {
    _nameController.text = widget.employee.name!;
    _roleController.text = widget.employee.role!;
    _fromDateController.text = widget.employee.fromDate!;
    _toDateController.text = widget.employee.toDate!;
  }

  @override
  void initState() {
    updateControllers();
    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  bool _validateName = false;
  bool _validateRole = false;
  bool _validatefromDate = false;
  bool _validatetoDate = false;
  final TextEditingController _roleController = TextEditingController();
  DateTime? firstDate;
  DateTime? secondDate;

  final items = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee Details'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
            onPressed: () async {
              context
                  .read<EmployeeBloc>()
                  .add(DeleteEmployee(widget.employee.id!));

              await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const EmployeeListPage(),
                  ),
                  (Route route) => false);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 23,
            ),
            TextField(
              controller: _nameController,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                prefixIcon: Icon(Icons.person_outline, color: blue),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(1),
                  ),
                ),
                hintText: 'Name',
                errorText: _validateName ? 'Name Value Can\'t Be Empty' : null,
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            TextField(
              controller: _roleController,
              readOnly: true,
              keyboardType: TextInputType.none,
              showCursor: true,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                prefixIcon: const Icon(Icons.work_outline, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    openBottomPicker();
                  },
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(1),
                  ),
                ),
                hintText: 'Select role',
                errorText: _validateRole ? 'Role Can\'t Be Empty' : null,
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextField(
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  controller: _fromDateController,
                  decoration: InputDecoration(
                      prefixIcon: GestureDetector(
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                                cancelText: 'Cancel',
                                confirmText: 'Save',
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025));
                            _fromDateController.text =
                                DateFormat.yMMMMd().format(date!);
                            // _toDateController.text = date.toString();
                          },
                          child: const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          )),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1),
                        ),
                      ),
                      //  icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "" //label text of field
                      //label text of field
                      ),
                  readOnly: true,
                )),
                const SizedBox(
                  width: 13,
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 13,
                ),
                Expanded(
                    child: TextField(
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  showCursor: true,
                  controller: _toDateController,
                  decoration: InputDecoration(
                      prefixIcon: GestureDetector(
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025));
                            _toDateController.text =
                                DateFormat.yMMMMd().format(date!);
                          },
                          child: const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          )),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1),
                        ),
                      ),
                      labelText: "No Date"),
                  readOnly: true,
                )),
              ],
            ),
            const Spacer(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  color: Colors.lightBlue[100],
                  onPressed: () {},
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue[500]),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      _nameController.text.isEmpty
                          ? _validateName = true
                          : _validateName = false;
                      _roleController.text.isEmpty
                          ? _validateRole = true
                          : _validateRole = false;
                      _fromDateController.text.isEmpty
                          ? _validatefromDate = true
                          : _validatefromDate = false;
                      _toDateController.text.isEmpty
                          ? _validatetoDate = true
                          : _validatetoDate = false;
                    });

                    if (_validateName == false &&
                        _validateRole == false &&
                        _validatefromDate == false &&
                        _validatetoDate == false) {
                      var employee = Employee();
                      employee.id = widget.employee.id;
                      employee.name = _nameController.text;
                      employee.role = _roleController.text;
                      employee.fromDate = _fromDateController.text;
                      employee.toDate = _toDateController.text;
                      context
                          .read<EmployeeBloc>()
                          .add(UpdateEmployee(employee));

                      // var result =
                      //     await _employeeService.updateEmployee(_employee);
                      await Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const EmployeeListPage(),
                          ),
                          (Route route) => false);
                    }
                  },
                  color: Colors.blue[600],
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.lightBlue[100]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void openBottomPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 200.0,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(items[index]),
                onTap: () {
                  setState(() {
                    _roleController.text = items[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
