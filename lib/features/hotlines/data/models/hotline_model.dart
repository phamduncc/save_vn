class HotlineModel {
  final String number;
  final String? display;
  final String name;
  final String category;
  final String description;
  final bool isPrimary;

  const HotlineModel({
    required this.number,
    this.display,
    required this.name,
    required this.category,
    required this.description,
    this.isPrimary = false,
  });

  factory HotlineModel.fromJson(Map<String, dynamic> json) {
    return HotlineModel(
      number: json['number'] as String,
      display: json['display'] as String?,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'Khẩn cấp',
      description: json['description'] as String? ?? '',
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }
}
