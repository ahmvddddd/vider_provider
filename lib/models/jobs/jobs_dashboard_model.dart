class ProviderDashboard {
  final int totalJobs;
  final double totalCreditedEarnings;
  final double averageDuration;
  final List<JobStatusBreakdown> statusBreakdown;
  final List<EarningsByDay> earningsByDay;
  final List<TopEmployer> topEmployers;

  ProviderDashboard({
    required this.totalJobs,
    required this.totalCreditedEarnings,
    required this.averageDuration,
    required this.statusBreakdown,
    required this.earningsByDay,
    required this.topEmployers,
  });

  factory ProviderDashboard.fromJson(Map<String, dynamic> json) {
    return ProviderDashboard(
      totalJobs: json['totalJobs'],
      totalCreditedEarnings:
          (json['totalCreditedEarnings'] as num).toDouble(),
      averageDuration: (json['averageDuration'] as num).toDouble(),
      statusBreakdown: (json['statusBreakdown'] as List)
          .map((e) => JobStatusBreakdown.fromJson(e))
          .toList(),
      earningsByDay: (json['earningsByDay'] as List)
          .map((e) => EarningsByDay.fromJson(e))
          .toList(),
      topEmployers: (json['topEmployers'] as List)
          .map((e) => TopEmployer.fromJson(e))
          .toList(),
    );
  }
}

class JobStatusBreakdown {
  final String status;
  final int count;

  JobStatusBreakdown({required this.status, required this.count});

  factory JobStatusBreakdown.fromJson(Map<String, dynamic> json) {
    return JobStatusBreakdown(
      status: json['_id'],
      count: json['count'],
    );
  }
}

class EarningsByDay {
  final String date; // format: "YYYY-MM-DD"
  final double totalEarnings;
  final int count;

  EarningsByDay({
    required this.date,
    required this.totalEarnings,
    required this.count,
  });

  factory EarningsByDay.fromJson(Map<String, dynamic> json) {
    return EarningsByDay(
      date: json['date'],
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      count: json['count'],
    );
  }
}

class TopEmployer {
  final String employerName;
  final String employerImage;
  final double totalPaid;
  final int totalJobs;
  final List<EmployerJob> jobs;

  TopEmployer({
    required this.employerName,
    required this.employerImage,
    required this.totalPaid,
    required this.totalJobs,
    required this.jobs,
  });

  factory TopEmployer.fromJson(Map<String, dynamic> json) {
    return TopEmployer(
      employerName: json['employerName'],
      employerImage: json['employerImage'],
      totalPaid: (json['totalPaid'] as num).toDouble(),
      totalJobs: json['totalJobs'],
      jobs: (json['jobs'] as List)
          .map((e) => EmployerJob.fromJson(e))
          .toList(),
    );
  }
}

class EmployerJob {
  final String jobTitle;
  final DateTime startTime;
  final double pay;

  EmployerJob({
    required this.jobTitle,
    required this.startTime,
    required this.pay,
  });

  factory EmployerJob.fromJson(Map<String, dynamic> json) {
    return EmployerJob(
      jobTitle: json['jobTitle'],
      startTime: DateTime.parse(json['startTime']),
      pay: (json['pay'] as num).toDouble(),
    );
  }
}
