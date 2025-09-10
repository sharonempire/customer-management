class UserProfileModel {
  final String? id;
  final DateTime? createdAt;
  final String? displayName;
  final String? profilePicture;
  final String? userType;
  final int? phone;
  final String? designation;
  final String? freelancerStatus;
  final String? location;

  UserProfileModel({
    this.id,
    this.createdAt,
    this.displayName,
    this.profilePicture,
    this.userType,
    this.phone,
    this.designation,
    this.freelancerStatus,
    this.location,
  });

  /// Convert Supabase data (Map) to Profile object
  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      displayName: map['diplay_name'] as String?, // DB typo kept
      profilePicture: map['profilepicture'] as String?,
      userType: map['user_type'] as String?,
      phone:
          map['phone'] != null ? int.tryParse(map['phone'].toString()) : null,
      designation: map['designation'] as String?,
      freelancerStatus: map['freelancer_status'] as String?,
      location: map['location'] as String?,
    );
  }

  /// Convert to JSON for update - excludes null fields
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (displayName != null) data['diplay_name'] = displayName;
    if (profilePicture != null) data['profilepicture'] = profilePicture;
    if (userType != null) data['user_type'] = userType;
    if (phone != null) data['phone'] = phone;
    if (designation != null) data['designation'] = designation;
    if (freelancerStatus != null) data['freelancer_status'] = freelancerStatus;
    if (location != null) data['location'] = location;

    return data;
  }

  /// Copy object with updated fields
  UserProfileModel copyWith({
    String? displayName,
    String? profilePicture,
    String? userType,
    int? phone,
    String? designation,
    String? freelancerStatus,
    String? location,
  }) {
    return UserProfileModel(
      id: id,
      createdAt: createdAt,
      displayName: displayName ?? this.displayName,
      profilePicture: profilePicture ?? this.profilePicture,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
      designation: designation ?? this.designation,
      freelancerStatus: freelancerStatus ?? this.freelancerStatus,
      location: location ?? this.location,
    );
  }
}
