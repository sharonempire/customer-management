import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:management_software/features/application/authentification/controller/auth_controller.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/widgets/h1_widget.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';

class ProfileEditPopup extends ConsumerStatefulWidget {
  final String displayName;
  final String? profilePicture;
  final String designation;
  final String phone;
  final String location;
  final String email;

  const ProfileEditPopup({
    super.key,
    required this.displayName,
    this.profilePicture,
    required this.designation,
    required this.email,
    required this.phone,
    required this.location,
  });

  @override
  ConsumerState<ProfileEditPopup> createState() => _ProfileEditPopupState();
}

class _ProfileEditPopupState extends ConsumerState<ProfileEditPopup> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageFile;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
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
    emailController = TextEditingController(text: widget.email);
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
      _imageFile = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const H1Widget(title: "Edit Profile"),
                const SizedBox(height: 16),

                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: ColorConsts.lightGrey,
                      backgroundImage:
                          _imageFile != null
                              ? MemoryImage(_imageFile!)
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

                Row(
                  children: [
                    CommonTextField(
                      text: "Display Name",
                      controller: nameController,
                      requiredField: true,
                      icon: Icons.person,
                    ),
                  ],
                ),

                // Phone Field
                Row(
                  children: [
                    CommonTextField(
                      text: "Phone",
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      requiredField: true,
                      icon: Icons.phone,
                    ),
                  ],
                ),
                Row(
                  children: [
                    CommonTextField(
                      text: "Email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      requiredField: true,
                      icon: Icons.email,
                    ),
                  ],
                ),

                Row(
                  children: [
                    CommonDropdown(
                      label: "Designation",
                      value: selectedDesignation,
                      items: designationOptions,
                      onChanged: (value) {
                        setState(() {
                          selectedDesignation = value ?? selectedDesignation;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    CommonTextField(
                      text: "Location",
                      controller: locationController,
                      icon: Icons.location_on,
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      width20,
                      PrimaryButton(
                        icon: Icons.save,
                        text: "Save",
                        onpressed: () async {
                          if (_imageFile == null &&
                              (widget.profilePicture != null &&
                                  widget.profilePicture!.isEmpty)) {
                            ref
                                .read(snackbarServiceProvider)
                                .showError(context, "Pick an image");
                          } else {
                            final String fileName =
                                'profile_${DateTime.now().millisecondsSinceEpoch}.png';

                            final pictureUrl = await ref
                                .read(networkServiceProvider)
                                .uploadFile(
                                  bucketName: SupabaseBuckets.userImages,
                                  filePath: fileName,
                                  fileBytes: _imageFile,
                                );

                            await ref
                                .read(authControllerProvider.notifier)
                                .updateUserProfile(
                                  context: context,
                                  updatedData:
                                      UserProfileModel(
                                        displayName: nameController.text,
                                        profilePicture:
                                            _imageFile != null
                                                ? pictureUrl
                                                : widget.profilePicture ??
                                                    pictureUrl,
                                        designation: selectedDesignation,
                                        phone: int.parse(phoneController.text),
                                        location: locationController.text,
                                      ).toJson(),
                                )
                                .then((value) {
                                  Navigator.pop(context);
                                });
                          }
                        },
                      ),
                    ],
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
