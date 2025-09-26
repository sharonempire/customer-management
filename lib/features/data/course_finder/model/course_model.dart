class Course {


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
  final String? englishRecruitment;
  final String? minimumPercentage;
  final String? ageLimit;
  final String? academicGap;
  final String? maxBacklogs;
  final String? workExperienceRequirement;
  final Map<String, dynamic>? requiredSubjects;
  final Map<String, dynamic>? intakes;
  final Map<String, dynamic>? links;
  final Map<String, dynamic>? mediaLinks;
  final String? courseDescription;
  final String? specialRequirements;

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
    this.englishRecruitment,
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
  });

  factory Course.fromJson(Map<String, dynamic> json) {
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
      englishRecruitment: json['english_recruitment'] as String?,
      minimumPercentage: json['minimum_percentage'] as String?,
      ageLimit: json['age_limit'] as String?,
      academicGap: json['academic_gap'] as String?,
      maxBacklogs: json['max_backlogs'] as String?,
      workExperienceRequirement: json['work_experience_requirement'] as String?,
      requiredSubjects: json['required_subjects'] as Map<String, dynamic>?,
      intakes: json['intakes'] as Map<String, dynamic>?,
      links: json['links'] as Map<String, dynamic>?,
      mediaLinks: json['media_links'] as Map<String, dynamic>?,
      courseDescription: json['course_description'] as String?,
      specialRequirements: json['special_requirements'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
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
      'english_recruitment': englishRecruitment,
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
    };
  }
}
