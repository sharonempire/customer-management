import 'package:flutter/material.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeadCounsellorSection extends StatelessWidget {
  final bool isLoading;
  final String? errorText;
  final List<UserProfileModel> counsellors;
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  final VoidCallback onRefresh;

  const LeadCounsellorSection({
    super.key,
    required this.isLoading,
    required this.errorText,
    required this.counsellors,
    required this.selectedId,
    required this.onChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _CounsellorLoadingRow();
    }

    final hasError = errorText != null && errorText!.isNotEmpty;
    final hasCounsellors = counsellors.isNotEmpty;

    final dropdownRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LeadCounsellorDropdown(
            counsellors: counsellors,
            selectedId: _normaliseCounsellorId(selectedId),
            onChanged: onChanged,
          ),
        ),
        width10,
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh counsellors',
          ),
        ),
      ],
    );

    if (hasError && !hasCounsellors) {
      return _CounsellorMessageRow(
        icon: Icons.error_outline,
        message: errorText!,
        onRefresh: onRefresh,
      );
    }

    if (!hasCounsellors) {
      return _CounsellorMessageRow(
        icon: Icons.info_outline,
        message: 'No counsellors available',
        onRefresh: onRefresh,
      );
    }

    if (hasError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CounsellorMessageRow(
            icon: Icons.error_outline,
            message: errorText!,
            onRefresh: onRefresh,
          ),
          height10,
          dropdownRow,
        ],
      );
    }

    return dropdownRow;
  }
}

class LeadCounsellorDropdown extends StatelessWidget {
  final List<UserProfileModel> counsellors;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const LeadCounsellorDropdown({
    super.key,
    required this.counsellors,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final unassignedMeta = _attendanceMetaFor(null);
    final dropdownItems = <DropdownMenuItem<String?>>[
      DropdownMenuItem<String?>(
        value: null,
        child: _LeadCounsellorOption(
          title: 'Unassigned',
          subtitle: 'No counsellor assigned',
          attendance: unassignedMeta,
        ),
      ),
      ...counsellors.map((profile) {
        final meta = _attendanceMetaFor(profile.attendanceStatus);
        return DropdownMenuItem<String?>(
          value: _normaliseCounsellorId(profile.id),
          child: _LeadCounsellorOption(
            title: _counsellorTitle(profile),
            subtitle: _counsellorSubtitle(profile),
            attendance: meta,
          ),
        );
      }),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DropdownButtonFormField<String?>(
        value: _normaliseCounsellorId(selectedId),
        isExpanded: true,
        items: dropdownItems,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Assigned Counsellor',
          labelStyle: myTextstyle(color: Colors.grey, fontSize: 16),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        selectedItemBuilder: (context) {
          final items = <Widget>[
            SizedBox(
              width: double.infinity,
              child: _LeadCounsellorOption(
                title: 'Unassigned',
                subtitle: 'No counsellor assigned',
                attendance: unassignedMeta,
                dense: true,
              ),
            ),
          ];

          for (final profile in counsellors) {
            final meta = _attendanceMetaFor(profile.attendanceStatus);
            items.add(
              SizedBox(
                width: double.infinity,
                child: _LeadCounsellorOption(
                  title: _counsellorTitle(profile),
                  subtitle: _counsellorSubtitle(profile),
                  attendance: meta,
                  dense: true,
                ),
              ),
            );
          }

          return items;
        },
      ),
    );
  }
}

class _LeadCounsellorOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final _AttendanceMeta attendance;
  final bool dense;

  const _LeadCounsellorOption({
    required this.title,
    required this.subtitle,
    required this.attendance,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = myTextstyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    );

    final subtitleStyle = myTextstyle(
      fontSize: dense ? 13 : 14,
      color: Colors.grey.shade600,
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle,
                    style: subtitleStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        width10,
        _AttendanceBadge(
          meta: attendance,
          dense: dense,
        ),
      ],
    );
  }
}

