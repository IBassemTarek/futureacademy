class GroupsModel {
  final String groupName;
  final String id;
  final String captainName;
  final String captainNumber;
  final List dates;
  final List studentsID;
  final int department;

  GroupsModel({
    required this.groupName,
    required this.id,
    required this.dates,
    required this.captainNumber,
    required this.captainName,
    required this.studentsID,
    required this.department,
  });
}
