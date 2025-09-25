import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/lead_call_history_section.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeaadDetailsPopup extends ConsumerWidget {
  const LeaadDetailsPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadState = ref.watch(leadMangementcontroller);
    final lead = leadState.selectedLead;
    final leadRow = leadState.selectedLeadLocally;

    if (leadRow == null) {
      return AlertDialog(
        title: const Text('Lead Details'),
        content: const Text('No lead selected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    }

    final basicInfo = lead?.basicInfo;
    final fullName = _fullName(basicInfo, leadRow);
    final createdAt = _formatDateTime(leadRow.createdAt ?? lead?.createdAt);
    final followUp = _formatFollowUp(leadRow.followUp);
    final latestHistory = _latestHistoryEntry(lead?.changesHistory);

    final summaryCards = <Widget>[
      _DetailCard(
        icon: Icons.person_outline,
        title: 'Basic Information',
        items: [
          _InfoItem('Lead ID', leadRow.id?.toString()),
          _InfoItem('Full Name', fullName.isNotEmpty ? fullName : null),
          _InfoItem('Status', leadRow.status),
          _InfoItem('Source', leadRow.source),
          _InfoItem('Created', createdAt),
        ],
      ),
      _DetailCard(
        icon: Icons.phone_outlined,
        title: 'Contact Information',
        items: [
          _InfoItem('Email', basicInfo?.email ?? leadRow.email),
          _InfoItem('Phone', basicInfo?.phone ?? _formatPhone(leadRow.phone)),
          _InfoItem('Follow-up', followUp),
          _InfoItem('Remark', leadRow.remark),
        ],
      ),
      _DetailCard(
        icon: Icons.badge_outlined,
        title: 'Assignment Details',
        items: [
          _InfoItem('Freelancer Manager', leadRow.freelancerManager),
          _InfoItem('Freelancer', leadRow.freelancer),
          _InfoItem(
            'Assigned Mentor',
            leadRow.assignedProfile?.displayName ??
                leadRow.assignedProfile?.email ??
                leadRow.assignedTo,
          ),
          _InfoItem('Lead Type', leadRow.draftStatus),
        ],
      ),
      _DetailCard(
        icon: Icons.timeline_outlined,
        title: 'Timeline & Follow-up',
        items: [
          _InfoItem('Next Follow-up', followUp),
          if (latestHistory != null)
            _InfoItem(
              'Last Update',
              _combineParts([
                _formatDateTime(latestHistory.changedAt),
                latestHistory.status ?? 'Status update',
              ]),
            ),
          if (latestHistory?.mentorName != null ||
              latestHistory?.mentorId != null)
            _InfoItem(
              'Updated By',
              latestHistory?.mentorName ?? latestHistory?.mentorId,
            ),
          _InfoItem(
            'Total Calls',
            (lead?.callInfo?.isNotEmpty ?? false)
                ? lead!.callInfo!.length.toString()
                : null,
          ),
        ],
      ),
    ];

    final detailSections = <Widget>[];
    final educationSection = _buildEducationSection(lead?.education);
    if (educationSection != null) detailSections.add(educationSection);

    final workSection = _buildWorkSection(lead?.workExperience);
    if (workSection != null) detailSections.add(workSection);

    final budgetSection = _buildBudgetSection(lead?.budgetInfo);
    if (budgetSection != null) detailSections.add(budgetSection);

    final preferenceSection = _buildPreferencesSection(lead?.preferences);
    if (preferenceSection != null) detailSections.add(preferenceSection);

    final englishSection = _buildEnglishSection(lead?.englishProficiency);
    if (englishSection != null) detailSections.add(englishSection);

    final historySection =
        (lead?.callInfo?.isNotEmpty ?? false) ||
                (lead?.changesHistory?.isNotEmpty ?? false)
            ? _DetailSection(
              icon: Icons.history,
              title: 'Call & Status History',
              child: LeadCallHistorySection(
                callLogs: lead?.callInfo ?? const [],
                statusChanges: lead?.changesHistory ?? const [],
              ),
            )
            : null;

    final baseDetailsSection = _buildBaseDetailsSection(basicInfo);
    if (baseDetailsSection != null) {
      detailSections.insert(0, baseDetailsSection);
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lead Details',
                          style: myTextstyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        if (fullName.isNotEmpty) ...[
                          height5,
                          Text(
                            fullName,
                            style: myTextstyle(color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                height20,
                Wrap(spacing: 16, runSpacing: 16, children: summaryCards),
                if (historySection != null) ...[height20, historySection],
                for (final section in detailSections) ...[height20, section],
                height20,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConsts.greyContainer),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ColorConsts.primaryColor),
              width5,
              Text(
                title,
                style: myTextstyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          height10,
          for (var i = 0; i < items.length; i++) ...[
            _InfoRow(label: items[i].label, value: items[i].value),
            if (i != items.length - 1) height10,
          ],
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.child,
    this.icon = Icons.info_outline,
  });

  final String title;
  final Widget child;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConsts.greyContainer),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ColorConsts.primaryColor),
              width5,
              Text(
                title,
                style: myTextstyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          height10,
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final resolvedValue =
        (value == null || value!.trim().isEmpty) ? '—' : value!.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label:',
            style: myTextstyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700] ?? Colors.grey,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            resolvedValue,
            style: myTextstyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoItem {
  const _InfoItem(this.label, this.value);

  final String label;
  final String? value;
}

String _fullName(BasicInfo? info, LeadsListModel lead) {
  final first = info?.firstName?.trim();
  final second = info?.secondName?.trim();
  if ((first?.isNotEmpty ?? false) && (second?.isNotEmpty ?? false)) {
    return '$first $second';
  }
  if (first?.isNotEmpty ?? false) return first!;
  final leadName = lead.name?.trim();
  if (leadName != null && leadName.isNotEmpty) return leadName;
  if (second?.isNotEmpty ?? false) return second!;
  return '';
}

String? _formatDateTime(DateTime? date) {
  if (date == null) return null;
  return DateTimeHelper.formatDateForLead(date.toLocal());
}

String? _formatFollowUp(String? followUp) {
  if (followUp == null || followUp.trim().isEmpty) return null;
  final parsed = DateTimeHelper.parseDate(followUp);
  return parsed != null
      ? DateTimeHelper.formatDateForLead(parsed)
      : followUp.trim();
}

String? _formatPhone(int? phone) {
  if (phone == null) return null;
  final digits = phone.toString();
  if (digits.length == 10) {
    return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
  }
  return digits;
}

LeadStatusChangeLog? _latestHistoryEntry(List<LeadStatusChangeLog>? entries) {
  if (entries == null || entries.isEmpty) return null;
  final sorted = List<LeadStatusChangeLog>.from(entries);
  sorted.sort((a, b) {
    final left = a.changedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final right = b.changedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return right.compareTo(left);
  });
  return sorted.first;
}

Widget? _buildBaseDetailsSection(BasicInfo? basicInfo) {
  if (basicInfo == null) return null;

  final items = [
    _InfoItem('First Name', basicInfo.firstName),
    _InfoItem('Second Name', basicInfo.secondName),
    _InfoItem('Gender', basicInfo.gender),
    _InfoItem('Marital Status', basicInfo.maritalStatus),
    _InfoItem('Date of Birth', basicInfo.dateOfBirth),
  ];

  final hasValue = items.any(
    (item) => item.value != null && item.value!.isNotEmpty,
  );
  if (!hasValue) return null;

  return _DetailSection(
    icon: Icons.assignment_ind_outlined,
    title: 'Profile Details',
    child: Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          _InfoRow(label: items[i].label, value: items[i].value),
          if (i != items.length - 1) height10,
        ],
      ],
    ),
  );
}

