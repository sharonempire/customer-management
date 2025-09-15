import 'dart:convert';

class LeadInfoModel {
  final int? id;
  final DateTime? createdAt;
  final Map<String, dynamic>? basicInfo;
  final Map<String, dynamic>? education;
  final Map<String, dynamic>? workExperience;
  final Map<String, dynamic>? budgetInfo;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? englishProficiency;

  const LeadInfoModel({
    this.id,
    this.createdAt,
    this.basicInfo,
    this.education,
    this.workExperience,
    this.budgetInfo,
    this.preferences,
    this.englishProficiency,
  });

  /// copyWith - clone with modifications
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
      id: json['id'] as int?,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      basicInfo: _decodeJson(json['basic_info']),
      education: _decodeJson(json['education']),
      workExperience: _decodeJson(
        json['work_expierience'],
      ), // fix spelling mismatch
      budgetInfo: _decodeJson(json['budget_info']),
      preferences: _decodeJson(json['preferences']),
      englishProficiency: _decodeJson(json['english_proficiency']),
    );
  }

  /// LeadInfoModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'basic_info': basicInfo,
      'education': education,
      'work_expierience': workExperience, // keep column name same as table
      'budget_info': budgetInfo,
      'preferences': preferences,
      'english_proficiency': englishProficiency,
    };
  }

  @override
  String toString() => jsonEncode(toJson());

  /// Safe JSON decode
  static Map<String, dynamic>? _decodeJson(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return jsonDecode(value) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    if (value is Map<String, dynamic>) return value;
    return null;
  }
}
