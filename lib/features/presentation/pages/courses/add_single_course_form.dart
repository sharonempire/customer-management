import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/course_finder/controller/course_finder_controller.dart';
import 'package:management_software/features/application/course_finder/controller/course_submission_controller.dart';
import 'package:management_software/features/data/course_finder/model/course_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart'
    show CommonDropdown, CommonTextField;
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class AddSingleCourseScreen extends ConsumerStatefulWidget {
  const AddSingleCourseScreen({super.key});

  @override
  ConsumerState<AddSingleCourseScreen> createState() => _AddSingleCourseScreenState();
}

class _AddSingleCourseScreenState
    extends ConsumerState<AddSingleCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _programName = TextEditingController();
  final _university = TextEditingController();
  final _country = TextEditingController();
  final _city = TextEditingController();
  final _campus = TextEditingController();
  final _applicationFee = TextEditingController();
  final _tuitionFee = TextEditingController();
  final _depositAmount = TextEditingController();
  final _currency = TextEditingController();
  final _duration = TextEditingController();
  final _language = TextEditingController();
  final _studyType = TextEditingController();
  final _programLevel = TextEditingController();
  final _englishProficiency = TextEditingController();
  final _englishScoreDetails = TextEditingController();
  final _minimumPercentage = TextEditingController();
  final _ageLimit = TextEditingController();
  final _academicGap = TextEditingController();
  final _maxBacklogs = TextEditingController();
  final _workExperienceRequirement = TextEditingController();
  final _requiredSubjects = TextEditingController();
  final _intakes = TextEditingController();
  final _links = TextEditingController();
  final _mediaLinks = TextEditingController();
  final _courseDescription = TextEditingController();
  final _specialRequirements = TextEditingController();
  final _commission = TextEditingController();
  final _fieldOfStudy = TextEditingController();

  final _studyTypeOptions = const [
    'On Campus',
    'Online',
    'Hybrid',
  ];

  final _programLevelOptions = const [
    'Foundation',
    'Undergraduate',
    'Postgraduate',
    'Doctorate',
    'Diploma',
  ];

  final _englishTests = const [
    'IELTS',
    'TOEFL iBT',
    'PTE Academic',
    'Duolingo',
    'Cambridge English',
  ];

  final _fieldOfStudyOptions = const [
    'Engineering & Technology',
    'Business & Management',
    'Health Sciences',
    'Arts & Humanities',
    'Computer Science & IT',
    'Hospitality & Tourism',
    'Law & Public Policy',
  ];

  @override
  void dispose() {
    _programName.dispose();
    _university.dispose();
    _country.dispose();
    _city.dispose();
    _campus.dispose();
    _applicationFee.dispose();
    _tuitionFee.dispose();
    _depositAmount.dispose();
    _currency.dispose();
    _duration.dispose();
    _language.dispose();
    _studyType.dispose();
    _programLevel.dispose();
    _englishProficiency.dispose();
    _englishScoreDetails.dispose();
    _minimumPercentage.dispose();
    _ageLimit.dispose();
    _academicGap.dispose();
    _maxBacklogs.dispose();
    _workExperienceRequirement.dispose();
    _requiredSubjects.dispose();
    _intakes.dispose();
    _links.dispose();
    _mediaLinks.dispose();
    _courseDescription.dispose();
    _specialRequirements.dispose();
    _commission.dispose();
    _fieldOfStudy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submissionState = ref.watch(courseSubmissionControllerProvider);

    ref.listen<AsyncValue<Course?>>(
      courseSubmissionControllerProvider,
      (previous, next) {
        next.when(
          data: (course) {
            if (course == null) return;
            ref.read(snackbarServiceProvider).showSuccess(
                  context,
                  'Course added successfully',
                );
            ref.read(courseFinderControllerProvider.notifier).loadCourses();
            Navigator.of(context).pop();
            ref.read(courseSubmissionControllerProvider.notifier).reset();
          },
          error: (error, _) {
            ref.read(snackbarServiceProvider).showError(
                  context,
                  error.toString(),
                );
          },
          loading: () {},
        );
      },
    );

    final isSubmitting = submissionState.isLoading;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppbar(title: 'Add Single Course'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionWidget(
                  title: 'General Information',
                  children: [
                    _rowWithFields([
                      _commonTextField('Program name', _programName, requiredField: true),
                      _commonTextField('University', _university, requiredField: true),
                    ]),
                    _rowWithFields([
                      _commonDropdown('Field of study', _fieldOfStudy, _fieldOfStudyOptions),
                      _commonTextField('Course duration', _duration),
                    ]),
                    _rowWithFields([
                      _commonTextField('Language of instruction', _language),
                      _emptyField(),
                    ]),
                  ],
                ),
                height20,
                _SectionWidget(
                  title: 'Location & Intake',
                  children: [
                    _rowWithFields([
                      _commonTextField('Country', _country, requiredField: true),
                      _commonTextField('City', _city),
                    ]),
                    _rowWithFields([
                      _commonTextField(
                        'Intakes (comma separated)',
                        _intakes,
                        hint: 'e.g. January, May, September',
                      ),
                      _commonTextField('Campus', _campus),
                    ]),
                  ],
                ),
                height20,
                _SectionWidget(
                  title: 'Program Structure',
                  children: [
                    _rowWithFields([
                      _commonDropdown(
                        'Program level',
                        _programLevel,
                        _programLevelOptions,
                      ),
                      _commonDropdown(
                        'Study type',
                        _studyType,
                        _studyTypeOptions,
                      ),
                    ]),
                    _rowWithFields([
                      _commonDropdown(
                        'English proficiency test',
                        _englishProficiency,
                        _englishTests,
                      ),
                      _commonTextField(
                        'Minimum score / proficiency details',
                        _englishScoreDetails,
                        hint: 'e.g. IELTS 6.5 (no band below 6.0)',
                      ),
                    ]),
                    _rowWithFields([
                      _commonTextField('Minimum percentage', _minimumPercentage),
                      _commonTextField('Maximum academic gap', _academicGap),
                    ]),
                    _rowWithFields([
                      _commonTextField('Maximum backlogs', _maxBacklogs),
                      _commonTextField('Age limit', _ageLimit),
                    ]),
                  ],
                ),
                height20,
                _SectionWidget(
                  title: 'Fees & Commission',
                  children: [
                    _rowWithFields([
                      _commonTextField('Application fee', _applicationFee),
                      _commonTextField('Tuition fee', _tuitionFee),
                    ]),
                    _rowWithFields([
                      _commonTextField('Deposit amount', _depositAmount),
                      _commonTextField('Currency', _currency, hint: 'e.g. USD, AUD'),
                    ]),
                    _rowWithFields([
                      _commonTextField('Commission (%)', _commission, keyboardType: TextInputType.number),
                      _commonTextField('Work experience requirement', _workExperienceRequirement),
                    ]),
                  ],
                ),
                height20,
                _SectionWidget(
                  title: 'Requirements & Resources',
                  children: [
                    _rowWithFields([
                      _commonTextField(
                        'Required subjects (comma separated)',
                        _requiredSubjects,
                      ),
                      _commonTextField(
                        'Links (comma separated)',
                        _links,
                      ),
                    ]),
                    _rowWithFields([
                      _commonTextField(
                        'Media links (comma separated)',
                        _mediaLinks,
                      ),
                      _commonTextField(
                        'Special requirements',
                        _specialRequirements,
                      ),
                    ]),
                    Row(
                      children: [
                        CommonTextField(
                          text: 'Course description',
                          controller: _courseDescription,
                          minLines: 3,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ],
                ),
                height30,
                Row(
                  children: [
                    PrimaryButton(
                      onpressed: isSubmitting ? null : _handleSubmit,
                      text: isSubmitting ? 'Saving...' : 'Save Course',
                      icon: Icons.save_alt,
                    ),
                    width20,
                    TextButton(
                      onPressed:
                          isSubmitting ? null : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorConsts.primaryColor,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _rowWithFields(List<Widget> children) =>
      Row(children: _withSpacing(children));

  List<Widget> _withSpacing(List<Widget> children) {
    final result = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      result.add(children[index]);
      if (index != children.length - 1) {
        result.add(width20);
      }
    }
    return result;
  }

  Widget _emptyField() => const Expanded(child: SizedBox.shrink());

  Widget _commonTextField(
    String label,
    TextEditingController controller, {
    bool requiredField = false,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return CommonTextField(
      text: label,
      controller: controller,
      requiredField: requiredField,
      hint: hint,
      keyboardType: keyboardType,
    );
  }

  Widget _commonDropdown(
    String label,
    TextEditingController controller,
    List<String> options,
  ) {
    return CommonDropdown(
      label: label,
      items: options,
      value: controller.text.isNotEmpty ? controller.text : null,
      onChanged: (value) {
        if (value == null) return;
        controller.text = value;
        setState(() {});
      },
    );
  }

  void _handleSubmit() {
    if (ref.read(courseSubmissionControllerProvider).isLoading) return;

    if (_formKey.currentState?.validate() != true) return;

    FocusScope.of(context).unfocus();

    final submissionController =
        ref.read(courseSubmissionControllerProvider.notifier);

    final englishProficiency = [
      _englishProficiency.text.trim(),
      _englishScoreDetails.text.trim(),
    ].where((value) => value.isNotEmpty).join(' | ');

    final course = Course(
      programName: _textOrNull(_programName.text),
      university: _textOrNull(_university.text),
      country: _textOrNull(_country.text),
      city: _textOrNull(_city.text),
      campus: _textOrNull(_campus.text),
      applicationFee: _textOrNull(_applicationFee.text),
      tuitionFee: _textOrNull(_tuitionFee.text),
      depositAmount: _textOrNull(_depositAmount.text),
      currency: _textOrNull(_currency.text),
      duration: _textOrNull(_duration.text),
      language: _textOrNull(_language.text),
      studyType: _textOrNull(_studyType.text),
      programLevel: _textOrNull(_programLevel.text),
      englishProficiency:
          englishProficiency.isEmpty ? null : englishProficiency,
      minimumPercentage: _textOrNull(_minimumPercentage.text),
      ageLimit: _textOrNull(_ageLimit.text),
      academicGap: _textOrNull(_academicGap.text),
      maxBacklogs: _textOrNull(_maxBacklogs.text),
      workExperienceRequirement:
          _textOrNull(_workExperienceRequirement.text),
      requiredSubjects: _splitToList(_requiredSubjects.text),
      intakes: _splitToList(_intakes.text),
      links: _splitToList(_links.text),
      mediaLinks: _splitToList(_mediaLinks.text),
      courseDescription: _textOrNull(_courseDescription.text),
      specialRequirements: _textOrNull(_specialRequirements.text),
      commission: _parseInt(_commission.text),
      fieldOfStudy: _textOrNull(_fieldOfStudy.text),
    );

    submissionController.submitCourse(course: course);
  }

  String? _textOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  int? _parseInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }

  List<String>? _splitToList(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    final list = trimmed
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return list.isEmpty ? null : list;
  }
}

class _SectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionWidget({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConsts.lightGrey),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConsts.secondaryColor,
                ),
          ),
          height10,
          ...children,
        ],
      ),
    );
  }
}
