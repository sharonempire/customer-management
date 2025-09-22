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
    final dropdownItems = <DropdownMenuItem<String?>>[
      const DropdownMenuItem<String?>(
        value: null,
        child: _CounsellorMenuTile(
          title: 'Unassigned',
          subtitle: 'No counsellor assigned',
        ),
      ),
      ...counsellors.map(
        (profile) => DropdownMenuItem<String?>(
          value: _normaliseCounsellorId(profile.id),
          child: _CounsellorMenuTile(
            title: _counsellorTitle(profile),
            subtitle: _counsellorSubtitle(profile),
          ),
        ),
      ),
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
        selectedItemBuilder: (context) => [
          const _SelectedCounsellorLabel(
            title: 'Unassigned',
            subtitle: 'No counsellor assigned',
          ),
          ...counsellors.map(
            (profile) => _SelectedCounsellorLabel(
              title: _counsellorTitle(profile),
              subtitle: _counsellorSubtitle(profile),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounsellorMenuTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CounsellorMenuTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: myTextstyle(fontSize: 16, color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: myTextstyle(fontSize: 14, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

class _SelectedCounsellorLabel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SelectedCounsellorLabel({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: myTextstyle(fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: myTextstyle(fontSize: 13, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
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

  final attendance = profile.attendanceStatus?.trim();
  if (attendance != null && attendance.isNotEmpty) {
    metadata.add('Attendance: $attendance');
  } else {
    metadata.add('Attendance: Not marked');
  }

  if (metadata.isNotEmpty) {
    return metadata.join(' • ');
  }

  final email = profile.email?.trim();
  if (email != null && email.isNotEmpty) {
    return email;
  }

  return '';
}
