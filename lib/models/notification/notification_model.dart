class JobDetails {
  final String employerId;
  final String providerId;
  final String employerImage;
  final String providerImage;
  final String employerName;
  final String providerName;
  final String jobTitle;
  final double pay;
  final int duration;
  final DateTime startTime;
  final double latitude;
  final double longitude;
  final String vvid;

  JobDetails({
    required this.employerId,
    required this.providerId,
    required this.employerImage,
    required this.providerImage,
    required this.employerName,
    required this.providerName,
    required this.jobTitle,
    required this.pay,
    required this.duration,
    required this.startTime,
    required this.latitude,
    required this.longitude,
    required this.vvid
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      employerId: json['employerId'],
      providerId: json['providerId'],
      employerImage: json['employerImage'],
      providerImage: json['providerImage'],
      employerName: json['employerName'],
      providerName: json['providerName'],
      jobTitle: json['jobTitle'],
      pay: (json['pay'] ?? 0).toDouble(),
      duration: json['duration'],
      startTime: DateTime.parse(json['startTime']),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      vvid: json['vvid'],
    );
  }
}

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final JobDetails? jobDetails;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.jobDetails,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      type: json['type'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      jobDetails: json['job_details'] != null
          ? JobDetails.fromJson(json['job_details'])
          : null,
    );
  }
}
