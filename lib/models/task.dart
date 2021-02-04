class Task {
  final String taskId;
  final String byWhen;
  final bool isComplete;
  final String issuedBy;
  final String issuedByName;
  final String issuedByPhoneNumber;
  final String issuedByAddress;
  final String task;
  final String taskType;
  final String volunteer;
  final bool acknowledged;

  Task(
      {this.taskId,
      this.byWhen,
      this.isComplete,
      this.issuedBy,
      this.issuedByName,
      this.issuedByPhoneNumber,
      this.issuedByAddress,
      this.task,
      this.taskType,
      this.volunteer,
      this.acknowledged});
}
