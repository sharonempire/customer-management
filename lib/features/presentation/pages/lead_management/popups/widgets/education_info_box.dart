import 'package:flutter/material.dart';
import 'package:management_software/features/data/dropdown_datas/deciplines.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class EducationInfoCollection extends StatefulWidget {
  const EducationInfoCollection({super.key});

  @override
  State<EducationInfoCollection> createState() =>
      _EducationInfoCollectionState();
}

class _EducationInfoCollectionState extends State<EducationInfoCollection> {
  String selectedDecipline = "Engineering & Technology";
  String selectedSpecialization = "";
  final TextEditingController passoutController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController backlogsController = TextEditingController();

  @override
  void initState() {
    selectedSpecialization =
        disciplines
            .where((e) => e.name == selectedDecipline)
            .first
            .specializations
            .map((e) => e)
            .toList()
            .first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubHeading(text: "High School(+2)"),
          Row(
            children: [
              CommonDropdown(
                label: "Board",
                items: [
                  "CBSE",
                  "CISCE (ICSE / ISC)",
                  "NIOS",
                  "IB (International Baccalaureate)",
                  "Cambridge International (CIE/CAIE)",
                  "Andhra Pradesh Board of Intermediate Education (BIEAP)",
                  "Assam Higher Secondary Education Council (AHSEC)",
                  "Bihar School Examination Board (BSEB)",
                  "Chhattisgarh Board of Secondary Education (CGBSE)",
                  "Goa Board of Secondary and Higher Secondary Education (GBSHSE)",
                  "Gujarat Secondary and Higher Secondary Education Board (GSEB)",
                  "Haryana Board of School Education (BSEH)",
                  "Himachal Pradesh Board of School Education (HPBOSE)",
                  "Jammu and Kashmir Board of School Education (JKBOSE)",
                  "Jharkhand Academic Council (JAC)",
                  "Karnataka Pre-University Education Board (PUE/KSEEB)",
                  "Kerala Board of Higher Secondary Education (DHSE Kerala)",
                  "Madhya Pradesh Board of Secondary Education (MPBSE)",
                  "Maharashtra State Board of Secondary and Higher Secondary Education (MSBSHSE)",
                  "Manipur Council of Higher Secondary Education (COHSEM)",
                  "Meghalaya Board of School Education (MBOSE)",
                  "Mizoram Board of School Education (MBSE)",
                  "Nagaland Board of School Education (NBSE)",
                  "Odisha Council of Higher Secondary Education (CHSE Odisha)",
                  "Punjab School Education Board (PSEB)",
                  "Rajasthan Board of Secondary Education (RBSE)",
                  "Tamil Nadu State Board (TNBSE)",
                  "Telangana Board of Intermediate Education (TSBIE)",
                  "Tripura Board of Secondary Education (TBSE)",
                  "Uttar Pradesh Madhyamik Shiksha Parishad (UPMSP)",
                  "Uttarakhand Board of School Education (UBSE)",
                  "West Bengal Council of Higher Secondary Education (WBCHSE)",
                ],
                value: "CBSE",
                onChanged: (val) {},
              ),

              width20,
              CommonDropdown(
                label: "Stream",
                items: [
                  // Science
                  "Science – PCM (Physics, Chemistry, Maths)",
                  "Science – PCB (Physics, Chemistry, Biology)",
                  "Science – PCMB (Physics, Chemistry, Maths, Biology)",
                  "Science with Computer Science",
                  "Science with Informatics Practices",
                  "Science with Biotechnology",
                  "Science with Electronics",
                  "Science with Home Science",

                  // Commerce
                  "Commerce with Mathematics",
                  "Commerce without Mathematics",
                  "Commerce with Computer Applications",
                  "Commerce with Entrepreneurship",
                  "Commerce with Informatics Practices",

                  // Humanities / Arts
                  "Humanities – History, Political Science, Geography",
                  "Humanities – Political Science, Sociology, Psychology",
                  "Humanities – Economics, Political Science, History",
                  "Humanities with Fine Arts",
                  "Humanities with Performing Arts (Music/Dance/Theatre)",
                  "Humanities with Literature",
                  "Humanities with Philosophy / Logic",
                  "Humanities with Physical Education",

                  // Vocational
                  "Vocational – Computer Applications",
                  "Vocational – Information Technology",
                  "Vocational – Electronics",
                  "Vocational – Electrical Technology",
                  "Vocational – Automobile Technology",
                  "Vocational – Civil/Mechanical Drafting",
                  "Vocational – Tourism & Travel",
                  "Vocational – Agriculture",
                  "Vocational – Dairy Technology",
                  "Vocational – Health & Paramedical",
                  "Vocational – Fashion & Textile Design",
                  "Vocational – Home Science",

                  // International Boards
                  "IB – Language & Literature",
                  "IB – Language Acquisition",
                  "IB – Individuals & Societies",
                  "IB – Sciences",
                  "IB – Mathematics",
                  "IB – The Arts",

                  "Cambridge A Levels – Sciences",
                  "Cambridge A Levels – Commerce",
                  "Cambridge A Levels – Arts & Humanities",
                  "Cambridge A Levels – Creative & Applied",
                ],
                value: "Science – PCM (Physics, Chemistry, Maths)",
                onChanged: (val) {},
              ),
            ],
          ),
          Row(
            children: [
              CommonTextField(
                text: "Passout Year",
                controller: passoutController,
              ),
              width20,
              CommonTextField(
                text: "Percentage",
                controller: percentageController,
              ),
            ],
          ),
          height10,
          Row(
            children: [
              SizedBox(width: 22),
              Text(
                "Subjects and Marks",
                style: myTextstyle(color: Colors.black, fontSize: 18),
              ),
              Spacer(),
              TextButton.icon(
                onPressed: () {},
                label: Text("Add Subject"),
                icon: Icon(Icons.add),
              ),
              width10,
            ],
          ),
          SubHeading(text: "Degree Details"),
          Row(
            children: [
              CommonDropdown(
                label: "Discipline",
                items: disciplines.map((e) => e.name).toList(),
                value: selectedDecipline,
                onChanged: (value) {
                  selectedDecipline = value ?? '';
                  selectedSpecialization =
                      disciplines
                          .where((e) => e.name == selectedDecipline)
                          .first
                          .specializations
                          .map((e) => e)
                          .toList()
                          .first;
                  setState(() {});
                },
              ),
              CommonDropdown(
                label: 'Specialization',
                items:
                    disciplines
                        .where((e) => e.name == selectedDecipline)
                        .first
                        .specializations
                        .map((e) => e)
                        .toList(),
                value: selectedSpecialization,
                onChanged: (value) {
                  selectedSpecialization = value ?? '';
                  setState(() {});
                },
              ),
            ],
          ),
          Row(
            children: [
              CommonTextField(
                text: "Percentatage",
                controller: percentageController,
              ),
              CommonTextField(
                text: "No: of Backlogs",
                controller: backlogsController,
              ),
            ],
          ),
          Row(
            children: [
              CommonDropdown(
                label: "Type",
                items: ["Regular", "Distance"],
                onChanged: (value) {},
              ),
              CommonDropdown(
                label: "Duration",
                items: ['1', '2', '3', '4', '5', '6'],
                onChanged: (value) {},
              ),
            ],
          ),
          height10,
          Row(
            children: [
              CommonDatePicker(label: "Join Date"),
              CommonDatePicker(label: "passout Date"),
            ],
          ),
          Row(
            children: [
              Spacer(),
              TextButton.icon(
                onPressed: () {},
                label: Text("Add Degree"),
                icon: Icon(Icons.add),
              ),
              width10,
            ],
          ),
          height20,
          PreviousAndNextButtons(
            onSavePressed: () {},
            onPrevPressed: () {},
            onNextPressed: () {},
          ),
        ],
      ),
    );
  }
}
