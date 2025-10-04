class Course {
  Course({
    this.id,
    this.createdAt,
    this.programName,
    this.university,
    this.country,
    this.city,
    this.campus,
    this.applicationFee,
    this.tuitionFee,
    this.depositAmount,
    this.currency,
    this.duration,
    this.language,
    this.studyType,
    this.programLevel,
    this.englishProficiency,
    this.minimumPercentage,
    this.ageLimit,
    this.academicGap,
    this.maxBacklogs,
    this.workExperienceRequirement,
    this.requiredSubjects,
    this.intakes,
    this.links,
    this.mediaLinks,
    this.courseDescription,
    this.specialRequirements,
    this.commission,
    this.fieldOfStudy,
  });

  final int? id;
  final DateTime? createdAt;
  final String? programName;
  final String? university;
  final String? country;
  final String? city;
  final String? campus;
  final String? applicationFee;
  final String? tuitionFee;
  final String? depositAmount;
  final String? currency;
  final String? duration;
  final String? language;
  final String? studyType;
  final String? programLevel;
  final String? englishProficiency;
  final String? minimumPercentage;
  final String? ageLimit;
  final String? academicGap;
  final String? maxBacklogs;
  final String? workExperienceRequirement;
  final List<String>? requiredSubjects;
  final List<String>? intakes;
  final List<String>? links;
  final List<String>? mediaLinks;
  final String? courseDescription;
  final String? specialRequirements;
  final int? commission;
  final String? fieldOfStudy;

  factory Course.fromJson(Map<String, dynamic> json) {
    List<String>? parseList(dynamic value) {
      if (value == null) return null;

      if (value is List) {
        return value
            .map((item) => item?.toString().trim())
            .whereType<String>()
            .where((item) => item.isNotEmpty)
            .toList();
      }

      if (value is String) {
        return value
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();
      }

      return null;
    }

    return Course(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      programName: json['program_name'] as String?,
      university: json['university'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      campus: json['campus'] as String?,
      applicationFee: json['application_fee'] as String?,
      tuitionFee: json['tuition_fee'] as String?,
      depositAmount: json['deposit_amount'] as String?,
      currency: json['currency'] as String?,
      duration: json['duration'] as String?,
      language: json['language'] as String?,
      studyType: json['study_type'] as String?,
      programLevel: json['program_level'] as String?,
      englishProficiency: json['english_proficiency'] as String?,
      minimumPercentage: json['minimum_percentage'] as String?,
      ageLimit: json['age_limit'] as String?,
      academicGap: json['academic_gap'] as String?,
      maxBacklogs: json['max_backlogs'] as String?,
      workExperienceRequirement:
          json['work_experience_requirement'] as String?,
      requiredSubjects: parseList(json['required_subjects']),
      intakes: parseList(json['intakes']),
      links: parseList(json['links']),
      mediaLinks: parseList(json['media_links']),
      courseDescription: json['course_description'] as String?,
      specialRequirements: json['special_requirements'] as String?,
      commission: json['commission'] != null
          ? int.tryParse(json['commission'].toString())
          : null,
      fieldOfStudy: json['field_of_study'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'program_name': programName,
      'university': university,
      'country': country,
      'city': city,
      'campus': campus,
      'application_fee': applicationFee,
      'tuition_fee': tuitionFee,
      'deposit_amount': depositAmount,
      'currency': currency,
      'duration': duration,
      'language': language,
      'study_type': studyType,
      'program_level': programLevel,
      'english_proficiency': englishProficiency,
      'minimum_percentage': minimumPercentage,
      'age_limit': ageLimit,
      'academic_gap': academicGap,
      'max_backlogs': maxBacklogs,
      'work_experience_requirement': workExperienceRequirement,
      'required_subjects': requiredSubjects,
      'intakes': intakes,
      'links': links,
      'media_links': mediaLinks,
      'course_description': courseDescription,
      'special_requirements': specialRequirements,
      'commission': commission,
      'field_of_study': fieldOfStudy,
    };

    map.removeWhere((key, value) {
      if (value == null) return true;
      if (value is String) return value.trim().isEmpty;
      if (value is List) return value.isEmpty;
      return false;
    });

    return map;
  }

  Course copyWith({
    String? programName,
    String? university,
    String? country,
    String? city,
    String? campus,
    String? applicationFee,
    String? tuitionFee,
    String? depositAmount,
    String? currency,
    String? duration,
    String? language,
    String? studyType,
    String? programLevel,
    String? englishProficiency,
    String? minimumPercentage,
    String? ageLimit,
    String? academicGap,
    String? maxBacklogs,
    String? workExperienceRequirement,
    List<String>? requiredSubjects,
    List<String>? intakes,
    List<String>? links,
    List<String>? mediaLinks,
    String? courseDescription,
    String? specialRequirements,
    int? commission,
    String? fieldOfStudy,
  }) {
    return Course(
      id: id,
      createdAt: createdAt,
      programName: programName ?? this.programName,
      university: university ?? this.university,
      country: country ?? this.country,
      city: city ?? this.city,
      campus: campus ?? this.campus,
      applicationFee: applicationFee ?? this.applicationFee,
      tuitionFee: tuitionFee ?? this.tuitionFee,
      depositAmount: depositAmount ?? this.depositAmount,
      currency: currency ?? this.currency,
      duration: duration ?? this.duration,
      language: language ?? this.language,
      studyType: studyType ?? this.studyType,
      programLevel: programLevel ?? this.programLevel,
      englishProficiency: englishProficiency ?? this.englishProficiency,
      minimumPercentage: minimumPercentage ?? this.minimumPercentage,
      ageLimit: ageLimit ?? this.ageLimit,
      academicGap: academicGap ?? this.academicGap,
      maxBacklogs: maxBacklogs ?? this.maxBacklogs,
      workExperienceRequirement:
          workExperienceRequirement ?? this.workExperienceRequirement,
      requiredSubjects: requiredSubjects ?? this.requiredSubjects,
      intakes: intakes ?? this.intakes,
      links: links ?? this.links,
      mediaLinks: mediaLinks ?? this.mediaLinks,
      courseDescription: courseDescription ?? this.courseDescription,
      specialRequirements: specialRequirements ?? this.specialRequirements,
      commission: commission ?? this.commission,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
    );
  }
}