Widget? _buildEducationSection(EducationData? education) {
  if (education == null) return null;

  final items = <Widget>[];

  void addEducation(String label, EducationLevel? level) {
    if (level == null) return;
    final details = <String>[];
    if (level.board?.isNotEmpty ?? false) details.add('Board: ${level.board}');
    if (level.stream?.isNotEmpty ?? false)
      details.add('Stream: ${level.stream}');
    if (level.passoutYear?.isNotEmpty ?? false) {
      details.add('Year: ${level.passoutYear}');
    }
    if (level.percentage?.isNotEmpty ?? false) {
      details.add('Score: ${level.percentage}');
    }
    if (details.isEmpty) return;
    items.add(_InfoRow(label: label, value: details.join(' • ')));
    items.add(height10);
  }

  addEducation('Class X', education.tenth);
  addEducation('+2 / Higher Secondary', education.plusTwo);

  if (education.degrees != null && education.degrees!.isNotEmpty) {
    for (var i = 0; i < education.degrees!.length; i++) {
      final degree = education.degrees![i];
      final parts = <String>[];
      if (degree.discipline?.isNotEmpty ?? false) {
        parts.add(degree.discipline!);
      }
      if (degree.specialization?.isNotEmpty ?? false) {
        parts.add('Specialization: ${degree.specialization}');
      }
      if (degree.typeOfStudy?.isNotEmpty ?? false) {
        parts.add('Study Type: ${degree.typeOfStudy}');
      }
      if ((degree.joinDate?.isNotEmpty ?? false) ||
          (degree.passoutDate?.isNotEmpty ?? false)) {
        parts.add(
          'Duration: ${degree.joinDate ?? '-'} → ${degree.passoutDate ?? '-'}',
        );
      }

      if (degree.percentage?.isNotEmpty ?? false) {
        parts.add('Score: ${degree.percentage}');
      }
      if (degree.noOfBacklogs?.isNotEmpty ?? false) {
        parts.add('Backlogs: ${degree.noOfBacklogs}');
      }
      if (parts.isEmpty) continue;
      items.add(_InfoRow(label: 'Degree ${i + 1}', value: parts.join(' • ')));
      if (i != education.degrees!.length - 1) {
        items.add(height10);
      }
    }
  }

  if (items.isEmpty) return null;
  if (items.last == height10) items.removeLast();

  return _DetailSection(
    icon: Icons.school_outlined,
    title: 'Education',
    child: Column(children: items),
  );
}

