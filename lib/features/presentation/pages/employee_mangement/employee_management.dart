import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/authentification/controller/auth_controller.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';

class EmployeeManagement extends ConsumerStatefulWidget {
  const EmployeeManagement({super.key});

  @override
  ConsumerState<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends ConsumerState<EmployeeManagement> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  String selectedDesignation = "Admin";
  final List<String> designationOptions = [
    "Admin",
    "Counsellor",
    "Counsellor Head",
    "Processing Officer",
    "Marketing",
    "Tutors",
    "HR",
    "Premium Country Head",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CommonAppbar(title: "Employee Management"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      CommonTextField(
                        text: "Email",
                        controller: emailController,
                      ),
                      CommonTextField(text: "Name", controller: nameController),
                      CommonDropdown(
                        label: "Designation",
                        items: designationOptions,
                        onChanged: (val) {
                          selectedDesignation = val ?? 'Admin';
                          setState(() {});
                        },
                      ),
                      PrimaryButton(
                        onpressed: () {
                          final uniqueId =
                              ref
                                  .read(authControllerProvider.notifier)
                                  .generateUniqueId();
                          ref
                              .read(authControllerProvider.notifier)
                              .addEmployee(
                                context: context,
                                updatedData:
                                    UserProfileModel(
                                      id: uniqueId,
                                      email: emailController.text,
                                      displayName: nameController.text,
                                      designation: selectedDesignation,
                                    ).toJson(),
                              );
                        },
                        text: "Save",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
