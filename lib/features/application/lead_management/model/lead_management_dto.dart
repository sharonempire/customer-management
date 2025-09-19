import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';

part 'lead_management_dto.freezed.dart';

@freezed
class LeadManagementDTO with _$LeadManagementDTO {
  // Private constructor for custom getters if needed
  const LeadManagementDTO._();

  const factory LeadManagementDTO({
   @Default([]) List<LeadsListModel> leadsList,
  @Default([]) List<LeadsListModel> filteredLeadsList,
  LeadInfoModel? selectedLead,
  LeadsListModel? selectedLeadLocally,
  @Default('') String searchQuery,
  @Default('') String filterSource,
  @Default('') String filterStatus,
  @Default('') String filterFreelancer,
  @Default('') String filterLeadType,
  }) = _LeadManagementDTO;
  
  @override
  // TODO: implement filterFreelancer
  String get filterFreelancer => throw UnimplementedError();
  
  @override
  // TODO: implement filterLeadType
  String get filterLeadType => throw UnimplementedError();
  
  @override
  // TODO: implement filterSource
  String get filterSource => throw UnimplementedError();
  
  @override
  // TODO: implement filterStatus
  String get filterStatus => throw UnimplementedError();
  
  @override
  // TODO: implement filteredLeadsList
  List<LeadsListModel> get filteredLeadsList => throw UnimplementedError();
  
  @override
  // TODO: implement leadsList
  List<LeadsListModel> get leadsList => throw UnimplementedError();
  
  @override
  // TODO: implement searchQuery
  String get searchQuery => throw UnimplementedError();
  
  @override
  // TODO: implement selectedLead
  LeadInfoModel? get selectedLead => throw UnimplementedError();
  
  @override
  // TODO: implement selectedLeadLocally
  LeadsListModel? get selectedLeadLocally => throw UnimplementedError();

}
