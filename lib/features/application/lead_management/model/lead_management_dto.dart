import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';

part 'lead_management_dto.freezed.dart';
part 'lead_management_dto.g.dart';

@freezed
class LeadManagementDTO with _$LeadManagementDTO {
  // Private constructor for custom getters if needed
  const LeadManagementDTO._();

  const factory LeadManagementDTO({
    @Default([]) List<LeadsListModel> leadsList,
    LeadInfoModel? selectedLead,
    LeadsListModel? selectedLeadLocally,
  }) = _LeadManagementDTO;

  factory LeadManagementDTO.fromJson(Map<String, dynamic> json) =>
      _$LeadManagementDTOFromJson(json);
      
        @override
        // TODO: implement leadsList
        List<LeadsListModel> get leadsList => throw UnimplementedError();
      
        @override
        // TODO: implement selectedLead
        LeadInfoModel? get selectedLead => throw UnimplementedError();
      
        @override
        // TODO: implement selectedLeadLocally
        LeadsListModel? get selectedLeadLocally => throw UnimplementedError();
      
        @override
        Map<String, dynamic> toJson() {
          // TODO: implement toJson
          throw UnimplementedError();
        }
}
