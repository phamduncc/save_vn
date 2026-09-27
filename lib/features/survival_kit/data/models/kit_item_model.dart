class KitItemModel {
  final String id;
  final String category;
  final String title;
  final String description;
  final bool isEssential;
  final bool isChecked;

  const KitItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.isEssential,
    this.isChecked = false,
  });

  factory KitItemModel.fromJson(Map<String, dynamic> json, {bool isChecked = false}) {
    return KitItemModel(
      id: json['id'] as String,
      category: json['category'] as String? ?? 'Khác',
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isEssential: json['isEssential'] as bool? ?? true,
      isChecked: isChecked,
    );
  }

  KitItemModel copyWith({bool? isChecked}) {
    return KitItemModel(
      id: id,
      category: category,
      title: title,
      description: description,
      isEssential: isEssential,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
