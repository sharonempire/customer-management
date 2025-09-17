import 'dart:convert';

class LeadInfoModel {
   int? id;
   DateTime? createdAt;
   BasicInfo? basicInfo;
   List<EducationInfo>? education;
   List<WorkExperience>? workExperience;
   BudgetInfo? budgetInfo;
   Preferences? preferences;
   EnglishProficiency? englishProficiency;

   LeadInfoModel({
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
      workExperience: workExperience ?? this.workWorkExperienceOrSelf(),
      budgetInfo: budgetInfo ?? this.budgetInfo,
      preferences: preferences ?? this.preferences,
      englishProficiency: englishProficiency ?? this.englishProficiency,
    );
  }

  // small helper used above to avoid analyzer warnings (keeps API same)
  List<WorkExperience>? workWorkExperienceOrSelf() => workExperience;

  factory LeadInfoModel.fromJson(Map<String, dynamic> json) {
    final basicMap = _ensureMap(json['basic_info']);
    final educationList = _ensureList(json['education']);
    final workList = _ensureList(json['work_expierience']); // DB spelled field
    final budgetMap = _ensureMap(json['budget_info']);
    final prefMap = _ensureMap(json['preferences']);
    final englishMap = _ensureMap(json['english_proficiency']);

    return LeadInfoModel(
      id: _toInt(json['id']),
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
      basicInfo: basicMap != null ? BasicInfo.fromJson(basicMap) : null,
      education: educationList?.map((m) => EducationInfo.fromJson(m)).toList(),
      workExperience: workList?.map((m) => WorkExperience.fromJson(m)).toList(),
      budgetInfo: budgetMap != null ? BudgetInfo.fromJson(budgetMap) : null,
      preferences: prefMap != null ? Preferences.fromJson(prefMap) : null,
      englishProficiency:
          englishMap != null ? EnglishProficiency.fromJson(englishMap) : null,
    );
  }

  /// toJson: only include non-null keys
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;
    if (createdAt != null) map['created_at'] = createdAt!.toIso8601String();
    if (basicInfo != null) map['basic_info'] = basicInfo!.toJson();
    if (education != null) {
      map['education'] = education!.map((e) => e.toJson()).toList();
    }
    if (workExperience != null) {
      map['work_expierience'] = workExperience!.map((e) => e.toJson()).toList();
    }
    if (budgetInfo != null) map['budget_info'] = budgetInfo!.toJson();
    if (preferences != null) map['preferences'] = preferences!.toJson();
    if (englishProficiency != null) {
      map['english_proficiency'] = englishProficiency!.toJson();
    }

    return map;
  }

  @override
  String toString() => jsonEncode(toJson());
}

/// ----------------- helpers -----------------
int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

bool? _toBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  final s = v.toString().toLowerCase();
  if (s == 'true') return true;
  if (s == 'false') return false;
  return null;
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

/// Ensure we return Map<String,dynamic>? whether input is Map or JSON string
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

