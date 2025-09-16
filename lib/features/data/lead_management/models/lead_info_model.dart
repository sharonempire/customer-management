import 'dart:convert';

class LeadInfoModel {
  final int? id;
  final DateTime? createdAt;
  final BasicInfo? basicInfo;
  final List<EducationInfo>? education;
  final List<WorkExperience>? workExperience;
  final BudgetInfo? budgetInfo;
  final Preferences? preferences;
  final EnglishProficiency? englishProficiency;

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

  LeadInfoModel copyWith({
    int? id,
    DateTime? createdAt,
    BasicInfo? basicInfo,
    List<EducationInfo>? education,
    List<WorkExperience>? workExperience,
    BudgetInfo? budgetInfo,
    Preferences? preferences,
    EnglishProficiency? englishProficiency,
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

  factory LeadInfoModel.fromJson(Map<String, dynamic> json) {
    // decode helpers
    final basicMap = _ensureMap(json['basic_info']);
    final educationList = _ensureList(json['education']);
    final workList = _ensureList(json['work_expierience']); // keep DB spelled name
    final budgetMap = _ensureMap(json['budget_info']);
    final prefMap = _ensureMap(json['preferences']);
    final englishMap = _ensureMap(json['english_proficiency']);

    return LeadInfoModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      basicInfo: basicMap != null ? BasicInfo.fromJson(basicMap) : null,
      education: educationList
          ?.map((e) => EducationInfo.fromJson(e))
          .toList(),
      workExperience: workList
          ?.map((e) => WorkExperience.fromJson(e))
          .toList(),
      budgetInfo: budgetMap != null ? BudgetInfo.fromJson(budgetMap) : null,
      preferences: prefMap != null ? Preferences.fromJson(prefMap) : null,
      englishProficiency: englishMap != null
          ? EnglishProficiency.fromJson(englishMap)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'basic_info': basicInfo?.toJson(),
      'education': education?.map((e) => e.toJson()).toList(),
      'work_expierience': workExperience?.map((e) => e.toJson()).toList(),
      'budget_info': budgetInfo?.toJson(),
      'preferences': preferences?.toJson(),
      'english_proficiency': englishProficiency?.toJson(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

Map<String, dynamic>? _ensureMap(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    try {
      return Map<String, dynamic>.from(value);
    } catch (_) {
      return null;
    }
  }
  if (value is String) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return null;
}

List<Map<String, dynamic>>? _ensureList(dynamic value) {
  if (value == null) return null;

  // Already a List
  if (value is List) {
    final out = <Map<String, dynamic>>[];
    for (final e in value) {
      if (e is Map) {
        try {
          out.add(Map<String, dynamic>.from(e));
        } catch (_) {}
      } else if (e is String) {
        try {
          final dec = jsonDecode(e);
          if (dec is Map) out.add(Map<String, dynamic>.from(dec));
        } catch (_) {}
      }
    }
    return out.isEmpty ? null : out;
  }

  // A single Map instance
  if (value is Map) {
    try {
      return [Map<String, dynamic>.from(value)];
    } catch (_) {
      return null;
    }
  }

  // A JSON string containing a list or map
  if (value is String) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        final out = <Map<String, dynamic>>[];
        for (final e in decoded) {
          if (e is Map) {
            out.add(Map<String, dynamic>.from(e));
          }
        }
        return out.isEmpty ? null : out;
      } else if (decoded is Map) {
        return [Map<String, dynamic>.from(decoded)];
      }
    } catch (_) {}
  }

  return null;
}

/// ------------------ BASIC INFO ------------------
class BasicInfo {
  final String? firstName;
  final String? secondName;
  final String? gender;
  final String? maritalStatus;
  final String? dateOfBirth;

  BasicInfo({
    this.firstName,
    this.secondName,
    this.gender,
    this.maritalStatus,
    this.dateOfBirth,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      firstName: json['first_name']?.toString(),
      secondName: json['second_name']?.toString(),
      gender: json['gender']?.toString(),
      maritalStatus: json['marital_status']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'second_name': secondName,
      'gender': gender,
      'marital_status': maritalStatus,
      'date_of_birth': dateOfBirth,
    };
  }
}

/// ------------------ EDUCATION INFO ------------------
class EducationInfo {
  // school/12th fields
  final String? board;
  final String? stream;
  final String? passoutYear;
  final Map<String, dynamic>? subjects; // e.g. { "Physics": "85", ... }

  // degree fields (if any)
  final String? discipline;
  final String? specialization;
  final String? percentage;
  final String? noOfBacklogs;
  final String? typeOfStudy;
  final String? duration;
  final String? joinDate;
  final String? passoutDate;

  EducationInfo({
    this.board,
    this.stream,
    this.passoutYear,
    this.subjects,
    this.discipline,
    this.specialization,
    this.percentage,
    this.noOfBacklogs,
    this.typeOfStudy,
    this.duration,
    this.joinDate,
    this.passoutDate,
  });

