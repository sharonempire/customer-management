import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/course_finder/controller/course_finder_controller.dart';
import 'package:management_software/features/data/course_finder/model/course_model.dart';
import 'package:management_software/features/domain/course_finder/course_repository.dart';

final courseImportControllerProvider =
    StateNotifierProvider<CourseImportController, AsyncValue<int>>( (
      ref,
    ) {
      final repository = ref.watch(courseFinderRepositoryProvider);
      return CourseImportController(repository: repository);
    });

class CourseImportController extends StateNotifier<AsyncValue<int>> {
  CourseImportController({required CourseFinderRepository repository})
    : _repository = repository,
      super(const AsyncValue.data(0));

  final CourseFinderRepository _repository;

  static const Set<String> _listFields = {
    'required_subjects',
    'intakes',
    'links',
    'media_links',
  };

  static const Map<String, String> _fieldAliases = {
    'program': 'program_name',
    'program_name': 'program_name',
    'course': 'program_name',
    'course_name': 'program_name',
    'university': 'university',
    'university_name': 'university',
    'country': 'country',
    'city': 'city',
    'campus': 'campus',
    'application_fee': 'application_fee',
    'applicationfees': 'application_fee',
    'tuition_fee': 'tuition_fee',
    'tuitionfees': 'tuition_fee',
    'deposit': 'deposit_amount',
    'deposit_amount': 'deposit_amount',
    'currency': 'currency',
    'duration': 'duration',
    'course_duration': 'duration',
    'language': 'language',
    'language_of_instruction': 'language',
    'study_type': 'study_type',
    'mode_of_study': 'study_type',
    'program_level': 'program_level',
    'level': 'program_level',
    'english_proficiency': 'english_proficiency',
    'english_requirement': 'english_proficiency',
    'minimum_percentage': 'minimum_percentage',
    'minimum_percent': 'minimum_percentage',
    'age_limit': 'age_limit',
    'academic_gap': 'academic_gap',
    'max_backlogs': 'max_backlogs',
    'maximum_backlogs': 'max_backlogs',
    'work_experience_requirement': 'work_experience_requirement',
    'experience_requirement': 'work_experience_requirement',
    'required_subjects': 'required_subjects',
    'subjects_required': 'required_subjects',
    'intakes': 'intakes',
    'intake': 'intakes',
    'links': 'links',
    'media_links': 'media_links',
    'media': 'media_links',
    'course_description': 'course_description',
    'description': 'course_description',
    'special_requirements': 'special_requirements',
    'commission': 'commission',
    'field_of_study': 'field_of_study',
    'fieldofstudy': 'field_of_study',
  };

