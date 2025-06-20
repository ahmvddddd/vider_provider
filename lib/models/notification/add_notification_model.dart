// class AddNotificationRequest {
//   final String type;
//   final String title;
//   final String message;

//   AddNotificationRequest({
//     required this.type,
//     required this.title,
//     required this.message,
//   });

//   Map<String, dynamic> toJson() => {
//         'type': type,
//         'title': title,
//         'message': message,
//       };
// }

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
  });

  Map<String, dynamic> toJson() {
    return {
      'employerId': employerId,
      'providerId': providerId,
      'employerImage': employerImage,
      'providerImage': providerImage,
      'employerName': employerName,
      'providerName': providerName,
      'jobTitle': jobTitle,
      'pay': pay,
      'duration': duration,
      'startTime': startTime.toIso8601String(),
    };
  }
}

class AddNotificationModel {
  final String type;
  final String title;
  final String message;
  final String recipientId;
  final JobDetails? jobDetails;

  AddNotificationModel({
    required this.type,
    required this.title,
    required this.message,
    required this.recipientId,
    this.jobDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'message': message,
      'recipientId': recipientId,
      if (jobDetails != null) 'job_details': jobDetails!.toJson(),
    };
  }
}
