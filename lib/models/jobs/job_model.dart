class JobModel {
  final String id;
  final String jobTitle;
  final double pay;
  final String status;
  final int duration;
  final DateTime startTime;

  JobModel({
    required this.id,
    required this.jobTitle,
    required this.pay,
    required this.status,
    required this.duration,
    required this.startTime,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'],
      jobTitle: json['jobTitle'],
      pay: json['pay'].toDouble(),
      status: json['status'],
      duration: json['duration'],
      startTime: DateTime.parse(json['createdAt']),
    );
  }
}