  Future<void> importFromBytes({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final extension = _extractExtension(fileName);
    if (!_supportedExtensions.contains(extension)) {
      state = AsyncValue.error(
        'Unsupported file type “$extension”. Please upload CSV or Excel files.',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();

    try {
      final rawRows = _parseFile(bytes: bytes, extension: extension);
      final courses = rawRows
          .map(_mapRowToCourse)
          .whereType<Course>()
          .toList(growable: false);

      if (courses.isEmpty) {
        throw 'No valid course rows found in the selected file.';
      }

      final insertedCount = await _repository.importCourses(courses);
      state = AsyncValue.data(insertedCount);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(0);
  }

  static const Set<String> _supportedExtensions = {'csv', 'xlsx', 'xls'};

  String _extractExtension(String fileName) {
    final segments = fileName.split('.');
    if (segments.length < 2) return '';
    return segments.last.toLowerCase();
  }

  List<Map<String, dynamic>> _parseFile({
    required Uint8List bytes,
    required String extension,
  }) {
    switch (extension) {
      case 'csv':
        return _parseCsv(bytes);
      case 'xlsx':
      case 'xls':
        return _parseExcel(bytes);
      default:
        throw 'Unsupported file extension: $extension';
    }
  }

  List<Map<String, dynamic>> _parseCsv(Uint8List bytes) {
    final content = utf8.decode(bytes, allowMalformed: true);
    final converter = const CsvToListConverter(shouldParseNumbers: false);
    final rows = converter.convert(content);

    if (rows.isEmpty) {
      throw 'The CSV file is empty.';
    }

    final headers = rows.first.map((value) => value?.toString() ?? '').toList();
    return _rowsToMaps(headers, rows.skip(1));
  }

  List<Map<String, dynamic>> _parseExcel(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) {
      throw 'The Excel file does not contain any sheets.';
    }

    final firstTable = excel.tables.values.first;
    final rows = firstTable.rows;

    if (rows.isEmpty) {
      throw 'The Excel sheet is empty.';
    }

    final headers = rows.first
        .map((cell) => cell?.value?.toString() ?? '')
        .toList(growable: false);

    final dataRows = rows
        .skip(1)
        .map(
          (row) => row
              .map((cell) => cell?.value)
              .toList(growable: false),
        );

    return _rowsToMaps(headers, dataRows);
  }

  List<Map<String, dynamic>> _rowsToMaps(
    List<String> headers,
    Iterable<List<dynamic>> rows,
  ) {
    final normalizedHeaders = headers
        .map((header) => _fieldAliases[_normalizeHeader(header)] ??
            _normalizeHeader(header))
        .toList(growable: false);

    final allowedHeaders = normalizedHeaders
        .map((header) => _allowedFields.contains(header) ? header : null)
        .toList(growable: false);

    final mappedRows = <Map<String, dynamic>>[];

    for (final row in rows) {
      if (_isRowEmpty(row)) continue;

      final map = <String, dynamic>{};

      for (var index = 0; index < row.length && index < allowedHeaders.length; index++) {
        final key = allowedHeaders[index];
        if (key == null) continue;

        final value = row[index];
        final stringValue = value?.toString().trim();
        if (stringValue == null || stringValue.isEmpty) continue;

        map[key] = stringValue;
      }

      if (map.isNotEmpty) {
        mappedRows.add(map);
      }
    }

    return mappedRows;
  }

  bool _isRowEmpty(List<dynamic> row) {
    for (final value in row) {
      if (value == null) continue;
      if (value.toString().trim().isNotEmpty) return false;
    }
    return true;
  }

  Course? _mapRowToCourse(Map<String, dynamic> row) {
    if (!row.containsKey('program_name') ||
        !row.containsKey('university')) {
      return null;
    }

    final listFields = <String, List<String>?>{};
    for (final field in _listFields) {
      listFields[field] = _parseList(row[field]);
    }

    return Course(
      programName: _stringOrNull(row['program_name']),
      university: _stringOrNull(row['university']),
      country: _stringOrNull(row['country']),
      city: _stringOrNull(row['city']),
      campus: _stringOrNull(row['campus']),
      applicationFee: _stringOrNull(row['application_fee']),
      tuitionFee: _stringOrNull(row['tuition_fee']),
      depositAmount: _stringOrNull(row['deposit_amount']),
      currency: _stringOrNull(row['currency']),
      duration: _stringOrNull(row['duration']),
      language: _stringOrNull(row['language']),
      studyType: _stringOrNull(row['study_type']),
      programLevel: _stringOrNull(row['program_level']),
      englishProficiency: _stringOrNull(row['english_proficiency']),
      minimumPercentage: _stringOrNull(row['minimum_percentage']),
      ageLimit: _stringOrNull(row['age_limit']),
      academicGap: _stringOrNull(row['academic_gap']),
      maxBacklogs: _stringOrNull(row['max_backlogs']),
      workExperienceRequirement:
          _stringOrNull(row['work_experience_requirement']),
      requiredSubjects: listFields['required_subjects'],
      intakes: listFields['intakes'],
      links: listFields['links'],
      mediaLinks: listFields['media_links'],
      courseDescription: _stringOrNull(row['course_description']),
      specialRequirements: _stringOrNull(row['special_requirements']),
      commission: _parseInt(row['commission']),
      fieldOfStudy: _stringOrNull(row['field_of_study']),
    );
  }

  List<String>? _parseList(dynamic value) {
    if (value == null) return null;

    if (value is List) {
      final normalized = value
          .map((item) => item?.toString().trim())
          .whereType<String>()
          .where((item) => item.isNotEmpty)
          .toList();
      return normalized.isEmpty ? null : normalized;
    }

    final text = value.toString();
    if (text.trim().isEmpty) return null;

    final items = text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return items.isEmpty ? null : items;
  }

  String? _stringOrNull(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  String _normalizeHeader(String header) {
    final normalized = header
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    return normalized.replaceAll(RegExp(r'^_|_$'), '');
  }

  static const Set<String> _allowedFields = {
    'program_name',
    'university',
    'country',
    'city',
    'campus',
    'application_fee',
    'tuition_fee',
    'deposit_amount',
    'currency',
    'duration',
    'language',
    'study_type',
    'program_level',
    'english_proficiency',
    'minimum_percentage',
    'age_limit',
    'academic_gap',
    'max_backlogs',
    'work_experience_requirement',
    'required_subjects',
    'intakes',
    'links',
    'media_links',
    'course_description',
    'special_requirements',
    'commission',
    'field_of_study',
  };
}