  factory EducationInfo.fromJson(Map<String, dynamic> json) {
    // subjects might be Map or JSON string
    final subj = _ensureMap(json['subjects']);
    return EducationInfo(
      board: json['board']?.toString(),
      stream: json['stream']?.toString(),
      passoutYear: json['passout_year']?.toString(),
      subjects: subj,
      discipline: json['discipline']?.toString(),
      specialization: json['specialization']?.toString(),
      percentage: json['percentage']?.toString(),
      noOfBacklogs: json['no_of_backlogs']?.toString(),
      typeOfStudy: json['type_of_study']?.toString(),
      duration: json['duration']?.toString(),
      joinDate: json['join_date']?.toString(),
      passoutDate: json['passout_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'board': board,
      'stream': stream,
      'passout_year': passoutYear,
      'subjects': subjects,
      'discipline': discipline,
      'specialization': specialization,
      'percentage': percentage,
      'no_of_backlogs': noOfBacklogs,
      'type_of_study': typeOfStudy,
      'duration': duration,
      'join_date': joinDate,
      'passout_date': passoutDate,
    };
  }
}

/// ------------------ WORK EXPERIENCE ------------------
class WorkExperience {
  final String? companyName;
  final String? designation;
  final String? jobType;
  final String? location;
  final String? dateOfJoining;
  final String? dateOfRelieving;
  final String? companyAddress;
  final String? description;
  final bool? isCurrentlyWorking;

  WorkExperience({
    this.companyName,
    this.designation,
    this.jobType,
    this.location,
    this.dateOfJoining,
    this.dateOfRelieving,
    this.companyAddress,
    this.description,
    this.isCurrentlyWorking,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      companyName: json['company_name']?.toString(),
      designation: json['designation']?.toString(),
      jobType: json['job_type']?.toString(),
      location: json['location']?.toString(),
      dateOfJoining: json['date_of_joining']?.toString(),
      dateOfRelieving: json['date_of_relieving']?.toString(),
      companyAddress: json['company_address']?.toString(),
      description: json['description']?.toString(),
      isCurrentlyWorking: json['is_currently_working'] is bool
          ? json['is_currently_working'] as bool
          : (json['is_currently_working'] != null
              ? json['is_currently_working'].toString().toLowerCase() == 'true'
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'designation': designation,
      'job_type': jobType,
      'location': location,
      'date_of_joining': dateOfJoining,
      'date_of_relieving': dateOfRelieving,
      'company_address': companyAddress,
      'description': description,
      'is_currently_working': isCurrentlyWorking,
    };
  }
}

/// ------------------ BUDGET INFO ------------------
class BudgetInfo {
  final bool? selfFunding;
  final bool? homeLoan;
  final bool? both;
  final double? budgetAmount;

  BudgetInfo({this.selfFunding, this.homeLoan, this.both, this.budgetAmount});

  factory BudgetInfo.fromJson(Map<String, dynamic> json) {
    bool? _bool(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      return v.toString().toLowerCase() == 'true';
    }

    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return BudgetInfo(
      selfFunding: _bool(json['self_funding']),
      homeLoan: _bool(json['home_loan']),
      both: _bool(json['both']),
      budgetAmount: _toDouble(json['budget_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self_funding': selfFunding,
      'home_loan': homeLoan,
      'both': both,
      'budget_amount': budgetAmount,
    };
  }
}

/// ------------------ PREFERENCES ------------------
class Preferences {
  final String? country;
  final String? interestedIndustry;
  final String? interestedCourse;
  final String? interestedUniversity;
  final String? preferredState;

  Preferences({
    this.country,
    this.interestedIndustry,
    this.interestedCourse,
    this.interestedUniversity,
    this.preferredState,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      country: json['country']?.toString(),
      interestedIndustry: json['interested_industry']?.toString(),
      interestedCourse: json['interested_course']?.toString(),
      interestedUniversity: json['interested_university']?.toString(),
      preferredState: json['preferred_state']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'interested_industry': interestedIndustry,
      'interested_course': interestedCourse,
      'interested_university': interestedUniversity,
      'preferred_state': preferredState,
    };
  }
}

/// ------------------ ENGLISH PROFICIENCY ------------------
/// Example JSON shape:
/// { "IELTS": ["Listening","Reading","Writing","Speaking"], "Duolingo": ["Overall Score"] }
class EnglishProficiency {
  final Map<String, List<String>> tests;

  EnglishProficiency({required this.tests});

  factory EnglishProficiency.fromJson(Map<String, dynamic> json) {
    final out = <String, List<String>>{};
    json.forEach((key, value) {
      if (value is List) {
        out[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        // maybe stored as JSON string for array
        try {
          final dec = jsonDecode(value);
          if (dec is List) out[key] = dec.map((e) => e.toString()).toList();
        } catch (_) {
          out[key] = [value];
        }
      } else {
        out[key] = [value.toString()];
      }
    });
    return EnglishProficiency(tests: out);
  }

  Map<String, dynamic> toJson() {
    return tests.map((k, v) => MapEntry(k, v));
  }
}
