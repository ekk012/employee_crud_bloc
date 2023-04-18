class Employee {
  int? id;
  String? name;
  String? role;
  String? fromDate;
  String? toDate;

  employeeMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name!;
    mapping['role'] = role!;
    mapping['fromDate'] = fromDate!;
    mapping['toDate'] = toDate!;
    return mapping;
  }
}
