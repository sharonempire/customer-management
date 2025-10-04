import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/course_finder/controller/course_finder_controller.dart';
import 'package:management_software/features/domain/course_finder/course_repository.dart';
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

  @override
  void dispose() {
    _programController.dispose();
    _minEnglishScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routerConsts = RouterConsts();
    final courseState = ref.watch(courseFinderControllerProvider);
    final isResultsLoading = courseState.isLoading;
    final courseItems = courseState.courses
        .map(CourseListItem.fromCourse)
        .toList(growable: false);
    final resultsPanel = CourseResultsSection(
      courses: courseItems,
      isLoading: isResultsLoading,
      errorMessage: courseState.errorMessage,
    );
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
              isProcessing: isResultsLoading,
            );
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
                onChanged: (value) {
                  if (value.isEmpty) {
                    _applyFilters();
                  }
                },
                onSubmitted: (_) => _applyFilters(),
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
                onChanged: (value) {
                  setState(() {
                    _selectedIntake = value;
                  });
                  _applyFilters();
                },
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Country',
                items: _countries,
                value: _selectedCountry,
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                  _applyFilters();
                },
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'City',
                items: _cities,
                value: _selectedCity,
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                  _applyFilters();
                },
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Commission tier',
                items: _commissionTiers,
                value: _selectedCommissionTier,
                onChanged: (value) {
                  setState(() {
                    _selectedCommissionTier = value;
                  });
                  _applyFilters();
                },
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
                onChanged: (value) {
                  setState(() {
                    _selectedStudyType = value;
                  });
                  _applyFilters();
                },
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Field of study',
                items: _fieldsOfStudy,
                value: _selectedFieldOfStudy,
                onChanged: (value) {
                  setState(() {
                    _selectedFieldOfStudy = value;
                  });
                  _applyFilters();
                },
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Program level',
                items: _programLevels,
                value: _selectedProgramLevel,
                onChanged: (value) {
                  setState(() {
                    _selectedProgramLevel = value;
                  });
                  _applyFilters();
                },
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'Currency',
                items: _currencies,
                value: _selectedCurrency,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                  _applyFilters();
                },
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
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  _applyFilters();
                },
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonDropdown(
                label: 'English proficiency test',
                items: _englishTests,
                value: _selectedEnglishTest,
                onChanged: (value) {
                  setState(() {
                    _selectedEnglishTest = value;
                  });
                  _applyFilters();
                },
              ),
            ], addSpacing: false),
            _rowWithControls([
              CommonTextField(
                text: 'Min. score (e.g. IELTS 6.5)',
                controller: _minEnglishScoreController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _applyFilters(),
                onSubmitted: (_) => _applyFilters(),
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
              onChanged: (value) {
                if (value.isEmpty) {
                  _applyFilters();
                }
              },
              onSubmitted: (_) => _applyFilters(),
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
              onChanged: (value) {
                setState(() {
                  _selectedIntake = value;
                });
                _applyFilters();
              },
            ),
            CommonDropdown(
              label: 'Country',
              items: _countries,
              value: _selectedCountry,
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                });
                _applyFilters();
              },
            ),
          ]),
          _rowWithControls([
            CommonDropdown(
              label: 'City',
              items: _cities,
              value: _selectedCity,
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
                _applyFilters();
              },
            ),
            CommonDropdown(
              label: 'Commission tier',
              items: _commissionTiers,
              value: _selectedCommissionTier,
              onChanged: (value) {
                setState(() {
                  _selectedCommissionTier = value;
                });
                _applyFilters();
              },
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
              onChanged: (value) {
                setState(() {
                  _selectedStudyType = value;
                });
                _applyFilters();
              },
            ),
            CommonDropdown(
              label: 'Field of study',
              items: _fieldsOfStudy,
              value: _selectedFieldOfStudy,
              onChanged: (value) {
                setState(() {
                  _selectedFieldOfStudy = value;
                });
                _applyFilters();
              },
            ),
          ]),
          _rowWithControls([
            CommonDropdown(
              label: 'Program level',
              items: _programLevels,
              value: _selectedProgramLevel,
              onChanged: (value) {
                setState(() {
                  _selectedProgramLevel = value;
                });
                _applyFilters();
              },
            ),
            CommonDropdown(
              label: 'Currency',
              items: _currencies,
              value: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value;
                });
                _applyFilters();
              },
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
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
                _applyFilters();
              },
            ),
            CommonDropdown(
              label: 'English proficiency test',
              items: _englishTests,
              value: _selectedEnglishTest,
              onChanged: (value) {
                setState(() {
                  _selectedEnglishTest = value;
                });
                _applyFilters();
              },
            ),
          ]),
          _rowWithControls([
            CommonTextField(
              text: 'Min. score (e.g. IELTS 6.5)',
              controller: _minEnglishScoreController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _applyFilters(),
              onSubmitted: (_) => _applyFilters(),
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

  void _handleSearch() {
    _applyFilters();
  }

  void _resetFilters() {
    _programController.clear();
    _minEnglishScoreController.clear();
    setState(() {
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
    ref.read(courseFinderControllerProvider.notifier).resetFilters();
  }

  void _applyFilters() {
    final filters = CourseFinderFilters(
      programQuery: _valueOrNull(_programController.text),
      intake: _selectedIntake,
      country: _selectedCountry,
      city: _selectedCity,
      commissionTier: _selectedCommissionTier,
      studyType: _selectedStudyType,
      fieldOfStudy: _selectedFieldOfStudy,
      programLevel: _selectedProgramLevel,
      currency: _selectedCurrency,
      language: _selectedLanguage,
      englishTest: _selectedEnglishTest,
      minEnglishScore: _valueOrNull(_minEnglishScoreController.text),
    );

    ref.read(courseFinderControllerProvider.notifier).applyFilters(filters);
  }

  String? _valueOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
