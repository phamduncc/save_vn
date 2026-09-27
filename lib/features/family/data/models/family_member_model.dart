class FamilyMemberModel {
  final String id;
  final String name;
  final String relation;
  final String phone;
  final String bloodType;
  final String medicalNotes;

  const FamilyMemberModel({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
    this.bloodType = '',
    this.medicalNotes = '',
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      relation: json['relation'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      bloodType: json['bloodType'] as String? ?? '',
      medicalNotes: json['medicalNotes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'phone': phone,
      'bloodType': bloodType,
      'medicalNotes': medicalNotes,
    };
  }
}
