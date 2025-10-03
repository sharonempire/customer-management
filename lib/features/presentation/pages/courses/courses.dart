import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'Technology',
    'Business',
    'Design',
    'Marketing',
  ];

  final List<String> _levels = const [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<String> _modes = const [
    'Online',
    'Offline',
    'Hybrid',
  ];

  String? _selectedCategory;
  String? _selectedLevel;
  String? _selectedMode;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorConsts.lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorConsts.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorConsts.primaryColor, width: 1.4),
      ),
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find the right course for every learner',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorConsts.secondaryColor,
                              ),
                        ),
                        height5,
                        Text(
                          'Use the filters below to refine your search or add new courses to the catalogue.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ColorConsts.textColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  width20,
                  PrimaryButton(
                    onpressed: () => context.push(
                      '${routerConsts.courseFinder.route}/${routerConsts.addCourse.route}',
                    ),
                    text: 'Add Course',
                    icon: Icons.add,
                  ),
                ],
              ),
              height20,
              Card(
                elevation: 0,
                color: ColorConsts.greyContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search Filters',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConsts.secondaryColor,
                            ),
                      ),
                      height10,
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 260,
                            child: TextField(
                              controller: _searchController,
                              decoration: _inputDecoration(
                                'Keyword',
                                icon: Icons.search,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              items: _categories
                                  .map(
                                    (category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() {
                                _selectedCategory = value;
                              }),
                              decoration: _inputDecoration('Category'),
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            child: DropdownButtonFormField<String>(
                              value: _selectedLevel,
                              items: _levels
                                  .map(
                                    (level) => DropdownMenuItem<String>(
                                      value: level,
                                      child: Text(level),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() {
                                _selectedLevel = value;
                              }),
                              decoration: _inputDecoration('Level'),
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            child: DropdownButtonFormField<String>(
                              value: _selectedMode,
                              items: _modes
                                  .map(
                                    (mode) => DropdownMenuItem<String>(
                                      value: mode,
                                      child: Text(mode),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() {
                                _selectedMode = value;
                              }),
                              decoration: _inputDecoration('Mode'),
                            ),
                          ),
                        ],
                      ),
                      height20,
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              // TODO: trigger search
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Search Courses'),
                          ),
                          width10,
                          TextButton(
                            onPressed: () => setState(() {
                              _searchController.clear();
                              _selectedCategory = null;
                              _selectedLevel = null;
                              _selectedMode = null;
                            }),
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              height30,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ColorConsts.lightGrey),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 56,
                      color: ColorConsts.secondaryColor.withOpacity(0.7),
                    ),
                    height10,
                    Text(
                      'No courses to display yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConsts.secondaryColor,
                          ),
                    ),
                    height5,
                    Text(
                      'Start a search or add your first course to populate this list.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConsts.textColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