/// Ensure we return a List<Map<String,dynamic>>? from various input shapes
List<Map<String, dynamic>>? _ensureList(dynamic value) {
  if (value == null) return null;

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

  if (value is Map) {
    try {
      return [Map<String, dynamic>.from(value)];
    } catch (_) {
      return null;
    }
  }

  if (value is String) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        final out = <Map<String, dynamic>>[];
        for (final e in decoded) {
          if (e is Map) out.add(Map<String, dynamic>.from(e));
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
   String? firstName;
   String? secondName;
   String? gender;
   String? maritalStatus;
   String? dateOfBirth;
   String? phone;
   String? email;

  BasicInfo({
    this.firstName,
    this.secondName,
    this.gender,
    this.maritalStatus,
    this.dateOfBirth,
    this.email,
    this.phone
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      firstName: json['first_name']?.toString(),
      secondName: json['second_name']?.toString(),
      gender: json['gender']?.toString(),
      maritalStatus: json['marital_status']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (firstName != null) map['first_name'] = firstName;
    if (secondName != null) map['second_name'] = secondName;
    if (gender != null) map['gender'] = gender;
    if (maritalStatus != null) map['marital_status'] = maritalStatus;
    if (dateOfBirth != null) map['date_of_birth'] = dateOfBirth;
    if (phone != null) map['phone'] = phone;
    if (email != null) map['email'] = email;
    return map;
  }
}

/// ------------------ EDUCATION INFO ------------------
class EducationInfo {
   String? board;
   String? stream;
   String? passoutYear;
   Map<String, dynamic>? subjects; // {subject: marks}
   String? discipline;
   String? specialization;
   String? percentage;
   String? noOfBacklogs;
   String? typeOfStudy;
   String? duration;
   String? joinDate;
   String? passoutDate;

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
    return EducationInfo(
      board: json['board']?.toString(),
      stream: json['stream']?.toString(),
      passoutYear: json['passout_year']?.toString(),
      subjects: _ensureMap(json['subjects']),
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
    final map = <String, dynamic>{};
    if (board != null) map['board'] = board;
    if (stream != null) map['stream'] = stream;
    if (passoutYear != null) map['passout_year'] = passoutYear;
    if (subjects != null) map['subjects'] = subjects;
    if (discipline != null) map['discipline'] = discipline;
    if (specialization != null) map['specialization'] = specialization;
    if (percentage != null) map['percentage'] = percentage;
    if (noOfBacklogs != null) map['no_of_backlogs'] = noOfBacklogs;
    if (typeOfStudy != null) map['type_of_study'] = typeOfStudy;
    if (duration != null) map['duration'] = duration;
    if (joinDate != null) map['join_date'] = joinDate;
    if (passoutDate != null) map['passout_date'] = passoutDate;
    return map;
  }
}

/// ------------------ WORK EXPERIENCE ------------------
class WorkExperience {
   String? companyName;
   String? designation;
   String? jobType;
   String? location;
   String? dateOfJoining;
   String? dateOfRelieving;
   String? companyAddress;
   String? description;
   bool? isCurrentlyWorking;

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
      isCurrentlyWorking: _toBool(json['is_currently_working']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (companyName != null) map['company_name'] = companyName;
    if (designation != null) map['designation'] = designation;
    if (jobType != null) map['job_type'] = jobType;
    if (location != null) map['location'] = location;
    if (dateOfJoining != null) map['date_of_joining'] = dateOfJoining;
    if (dateOfRelieving != null) map['date_of_relieving'] = dateOfRelieving;
    if (companyAddress != null) map['company_address'] = companyAddress;
    if (description != null) map['description'] = description;
    if (isCurrentlyWorking != null)
      map['is_currently_working'] = isCurrentlyWorking;
    return map;
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
    return BudgetInfo(
      selfFunding: _toBool(json['self_funding']),
      homeLoan: _toBool(json['home_loan']),
      both: _toBool(json['both']),
      budgetAmount: _toDouble(json['budget_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (selfFunding != null) map['self_funding'] = selfFunding;
    if (homeLoan != null) map['home_loan'] = homeLoan;
    if (both != null) map['both'] = both;
    if (budgetAmount != null) map['budget_amount'] = budgetAmount;
    return map;
  }
}

/// ------------------ PREFERENCES ------------------
class Preferences {
   String? country;
   String? interestedIndustry;
   String? interestedCourse;
   String? interestedUniversity;
   String? preferredState;

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
    final map = <String, dynamic>{};
    if (country != null) map['country'] = country;
    if (interestedIndustry != null)
      map['interested_industry'] = interestedIndustry;
    if (interestedCourse != null) map['interested_course'] = interestedCourse;
    if (interestedUniversity != null)
      map['interested_university'] = interestedUniversity;
    if (preferredState != null) map['preferred_state'] = preferredState;
    return map;
  }
}

/// ------------------ ENGLISH PROFICIENCY ------------------
/// Example shape:
/// { "IELTS": ["Listening","Reading","Writing","Speaking"], "Duolingo": ["Overall Score"] }
class EnglishProficiency {
  final Map<String, List<String>>? tests;

  EnglishProficiency({this.tests});

  factory EnglishProficiency.fromJson(Map<String, dynamic> json) {
    final out = <String, List<String>>{};
    json.forEach((key, value) {
      if (value is List) {
        out[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        try {
          final dec = jsonDecode(value);
          if (dec is List)
            out[key] = dec.map((e) => e.toString()).toList();
          else
            out[key] = [value];
        } catch (_) {
          out[key] = [value];
        }
      } else {
        out[key] = [value.toString()];
      }
    });
    return EnglishProficiency(tests: out.isEmpty ? null : out);
  }

  Map<String, dynamic> toJson() {
    if (tests == null) return {};
    final map = <String, dynamic>{};
    tests!.forEach((k, v) {
      map[k] = v;
    });
    return map;
  }
}
