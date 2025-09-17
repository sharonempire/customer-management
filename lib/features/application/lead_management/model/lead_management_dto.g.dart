// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_management_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeadManagementDTO _$LeadManagementDTOFromJson(Map<String, dynamic> json) =>
    _LeadManagementDTO(
      leadsList:
          (json['leadsList'] as List<dynamic>?)
              ?.map((e) => LeadsListModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedLead:
          json['selectedLead'] == null
              ? null
              : LeadInfoModel.fromJson(
                json['selectedLead'] as Map<String, dynamic>,
              ),
      selectedLeadLocally:
          json['selectedLeadLocally'] == null
              ? null
              : LeadsListModel.fromJson(
                json['selectedLeadLocally'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$LeadManagementDTOToJson(_LeadManagementDTO instance) =>
    <String, dynamic>{
      'leadsList': instance.leadsList,
      'selectedLead': instance.selectedLead,
      'selectedLeadLocally': instance.selectedLeadLocally,
    };
