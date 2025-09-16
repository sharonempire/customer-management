import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class BudgetInfoSection extends StatefulWidget {
  const BudgetInfoSection({super.key});

  @override
  State<BudgetInfoSection> createState() => _BudgetInfoSectionState();
}

class _BudgetInfoSectionState extends State<BudgetInfoSection> {
  final budgetController = TextEditingController();
  String _selectedOption = "self";

  Widget _buildBudgetOption({
    required String value,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isSelected = _selectedOption == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ColorConsts.primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
          color: isSelected ? ColorConsts.primaryColor.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  isSelected ? ColorConsts.primaryColor : Colors.grey.shade300,
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: myTextstyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected
                              ? ColorConsts.primaryColor
                              : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: myTextstyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedOption,
              activeColor: ColorConsts.primaryColor,
              onChanged: (val) {
                setState(() {
                  _selectedOption = val!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Options
          _buildBudgetOption(
            value: "self",
            icon: Icons.savings,
            title: "Self Funding",
            description: "You will be funding your studies on your own.",
          ),
          height10,
          _buildBudgetOption(
            value: "loan",
            icon: Icons.account_balance,
            title: "Loan",
            description: "You plan to take a student loan for your expenses.",
          ),
          height10,
          _buildBudgetOption(
            value: "both",
            icon: Icons.balance,
            title: "Both",
            description: "A mix of self-funding and student loan.",
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CommonTextField(
                controller: budgetController,
                text: "Enter your budget amount",
                minLines: 1,
              ),
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
