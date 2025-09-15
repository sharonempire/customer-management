import 'dart:convert';

class LeadInfoModel {
  final int id;
  final DateTime createdAt;
  final Map<String, dynamic>? basicInfo;
  final Map<String, dynamic>? education;
  final Map<String, dynamic>? workExperience;
  final Map<String, dynamic>? budgetInfo;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? englishProficiency;

  const LeadInfoModel({
    required this.id,
    required this.createdAt,
    this.basicInfo,
    this.education,
    this.workExperience,
    this.budgetInfo,
    this.preferences,
    this.englishProficiency,
  });

  /// CopyWith for immutability
  LeadInfoModel copyWith({
    int? id,
    DateTime? createdAt,
    Map<String, dynamic>? basicInfo,
    Map<String, dynamic>? education,
    Map<String, dynamic>? workExperience,
    Map<String, dynamic>? budgetInfo,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? englishProficiency,
  }) {
    return LeadInfoModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      basicInfo: basicInfo ?? this.basicInfo,
      education: education ?? this.education,
      workExperience: workExperience ?? this.workExperience,
      budgetInfo: budgetInfo ?? this.budgetInfo,
      preferences: preferences ?? this.preferences,
      englishProficiency: englishProficiency ?? this.englishProficiency,
    );
  }

  /// JSON → LeadInfoModel
  factory LeadInfoModel.fromJson(Map<String, dynamic> json) {
    return LeadInfoModel(
      id: json['id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      basicInfo: jsonDecodeIfExists(json['basic_info']),
      education: jsonDecodeIfExists(json['education']),
      workExperience: jsonDecodeIfExists(json['work_experience']),
      budgetInfo: jsonDecodeIfExists(json['budget_info']),
      preferences: jsonDecodeIfExists(json['preferences']),
      englishProficiency: jsonDecodeIfExists(json['english_proficiency']),
    );
  }

  /// LeadInfoModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'basic_info': basicInfo,
      'education': education,
      'work_experience': workExperience,
      'budget_info': budgetInfo,
      'preferences': preferences,
      'english_proficiency': englishProficiency,
    };
  }

  /// For debugging
  @override
  String toString() => jsonEncode(toJson());

  /// Helper to decode nested JSON safely
  static Map<String, dynamic>? jsonDecodeIfExists(dynamic value) {
    if (value == null) return null;
    if (value is String) return jsonDecode(value);
    if (value is Map<String, dynamic>) return value;
    return null;
  }
}
