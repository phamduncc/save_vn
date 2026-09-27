class DisasterPhases {
  final List<String> before;
  final List<String> during;
  final List<String> after;

  const DisasterPhases({
    required this.before,
    required this.during,
    required this.after,
  });

  factory DisasterPhases.fromJson(Map<String, dynamic> json) {
    return DisasterPhases(
      before: (json['before'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      during: (json['during'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      after: (json['after'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class DisasterModel {
  final String id;
  final String name;
  final String icon;
  final String tag;
  final String color;
  final String summary;
  final DisasterPhases phases;
  final List<String> donts;

  const DisasterModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.tag,
    required this.color,
    required this.summary,
    required this.phases,
    required this.donts,
  });

  factory DisasterModel.fromJson(Map<String, dynamic> json) {
    return DisasterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      tag: json['tag'] as String? ?? 'Thiên tai',
      color: json['color'] as String? ?? '#D32F2F',
      summary: json['summary'] as String? ?? '',
      phases: DisasterPhases.fromJson(json['phases'] as Map<String, dynamic>? ?? {}),
      donts: (json['donts'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
