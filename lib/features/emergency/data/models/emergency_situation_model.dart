class EmergencySituationModel {
  final String id;
  final String title;
  final String icon;
  final String severity;
  final String callNumber;
  final String quickSummary;
  final List<String> steps;

  const EmergencySituationModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.severity,
    required this.callNumber,
    required this.quickSummary,
    required this.steps,
  });

  factory EmergencySituationModel.fromJson(Map<String, dynamic> json) {
    return EmergencySituationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      severity: json['severity'] as String? ?? 'HIGH',
      callNumber: json['callNumber'] as String? ?? '112',
      quickSummary: json['quickSummary'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'severity': severity,
      'callNumber': callNumber,
      'quickSummary': quickSummary,
      'steps': steps,
    };
  }
}
