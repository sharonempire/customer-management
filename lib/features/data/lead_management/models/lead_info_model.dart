import 'dart:convert';

class LeadInfoModel {
  int? id;
  DateTime? createdAt;
  BasicInfo? basicInfo;
  EducationData? education;
  List<WorkExperience>? workExperience;
  BudgetInfo? budgetInfo;
  Preferences? preferences;
  EnglishProficiency? englishProficiency;
  List<LeadCallLog>? callInfo;
  List<LeadStatusChangeLog>? changesHistory;

  LeadInfoModel({
    this.id,
    this.createdAt,
    this.basicInfo,
    this.education,
    this.workExperience,
    this.budgetInfo,
    this.preferences,
    this.englishProficiency,
    this.callInfo,
    this.changesHistory,
  });

  LeadInfoModel copyWith({
    int? id,
    DateTime? createdAt,
    BasicInfo? basicInfo,
    EducationData? education,
    List<WorkExperience>? workExperience,
    BudgetInfo? budgetInfo,
    Preferences? preferences,
    EnglishProficiency? englishProficiency,
    List<LeadCallLog>? callInfo,
    List<LeadStatusChangeLog>? changesHistory,
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
      callInfo: callInfo ?? this.callInfo,
      changesHistory: changesHistory ?? this.changesHistory,
    );
  }

  // small helper used above to avoid analyzer warnings (keeps API same)
  List<WorkExperience>? workWorkExperienceOrSelf() => workExperience;

  factory LeadInfoModel.fromJson(Map<String, dynamic> json) {
    final basicMap = _ensureMap(json['basic_info']);
    final educationData = _ensureMap(json['education']);
    final workList = _ensureList(json['work_expierience']); // DB spelled field
    final budgetMap = _ensureMap(json['budget_info']);
    final prefMap = _ensureMap(json['preferences']);
    final englishMap = _ensureMap(json['english_proficiency']);
    final callInfoList = _ensureList(json['call_info']);
    final statusHistoryList = _ensureList(json['changes_history']);

    return LeadInfoModel(
      id: _toInt(json['id']),
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
      basicInfo: basicMap != null ? BasicInfo.fromJson(basicMap) : null,
      education:
          educationData != null ? EducationData.fromJson(educationData) : null,
      workExperience: workList?.map((m) => WorkExperience.fromJson(m)).toList(),
      budgetInfo: budgetMap != null ? BudgetInfo.fromJson(budgetMap) : null,
      preferences: prefMap != null ? Preferences.fromJson(prefMap) : null,
      englishProficiency:
          englishMap != null ? EnglishProficiency.fromJson(englishMap) : null,
      callInfo: callInfoList?.map((m) => LeadCallLog.fromJson(m)).toList(),
      changesHistory:
          statusHistoryList?.map((m) => LeadStatusChangeLog.fromJson(m)).toList(),
    );
  }