Widget? _buildWorkSection(List<WorkExperience>? experiences) {
  if (experiences == null || experiences.isEmpty) return null;

  final children = <Widget>[];
  for (var i = 0; i < experiences.length; i++) {
    final exp = experiences[i];
    final details = <String>[];
    if (exp.designation?.isNotEmpty ?? false) {
      details.add(exp.designation!);
    }
    if (exp.companyName?.isNotEmpty ?? false) {
      details.add(exp.companyName!);
    }
    if (exp.location?.isNotEmpty ?? false) {
      details.add(exp.location!);
    }
    if (exp.dateOfJoining != null || exp.dateOfRelieving != null) {
      details.add(
        'Tenure: ${exp.dateOfJoining ?? '-'} → ${exp.dateOfRelieving ?? 'Present'}',
      );
    }
    if (exp.description?.isNotEmpty ?? false) {
      details.add(exp.description!);
    }
    if (details.isEmpty) continue;

    children.add(_InfoRow(label: 'Role ${i + 1}', value: details.join(' • ')));
    if (i != experiences.length - 1) {
      children.add(height10);
    }
  }

  if (children.isEmpty) return null;

  return _DetailSection(
    icon: Icons.work_outline,
    title: 'Work Experience',
    child: Column(children: children),
  );
}

Widget? _buildBudgetSection(BudgetInfo? budget) {
  if (budget == null) return null;

  final items = <_InfoItem>[
    _InfoItem('Self Funding', _boolText(budget.selfFunding)),
    _InfoItem('Home Loan', _boolText(budget.homeLoan)),
    _InfoItem('Combination', _boolText(budget.both)),
    if (budget.budgetAmount != null)
      _InfoItem('Budget Amount', '₹${budget.budgetAmount!.toStringAsFixed(2)}'),
  ];

  final hasValue = items.any((item) => item.value != null && item.value != '—');
  if (!hasValue) return null;

  return _DetailSection(
    icon: Icons.savings_outlined,
    title: 'Budget Information',
    child: Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          _InfoRow(label: items[i].label, value: items[i].value),
          if (i != items.length - 1) height10,
        ],
      ],
    ),
  );
}

Widget? _buildPreferencesSection(Preferences? preferences) {
  if (preferences == null) return null;

  final items = <_InfoItem>[
    _InfoItem('Preferred Country', preferences.country),
    _InfoItem('Preferred State', preferences.preferredState),
    _InfoItem('Interested Industry', preferences.interestedIndustry),
    _InfoItem('Interested Course', preferences.interestedCourse),
    _InfoItem('Interested University', preferences.interestedUniversity),
  ];

  final hasValue = items.any(
    (item) => item.value != null && item.value!.isNotEmpty,
  );
  if (!hasValue) return null;

  return _DetailSection(
    icon: Icons.travel_explore_outlined,
    title: 'Preferences',
    child: Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          _InfoRow(label: items[i].label, value: items[i].value),
          if (i != items.length - 1) height10,
        ],
      ],
    ),
  );
}

Widget? _buildEnglishSection(EnglishProficiency? english) {
  final tests = english?.tests;
  if (tests == null || tests.isEmpty) return null;

  final children = <Widget>[];
  tests.forEach((test, components) {
    final value = components.isNotEmpty ? components.join(', ') : null;
    children.add(_InfoRow(label: test, value: value));
    children.add(height10);
  });
  if (children.isNotEmpty) {
    children.removeLast();
  }

  if (children.isEmpty) return null;

  return _DetailSection(
    icon: Icons.language_outlined,
    title: 'English Proficiency',
    child: Column(children: children),
  );
}

String? _boolText(bool? value) {
  if (value == null) return null;
  return value ? 'Yes' : 'No';
}

String? _combineParts(List<String?> parts) {
  final filtered =
      parts
          .where((part) => part != null && part!.trim().isNotEmpty)
          .map((part) => part!.trim())
          .toList();
  if (filtered.isEmpty) return null;
  return filtered.join(' • ');
}