class _CounsellorMessageRow extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onRefresh;

  const _CounsellorMessageRow({
    required this.icon,
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          width10,
          Expanded(
            child: Text(
              message,
              style: myTextstyle(color: Colors.grey.shade700, fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh counsellors',
          ),
        ],
      ),
    );
  }
}

class _CounsellorLoadingRow extends StatelessWidget {
  const _CounsellorLoadingRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          width10,
          Expanded(
            child: Text(
              'Loading counsellors…',
              style: myTextstyle(color: Colors.grey.shade700, fontSize: 16),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

String? _normaliseCounsellorId(String? id) {
  final trimmed = id?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

String _counsellorTitle(UserProfileModel profile) {
  final displayName = profile.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return displayName;
  }

  final email = profile.email?.trim();
  if (email != null && email.isNotEmpty) {
    return email;
  }

  final id = profile.id?.trim();
  if (id != null && id.isNotEmpty) {
    return id;
  }

  return 'Unknown Counsellor';
}

String _counsellorSubtitle(UserProfileModel profile) {
  final metadata = <String>[];

  final designation = profile.designation?.trim();
  if (designation != null && designation.isNotEmpty) {
    metadata.add(designation);
  }

  final email = profile.email?.trim();
  if (email != null && email.isNotEmpty) {
    metadata.add(email);
  }

  return metadata.join(' • ');
}

class _AttendanceMeta {
  final String label;
  final Color textColor;
  final Color backgroundColor;

  const _AttendanceMeta({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });
}

class _AttendanceBadge extends StatelessWidget {
  final _AttendanceMeta meta;
  final bool dense;

  const _AttendanceBadge({
    required this.meta,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = dense ? 8.0 : 10.0;
    final verticalPadding = dense ? 4.0 : 6.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: meta.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dense ? 6 : 8,
            height: dense ? 6 : 8,
            decoration: BoxDecoration(
              color: meta.textColor,
              shape: BoxShape.circle,
            ),
          ),
          width5,
          Text(
            meta.label,
            style: myTextstyle(
              color: meta.textColor,
              fontSize: dense ? 12 : 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

_AttendanceMeta _attendanceMetaFor(String? status) {
  final trimmed = status?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return _AttendanceMeta(
      label: 'Not Marked',
      textColor: Colors.grey.shade700,
      backgroundColor: Colors.grey.shade200,
    );
  }

  final lower = trimmed.toLowerCase();

  if (lower.contains('present')) {
    return _AttendanceMeta(
      label: 'Present',
      textColor: Colors.green.shade700,
      backgroundColor: Colors.green.shade50,
    );
  }

  if (lower.contains('wfh')) {
    return _AttendanceMeta(
      label: 'WFH',
      textColor: Colors.indigo.shade600,
      backgroundColor: Colors.indigo.shade50,
    );
  }

  if (lower.contains('remote')) {
    return _AttendanceMeta(
      label: 'Remote',
      textColor: Colors.blue.shade700,
      backgroundColor: Colors.blue.shade50,
    );
  }

  if (lower.contains('leave')) {
    return _AttendanceMeta(
      label: 'On Leave',
      textColor: Colors.orange.shade700,
      backgroundColor: Colors.orange.shade50,
    );
  }

  if (lower.contains('half')) {
    return _AttendanceMeta(
      label: 'Half Day',
      textColor: Colors.amber.shade800,
      backgroundColor: Colors.amber.shade100,
    );
  }

  if (lower.contains('absent')) {
    return _AttendanceMeta(
      label: 'Absent',
      textColor: Colors.red.shade700,
      backgroundColor: Colors.red.shade50,
    );
  }

  if (lower.contains('not checked')) {
    return _AttendanceMeta(
      label: 'Not Checked In',
      textColor: Colors.grey.shade700,
      backgroundColor: Colors.grey.shade200,
    );
  }

  if (lower.contains('not marked')) {
    return _AttendanceMeta(
      label: 'Not Marked',
      textColor: Colors.grey.shade700,
      backgroundColor: Colors.grey.shade200,
    );
  }

  return _AttendanceMeta(
    label: trimmed,
    textColor: Colors.grey.shade700,
    backgroundColor: Colors.grey.shade200,
  );
}
