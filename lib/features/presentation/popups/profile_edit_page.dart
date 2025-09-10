import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:management_software/features/presentation/widgets/common_dropdowns.dart';
import 'package:management_software/features/presentation/widgets/common_textfield.dart';
import 'package:management_software/features/presentation/widgets/h1_widget.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class ProfileEditPopup extends StatefulWidget {
  final String displayName;
  final String? profilePicture;
  final String designation;
  final String phone;
  final String location;
  final Function(
    String name,
    String? picture,
    String designation,
    String phone,
    String location,
  )
  onSave;

  const ProfileEditPopup({
    super.key,
    required this.displayName,
    this.profilePicture,
    required this.designation,
    required this.phone,
    required this.location,
    required this.onSave,
  });

  @override
  State<ProfileEditPopup> createState() => _ProfileEditPopupState();
}

class _ProfileEditPopupState extends State<ProfileEditPopup> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
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
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.displayName);
    phoneController = TextEditingController(text: widget.phone);
    locationController = TextEditingController(text: widget.location);
    selectedDesignation =
        widget.designation.isNotEmpty
            ? widget.designation
            : designationOptions[0];
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const H1Widget(title: "Edit Profile"),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: ColorConsts.lightGrey,
                    backgroundImage:
                        _imageFile != null
                            ? FileImage(_imageFile!)
                            : (widget.profilePicture != null &&
                                widget.profilePicture!.isNotEmpty)
                            ? NetworkImage(widget.profilePicture!)
                            : null,
                    child:
                        (_imageFile == null &&
                                (widget.profilePicture == null ||
                                    widget.profilePicture!.isEmpty))
                            ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name Field
              textField(nameController, "Display Name", required: true),

              // Phone Field
              textField(
                phoneController,
                "Phone",
                keyboard: TextInputType.phone,
                required: true,
              ),
              // Designation Dropdown
              dropdownField(
                label: "Designation",
                value: selectedDesignation,
                items: designationOptions,
                onChanged: (value) {
                  setState(() {
                    selectedDesignation = value ?? selectedDesignation;
                  });
                },
              ),
              const SizedBox(height: 8),

              // Location Field
              textField(locationController, "Location"),

              const SizedBox(height: 20),
              PrimaryButton(
                text: "Save",
                onpressed: () {
                  widget.onSave(
                    nameController.text,
                    _imageFile?.path,
                    selectedDesignation,
                    phoneController.text,
                    locationController.text,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
