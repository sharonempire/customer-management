import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/presentation/pages/courses/widgets/course_finder_header.dart';
import 'package:management_software/features/presentation/pages/courses/widgets/course_filters_panel.dart';
import 'package:management_software/features/presentation/pages/courses/widgets/course_results_section.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart'
    show CommonDropdown, CommonTextField;
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/routes/router_consts.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  final TextEditingController _programController = TextEditingController();
  final TextEditingController _minEnglishScoreController = TextEditingController();

  final List<String> _students = const [
    'Aaron Thomas',
    'Bianca Matthews',
    'Carlos Mendes',
    'Deepika Verma',
    'Ethan Clarke',
  ];

  final List<String> _intakes = const [
    'January 2025',
    'May 2025',
    'September 2025',
  ];

  final List<String> _countries = const [
    'Australia',
    'Canada',
    'Germany',
    'United Kingdom',
    'United States',
  ];

  final List<String> _cities = const [
    'Sydney',
    'Toronto',
    'Berlin',
    'London',
    'New York',
  ];

  final List<String> _commissionTiers = const [
    'Tier 1 (20% +)',
    'Tier 2 (15% - 19%)',
    'Tier 3 (10% - 14%)',
    'Tier 4 (< 10%)',
  ];

  final List<String> _studyTypes = const [
    'On Campus',
    'Online',
    'Hybrid',
  ];

  final List<String> _fieldsOfStudy = const [
    'Engineering & Technology',
    'Business & Management',
    'Health Sciences',
    'Arts & Humanities',
    'Computer Science & IT',
  ];

  final List<String> _programLevels = const [
    'Foundation',
    'Undergraduate',
    'Postgraduate',
    'Doctorate',
  ];

  final List<String> _currencies = const [
    'AUD',
    'CAD',
    'EUR',
    'GBP',
    'USD',
  ];

  final List<String> _languages = const [
    'English',
    'French',
    'German',
    'Spanish',
  ];

  final List<String> _englishTests = const [
    'IELTS',
    'TOEFL iBT',
    'PTE Academic',
    'Duolingo',
  ];

  String? _selectedStudent;
  String? _selectedIntake;
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedCommissionTier;
  String? _selectedStudyType;
  String? _selectedFieldOfStudy;
  String? _selectedProgramLevel;
  String? _selectedCurrency;
  String? _selectedLanguage;
  String? _selectedEnglishTest;

  final List<CourseListItem> _sampleCourses = const [
    CourseListItem(
      programName: 'BSc Computer Science',
      university: 'University of Toronto',
      country: 'Canada',
      city: 'Toronto',
      campus: 'St. George Campus',
      tuitionFee: '32,000',
      studyType: 'On Campus',
      programLevel: 'Undergraduate',
      duration: '4 years',
      intake: 'September 2025',
      englishRequirement: 'IELTS 6.5 (no band below 6.0)',
      commission: '15%',
      currency: 'CAD',
      tags: ['STEM', 'Scholarship Eligible', 'Co-op Available'],
    ),
    CourseListItem(
      programName: 'MBA (International Business)',
      university: 'University of Sydney',
      country: 'Australia',
      city: 'Sydney',
      campus: 'Darlington Campus',
      tuitionFee: '44,500',
      studyType: 'Hybrid',
      programLevel: 'Postgraduate',
      duration: '18 months',
      intake: 'January 2025',
      englishRequirement: 'IELTS 7.0 (no band below 6.5)',
      commission: '18%',
      currency: 'AUD',
      tags: ['Management', 'Tier 1 Commission'],
    ),
    CourseListItem(
      programName: 'MSc Data Analytics',
      university: 'King’s College London',
      country: 'United Kingdom',
      city: 'London',
      campus: 'Strand Campus',
      tuitionFee: '28,000',
      studyType: 'On Campus',
      programLevel: 'Postgraduate',
      duration: '1 year',
      intake: 'May 2025',
      englishRequirement: 'IELTS 6.5 or TOEFL 92',
      commission: '12%',
      currency: 'GBP',
      tags: ['Analytics', 'Internship Support'],
    ),
  ];

  @override
  void dispose() {
    _programController.dispose();
    _minEnglishScoreController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    // TODO: trigger search with repository
  }

  void _resetFilters() {
    setState(() {
      _programController.clear();
      _minEnglishScoreController.clear();
      _selectedStudent = null;
      _selectedIntake = null;
      _selectedCountry = null;
      _selectedCity = null;
      _selectedCommissionTier = null;
      _selectedStudyType = null;
      _selectedFieldOfStudy = null;
      _selectedProgramLevel = null;
      _selectedCurrency = null;
      _selectedLanguage = null;
      _selectedEnglishTest = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routerConsts = RouterConsts();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppbar(title: "Course Finder"),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 1100;
            final filtersPanelWidth = isWide ? 420.0 : double.infinity;
            final filterSections = _buildFilterSections(twoColumn: false);
            final filtersPanel = CourseFiltersPanel(
              sections: filterSections,
              onSearch: _handleSearch,
              onClear: _resetFilters,
            );
            final resultsPanel = CourseResultsSection(courses: _sampleCourses);
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CourseFinderHeader(
                    onAddCourse: () => context.push(
                      '${routerConsts.courseFinder.route}/${routerConsts.addCourse.route}',
                    ),
                  ),
                  height20,
                  isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: filtersPanelWidth,
                              child: filtersPanel,
                            ),
                            width30,
                            Expanded(child: resultsPanel),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            filtersPanel,
                            height20,
                            resultsPanel,
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<CourseFilterSectionData> _buildFilterSections({required bool twoColumn}) {
    if (!twoColumn) {
      return [
        CourseFilterSectionData(
          title: 'Student Match',
          rows: [
            _rowWithControls([
              CommonDropdown(
                label: 'Match with student',
                items: _students,
                value: _selectedStudent,
                onChanged: (value) => setState(() {
                  _selectedStudent = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonTextField(
                text: 'Program name',
                controller: _programController,
                icon: Icons.search,
              ),
            ], addSpacing: false),
          ],
        ),
        CourseFilterSectionData(
          title: 'Location & Intake',
          rows: [
            _rowWithControls([
              CommonDropdown(
                label: 'Intake',
                items: _intakes,
                value: _selectedIntake,
                onChanged: (value) => setState(() {
                  _selectedIntake = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Country',
                items: _countries,
                value: _selectedCountry,
                onChanged: (value) => setState(() {
                  _selectedCountry = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'City',
                items: _cities,
                value: _selectedCity,
                onChanged: (value) => setState(() {
                  _selectedCity = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Commission tier',
                items: _commissionTiers,
                value: _selectedCommissionTier,
                onChanged: (value) => setState(() {
                  _selectedCommissionTier = value;
                }),
              ),
            ], addSpacing: false),
          ],
        ),
        CourseFilterSectionData(
          title: 'Program Details',
          rows: [
            _rowWithControls([
              CommonDropdown(
                label: 'Study type',
                items: _studyTypes,
                value: _selectedStudyType,
                onChanged: (value) => setState(() {
                  _selectedStudyType = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Field of study',
                items: _fieldsOfStudy,
                value: _selectedFieldOfStudy,
                onChanged: (value) => setState(() {
                  _selectedFieldOfStudy = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Program level',
                items: _programLevels,
                value: _selectedProgramLevel,
                onChanged: (value) => setState(() {
                  _selectedProgramLevel = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Currency',
                items: _currencies,
                value: _selectedCurrency,
                onChanged: (value) => setState(() {
                  _selectedCurrency = value;
                }),
              ),
            ], addSpacing: false),
          ],
        ),
        CourseFilterSectionData(
          title: 'Language & Requirements',
          rows: [
            _rowWithControls([
              CommonDropdown(
                label: 'Teaching language',
                items: _languages,
                value: _selectedLanguage,
                onChanged: (value) => setState(() {
                  _selectedLanguage = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'English proficiency test',
                items: _englishTests,
                value: _selectedEnglishTest,
                onChanged: (value) => setState(() {
                  _selectedEnglishTest = value;
                }),
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonTextField(
                text: 'Min. score (e.g. IELTS 6.5)',
                controller: _minEnglishScoreController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ], addSpacing: false),
          ],
        ),
      ];
    }

    return [
      CourseFilterSectionData(
        title: 'Student Match',
        rows: [
          _rowWithControls([
            CommonDropdown(
              label: 'Match with student',
              items: _students,
              value: _selectedStudent,
              onChanged: (value) => setState(() {
                _selectedStudent = value;
              }),
            ),
            CommonTextField(
              text: 'Program name',
              controller: _programController,
              icon: Icons.search,
            ),
          ]),
        ],
      ),
      CourseFilterSectionData(
        title: 'Location & Intake',
        rows: [
          _rowWithControls([
            CommonDropdown(
              label: 'Intake',
              items: _intakes,
              value: _selectedIntake,
              onChanged: (value) => setState(() {
                _selectedIntake = value;
              }),
            ),
            CommonDropdown(
              label: 'Country',
              items: _countries,
              value: _selectedCountry,
              onChanged: (value) => setState(() {
                _selectedCountry = value;
              }),
            ),
          ]),
          _rowWithControls([
            CommonDropdown(
              label: 'City',
              items: _cities,
              value: _selectedCity,
              onChanged: (value) => setState(() {
                _selectedCity = value;
              }),
            ),
            CommonDropdown(
              label: 'Commission tier',
              items: _commissionTiers,
              value: _selectedCommissionTier,
              onChanged: (value) => setState(() {
                _selectedCommissionTier = value;
              }),
            ),
          ]),
        ],
      ),
      CourseFilterSectionData(
        title: 'Program Details',
        rows: [
          _rowWithControls([
            CommonDropdown(
              label: 'Study type',
              items: _studyTypes,
              value: _selectedStudyType,
              onChanged: (value) => setState(() {
                _selectedStudyType = value;
              }),
            ),
            CommonDropdown(
              label: 'Field of study',
              items: _fieldsOfStudy,
              value: _selectedFieldOfStudy,
              onChanged: (value) => setState(() {
                _selectedFieldOfStudy = value;
              }),
            ),
          ]),
          _rowWithControls([
            CommonDropdown(
              label: 'Program level',
              items: _programLevels,
              value: _selectedProgramLevel,
              onChanged: (value) => setState(() {
                _selectedProgramLevel = value;
              }),
            ),
            CommonDropdown(
              label: 'Currency',
              items: _currencies,
              value: _selectedCurrency,
              onChanged: (value) => setState(() {
                _selectedCurrency = value;
              }),
            ),
          ]),
        ],
      ),
      CourseFilterSectionData(
        title: 'Language & Requirements',
        rows: [
          _rowWithControls([
            CommonDropdown(
              label: 'Teaching language',
              items: _languages,
              value: _selectedLanguage,
              onChanged: (value) => setState(() {
                _selectedLanguage = value;
              }),
            ),
            CommonDropdown(
              label: 'English proficiency test',
              items: _englishTests,
              value: _selectedEnglishTest,
              onChanged: (value) => setState(() {
                _selectedEnglishTest = value;
              }),
            ),
          ]),
          _rowWithControls([
            CommonTextField(
              text: 'Min. score (e.g. IELTS 6.5)',
              controller: _minEnglishScoreController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ], addSpacing: false),
        ],
      ),
    ];
  }

  Widget _rowWithControls(List<Widget> controls, {bool addSpacing = true}) {
    final children = <Widget>[];
    for (var index = 0; index < controls.length; index++) {
      children.add(controls[index]);
      if (addSpacing && index != controls.length - 1) {
        children.add(width20);
      }
    }
    return Row(children: children);
  }
}
