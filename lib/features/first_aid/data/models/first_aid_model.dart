class FirstAidModel {
  final String id;
  final String title;
  final String icon;
  final String category;
  final String goldenTime;
  final String summary;
  final List<String> steps;
  final List<String> cautions;

  const FirstAidModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.category,
    required this.goldenTime,
    required this.summary,
    required this.steps,
    required this.cautions,
  });

  factory FirstAidModel.fromJson(Map<String, dynamic> json) {
    return FirstAidModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      category: json['category'] as String? ?? 'First aid',
      goldenTime: json['goldenTime'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      cautions: (json['cautions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