  /// toJson: only include non-null keys
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;
    if (createdAt != null) map['created_at'] = createdAt!.toIso8601String();
    if (basicInfo != null) map['basic_info'] = basicInfo!.toJson();
    if (education != null) {
      map['education'] = education!.toJson();
    }
    if (workExperience != null) {
      map['work_expierience'] = workExperience!.map((e) => e.toJson()).toList();
    }
    if (budgetInfo != null) map['budget_info'] = budgetInfo!.toJson();
    if (preferences != null) map['preferences'] = preferences!.toJson();
    if (englishProficiency != null) {
      map['english_proficiency'] = englishProficiency!.toJson();
    }
    if (callInfo != null) {
      map['call_info'] = callInfo!.map((e) => e.toJson()).toList();
    }
    if (changesHistory != null) {
      map['changes_history'] =
          changesHistory!.map((e) => e.toJson()).toList();
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

dynamic _firstNonNull(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (!json.containsKey(key)) continue;
    final value = json[key];
    if (value != null) {
      return value;
    }
  }
  return null;
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

class LeadCallLog {
  final String? callUuid;
  final String? callerNumber;
  final String? calledNumber;
  final String? agentNumber;
  final String? callerId;
  final String? status;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? callDateTime;
  final int? totalDurationSeconds;
  final int? conversationDurationSeconds;
  final String? recordingUrl;
  final String? dtmf;
  final String? transferredNumber;
  final String? callDateLabel;

  const LeadCallLog({
    this.callUuid,
    this.callerNumber,
    this.calledNumber,
    this.agentNumber,
    this.callerId,
    this.status,
    this.startTime,
    this.endTime,
    this.callDateTime,
    this.totalDurationSeconds,
    this.conversationDurationSeconds,
    this.recordingUrl,
    this.dtmf,
    this.transferredNumber,
    this.callDateLabel,
  });

  factory LeadCallLog.fromJson(Map<String, dynamic> json) {
    final callDateLabel =
        _firstNonEmptyString(json, const ['call_date', 'callDate', 'date']);
    final callDateTime = _parseDateTime(callDateLabel);

    return LeadCallLog(
      callUuid: _firstNonEmptyString(
        json,
        const ['call_uuid', 'CallUUID', 'callUuid', 'call_id', 'callId'],
      ),
      callerNumber: _firstNonEmptyString(
        json,
        const ['caller_number', 'callerNumber', 'caller', 'source', 'user_no'],
      ),
      calledNumber: _firstNonEmptyString(
        json,
        const ['called_number', 'calledNumber', 'destination'],
      ),
      agentNumber: _firstNonEmptyString(
        json,
        const ['agent_number', 'AgentNumber', 'agentNumber', 'extension'],
      ),
      callerId: _firstNonEmptyString(
        json,
        const ['callerid', 'caller_id', 'callerId'],
      ),
      status: _firstNonEmptyString(json, const ['callStatus', 'status']),
      startTime: _parseDateTime(
        _firstNonEmptyString(
          json,
          const [
            'call_start_time',
            'callStartTime',
            'start_time',
            'startTime',
          ],
        ),
      ),
      endTime: _parseDateTime(
        _firstNonEmptyString(
          json,
          const [
            'call_end_time',
            'callEndTime',
            'end_time',
            'endTime',
          ],
        ),
      ),
      callDateTime: callDateTime,
      totalDurationSeconds: _toInt(
        _firstNonEmptyString(
          json,
          const ['total_call_duration', 'totalCallDuration', 'duration'],
        ),
      ),
      conversationDurationSeconds: _toInt(
        _firstNonEmptyString(
          json,
          const ['conversationDuration', 'conversation_duration'],
        ),
      ),
      recordingUrl: _firstNonEmptyString(
        json,
        const ['recording_url', 'recording_URL', 'recordingUrl'],
      ),
      dtmf: _firstNonEmptyString(json, const ['dtmf']),
      transferredNumber: _firstNonEmptyString(
        json,
        const ['transferredNumber', 'transferred_number'],
      ),
      callDateLabel: callDateLabel,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (callUuid != null) map['call_uuid'] = callUuid;
    if (callerNumber != null) map['caller_number'] = callerNumber;
    if (calledNumber != null) map['called_number'] = calledNumber;
    if (agentNumber != null) map['agent_number'] = agentNumber;
    if (callerId != null) map['caller_id'] = callerId;
    if (status != null) map['status'] = status;
    if (startTime != null) {
      map['call_start_time'] = startTime!.toIso8601String();
    }
    if (endTime != null) {
      map['call_end_time'] = endTime!.toIso8601String();
    }
    if (callDateTime != null) {
      map['call_date'] = callDateTime!.toIso8601String();
    } else if (callDateLabel != null) {
      map['call_date'] = callDateLabel;
    }
    if (totalDurationSeconds != null) {
      map['total_call_duration'] = totalDurationSeconds;
    }
    if (conversationDurationSeconds != null) {
      map['conversationDuration'] = conversationDurationSeconds;
    }
    if (recordingUrl != null) map['recording_url'] = recordingUrl;
    if (dtmf != null) map['dtmf'] = dtmf;
    if (transferredNumber != null) {
      map['transferredNumber'] = transferredNumber;
    }
    if (callDateLabel != null) {
      map['call_date_label'] = callDateLabel;
    }
    return map;
  }

  static String? _firstNonEmptyString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      final stringValue = value.toString().trim();
      if (stringValue.isNotEmpty) {
        return stringValue;
      }
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;

    DateTime? parsed = DateTime.tryParse(raw);
    if (parsed != null) return parsed;

    final sanitized = raw
        .replaceAll('/', '-')
        .replaceFirst(' ', 'T')
        .replaceFirst(RegExp(r'(\d{2}):(\d{2}):(\d{2})\.(\d+)'), r'$1:$2:$3');
    parsed = DateTime.tryParse(sanitized);
    if (parsed != null) return parsed;

    return null;
  }
}

class LeadStatusChangeLog {
  final String? status;
  final String? previousStatus;
  final String? mentorName;
  final String? mentorId;
  final String? note;
  final DateTime? changedAt;

  const LeadStatusChangeLog({
    this.status,
    this.previousStatus,
    this.mentorName,
    this.mentorId,
    this.note,
    this.changedAt,
  });

  factory LeadStatusChangeLog.fromJson(Map<String, dynamic> json) {
    final status = LeadCallLog._firstNonEmptyString(
      json,
      const ['status', 'new_status', 'current_status', 'to_status'],
    );
    final previousStatus = LeadCallLog._firstNonEmptyString(
      json,
      const ['previous_status', 'old_status', 'from_status'],
    );
    final mentorName = LeadCallLog._firstNonEmptyString(
      json,
      const [
        'mentor_name',
        'mentor',
        'changed_by_name',
        'updated_by_name',
        'mentor_display_name',
      ],
    );
    final mentorId = LeadCallLog._firstNonEmptyString(
      json,
      const ['mentor_id', 'changed_by', 'updated_by', 'mentorId'],
    );
    final note = LeadCallLog._firstNonEmptyString(
      json,
      const ['note', 'remarks', 'comment', 'description'],
    );

    final changedAtRaw = _firstNonNull(
      json,
      const [
        'changed_at',
        'timestamp',
        'updated_at',
        'created_at',
        'time',
        'status_changed_at',
      ],
    );

    DateTime? changedAt;
    if (changedAtRaw is int) {
      final useMillis = changedAtRaw.toString().length > 10
          ? changedAtRaw
          : changedAtRaw * 1000;
      changedAt = DateTime.fromMillisecondsSinceEpoch(useMillis, isUtc: true)
          .toLocal();
    } else if (changedAtRaw is double) {
      final useMillis = changedAtRaw >= 1000000000000
          ? changedAtRaw.toInt()
          : (changedAtRaw * 1000).toInt();
      changedAt = DateTime.fromMillisecondsSinceEpoch(useMillis, isUtc: true)
          .toLocal();
    } else if (changedAtRaw is String) {
      final trimmed = changedAtRaw.trim();
      final numeric = int.tryParse(trimmed);
      if (numeric != null) {
        final useMillis = trimmed.length > 10 ? numeric : numeric * 1000;
        changedAt = DateTime.fromMillisecondsSinceEpoch(useMillis, isUtc: true)
            .toLocal();
      } else {
        changedAt = LeadCallLog._parseDateTime(trimmed);
      }
    } else {
      changedAt = LeadCallLog._parseDateTime(changedAtRaw);
    }

    return LeadStatusChangeLog(
      status: status,
      previousStatus: previousStatus,
      mentorName: mentorName,
      mentorId: mentorId,
      note: note,
      changedAt: changedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (status != null) map['status'] = status;
    if (previousStatus != null) map['previous_status'] = previousStatus;
    if (mentorName != null) map['mentor_name'] = mentorName;
    if (mentorId != null) map['mentor_id'] = mentorId;
    if (note != null) map['note'] = note;
    if (changedAt != null) {
      map['changed_at'] = changedAt!.toIso8601String();
    }
    return map;
  }
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
    this.phone,
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

/// ------------------ EDUCATION DATA ------------------
class EducationData {
  EducationLevel? tenth;
  EducationLevel? plusTwo;
  List<DegreeInfo>? degrees;

  EducationData({this.tenth, this.plusTwo, this.degrees});

  factory EducationData.fromJson(Map<String, dynamic> json) {
    return EducationData(
      tenth:
          json['tenth'] != null ? EducationLevel.fromJson(json['tenth']) : null,
      plusTwo:
          json['plus_two'] != null
              ? EducationLevel.fromJson(json['plus_two'])
              : null,
      degrees:
          (json['degrees'] as List<dynamic>?)
              ?.map((e) => DegreeInfo.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (tenth != null) map['tenth'] = tenth!.toJson();
    if (plusTwo != null) map['plus_two'] = plusTwo!.toJson();
    if (degrees != null) {
      map['degrees'] = degrees!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

class EducationLevel {
  String? board;
  String? stream; // only for +2
  String? passoutYear;
  String? percentage;
  Map<String, dynamic>? subjects; // {subject: marks}

  EducationLevel({
    this.board,
    this.stream,
    this.passoutYear,
    this.percentage,
    this.subjects,
  });

  factory EducationLevel.fromJson(Map<String, dynamic> json) {
    return EducationLevel(
      board: json['board']?.toString(),
      stream: json['stream']?.toString(),
      passoutYear: json['passout_year']?.toString(),
      percentage: json['percentage']?.toString(),
      subjects: _ensureMap(json['subjects']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (board != null) map['board'] = board;
    if (stream != null) map['stream'] = stream;
    if (passoutYear != null) map['passout_year'] = passoutYear;
    if (percentage != null) map['percentage'] = percentage;
    if (subjects != null) map['subjects'] = subjects;
    return map;
  }
}

class DegreeInfo {
  String? discipline;
  String? specialization;
  String? typeOfStudy;
  String? duration;
  String? joinDate;
  String? passoutDate;
  String? percentage;
  String? noOfBacklogs;

  DegreeInfo({
    this.discipline,
    this.specialization,
    this.typeOfStudy,
    this.duration,
    this.joinDate,
    this.passoutDate,
    this.percentage,
    this.noOfBacklogs,
  });

  factory DegreeInfo.fromJson(Map<String, dynamic> json) {
    return DegreeInfo(
      discipline: json['discipline']?.toString(),
      specialization: json['specialization']?.toString(),
      typeOfStudy: json['type_of_study']?.toString(),
      duration: json['duration']?.toString(),
      joinDate: json['join_date']?.toString(),
      passoutDate: json['passout_date']?.toString(),
      percentage: json['percentage']?.toString(),
      noOfBacklogs: json['no_of_backlogs']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (discipline != null) map['discipline'] = discipline;
    if (specialization != null) map['specialization'] = specialization;
    if (typeOfStudy != null) map['type_of_study'] = typeOfStudy;
    if (duration != null) map['duration'] = duration;
    if (joinDate != null) map['join_date'] = joinDate;
    if (passoutDate != null) map['passout_date'] = passoutDate;
    if (percentage != null) map['percentage'] = percentage;
    if (noOfBacklogs != null) map['no_of_backlogs'] = noOfBacklogs;
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
