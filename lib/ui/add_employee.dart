import 'package:employee_crud/model/employee_model.dart';
import 'package:employee_crud/ui/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../constants/colors.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
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
  void initState() {
    var date = DateTime.now();
    _fromDateController.text = DateFormat.yMMMMd().format(date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee Details'),
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
                prefixIcon:
                Icon(Icons.person_outline, color:blue),
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
              readOnly: true,
              keyboardType: TextInputType.none,
              showCursor: true,
              controller: _roleController,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                prefixIcon:
                    const Icon(Icons.work_outline_rounded, color: Colors.blue),
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
                            firstDate = await showDatePicker(
                                cancelText: 'Cancel',
                                confirmText: 'Save',
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            _fromDateController.text =
                                DateFormat.yMMMMd().format(firstDate!);
                            // _toDateController.text = date.toString();
                          },
                          child: const Icon(
                            Icons.event,
                            color: Colors.blue,
                          )),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1),
                        ),
                      ),
                      //  icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Today" //label text of field
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
                  controller: _toDateController,
                  decoration: InputDecoration(
                      prefixIcon: GestureDetector(
                          onTap: () async {
                            if (firstDate != null ||
                                _fromDateController.text.isNotEmpty) {
                              DateTime? secondDate = await showDatePicker(
                                  currentDate: DateTime.now(),
                                  cancelText: 'Cancel',
                                  confirmText: 'Save',
                                  context: context,
                                  initialDate: (firstDate != null)
                                      ? firstDate!.add(const Duration(days: 1))
                                      : DateTime.now().add(const Duration(hours: 24)),
                                  firstDate: (firstDate != null)
                                      ? firstDate!.add(const Duration(days: 1))
                                      : DateTime.now().add(const Duration(hours: 24)),
                                  lastDate: DateTime(2025));
                              _toDateController.text =
                                  DateFormat.yMMMMd().format(secondDate!);
                            }
                          },
                          child: Icon(
                            Icons.event,
                            color: blue,
                          )),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1),
                        ),
                      ),
                      //  icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "No Date" //label text of field
                      ),
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
                  color: lightBlue,
                  onPressed: () {
                    _nameController.text = '';
                    _roleController.text = '';
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // <-- Radius
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: blue, fontSize: 14, fontFamily: 'Roboto'),
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
                        _validatefromDate == false) {
                      var employee = Employee();
                      employee.name = _nameController.text;
                      employee.role = _roleController.text;
                      employee.fromDate = _fromDateController.text;
                      employee.toDate = _toDateController.text;
                      // var result =
                      //     await _employeeService.saveEmployee(_employee);
                      context.read<EmployeeBloc>().add(AddEmployee(employee));

                      await Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const EmployeeListPage(),
                          ),
                          (Route route) => false);
                    }
                  },
                  color: blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // <-- Radius
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Roboto'),
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
