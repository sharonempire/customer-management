import 'package:collection/collection.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';

/// Lightweight state container for lead management UI.
///
/// The previous implementation relied on `freezed`, but the generated code
/// became difficult to maintain.  This manual DTO keeps the same API surface
/// (`copyWith` + immutable fields) while allowing additional flags that power
/// the counsellor dropdown without mixing business logic into the UI widgets.
class LeadManagementDTO {
  final List<LeadsListModel> leadsList;
  final List<LeadsListModel> filteredLeadsList;
  final LeadInfoModel? selectedLead;
  final LeadsListModel? selectedLeadLocally;
  final String searchQuery;
  final String filterSource;
  final String filterStatus;
  final String filterFreelancer;
  final String filterLeadType;
  final List<UserProfileModel> counsellors;
  final bool isLoadingCounsellors;
  final String? counsellorError;
  final String? selectedCounsellorId;

  const LeadManagementDTO({
    this.leadsList = const [],
    this.filteredLeadsList = const [],
    this.selectedLead,
    this.selectedLeadLocally,
    this.searchQuery = '',
    this.filterSource = '',
    this.filterStatus = '',
    this.filterFreelancer = '',
    this.filterLeadType = '',
    this.counsellors = const [],
    this.isLoadingCounsellors = false,
    this.counsellorError,
    this.selectedCounsellorId,
  });

  static const _sentinel = Object();

  LeadManagementDTO copyWith({
    Object? leadsList = _sentinel,
    Object? filteredLeadsList = _sentinel,
    Object? selectedLead = _sentinel,
    Object? selectedLeadLocally = _sentinel,
    Object? searchQuery = _sentinel,
    Object? filterSource = _sentinel,
    Object? filterStatus = _sentinel,
    Object? filterFreelancer = _sentinel,
    Object? filterLeadType = _sentinel,
    Object? counsellors = _sentinel,
    Object? isLoadingCounsellors = _sentinel,
    Object? counsellorError = _sentinel,
    Object? selectedCounsellorId = _sentinel,
  }) {
    return LeadManagementDTO(
      leadsList: identical(leadsList, _sentinel)
          ? this.leadsList
          : List<LeadsListModel>.from(leadsList as List<LeadsListModel>),
      filteredLeadsList: identical(filteredLeadsList, _sentinel)
          ? this.filteredLeadsList
          : List<LeadsListModel>.from(
              filteredLeadsList as List<LeadsListModel>,
            ),
      selectedLead: identical(selectedLead, _sentinel)
          ? this.selectedLead
          : selectedLead as LeadInfoModel?,
      selectedLeadLocally: identical(selectedLeadLocally, _sentinel)
          ? this.selectedLeadLocally
          : selectedLeadLocally as LeadsListModel?,
      searchQuery: identical(searchQuery, _sentinel)
          ? this.searchQuery
          : searchQuery as String,
      filterSource: identical(filterSource, _sentinel)
          ? this.filterSource
          : filterSource as String,
      filterStatus: identical(filterStatus, _sentinel)
          ? this.filterStatus
          : filterStatus as String,
      filterFreelancer: identical(filterFreelancer, _sentinel)
          ? this.filterFreelancer
          : filterFreelancer as String,
      filterLeadType: identical(filterLeadType, _sentinel)
          ? this.filterLeadType
          : filterLeadType as String,
      counsellors: identical(counsellors, _sentinel)
          ? this.counsellors
          : List<UserProfileModel>.from(counsellors as List<UserProfileModel>),
      isLoadingCounsellors: identical(isLoadingCounsellors, _sentinel)
          ? this.isLoadingCounsellors
          : isLoadingCounsellors as bool,
      counsellorError: identical(counsellorError, _sentinel)
          ? this.counsellorError
          : counsellorError as String?,
      selectedCounsellorId: identical(selectedCounsellorId, _sentinel)
          ? this.selectedCounsellorId
          : selectedCounsellorId as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LeadManagementDTO) return false;

    return const ListEquality<LeadsListModel>().equals(leadsList, other.leadsList) &&
        const ListEquality<LeadsListModel>()
            .equals(filteredLeadsList, other.filteredLeadsList) &&
        selectedLead == other.selectedLead &&
        selectedLeadLocally == other.selectedLeadLocally &&
        searchQuery == other.searchQuery &&
        filterSource == other.filterSource &&
        filterStatus == other.filterStatus &&
        filterFreelancer == other.filterFreelancer &&
        filterLeadType == other.filterLeadType &&
        const ListEquality<UserProfileModel>().equals(counsellors, other.counsellors) &&
        isLoadingCounsellors == other.isLoadingCounsellors &&
        counsellorError == other.counsellorError &&
        selectedCounsellorId == other.selectedCounsellorId;
  }

  @override
  int get hashCode => Object.hashAll([
        const ListEquality<LeadsListModel>().hash(leadsList),
        const ListEquality<LeadsListModel>().hash(filteredLeadsList),
        selectedLead,
        selectedLeadLocally,
        searchQuery,
        filterSource,
        filterStatus,
        filterFreelancer,
        filterLeadType,
        const ListEquality<UserProfileModel>().hash(counsellors),
        isLoadingCounsellors,
        counsellorError,
        selectedCounsellorId,
      ]);
}
