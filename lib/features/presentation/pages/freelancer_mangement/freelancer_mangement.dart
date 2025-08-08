import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:management_software/features/presentation/widgets/h1_widget.dart';

class FreelancerMangement extends ConsumerStatefulWidget {
  const FreelancerMangement({super.key});

  @override
  ConsumerState<FreelancerMangement> createState() =>
      _FreelancerMangementState();
}

class _FreelancerMangementState extends ConsumerState<FreelancerMangement> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H1Widget(title: 'Settings'),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              tileColor: Theme.of(context).colorScheme.surfaceContainer,
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              trailing: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['xlsx', 'xls'],
                    withData: true,
                  );
                  if (result != null && result.files.single.bytes != null) {}
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Select Excel File'),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
