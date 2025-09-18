import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class BudgetInfoSection extends ConsumerStatefulWidget {
  const BudgetInfoSection({super.key});

  @override
  ConsumerState<BudgetInfoSection> createState() => _BudgetInfoSectionState();
}

class _BudgetInfoSectionState extends ConsumerState<BudgetInfoSection> {
  final TextEditingController budgetController = TextEditingController();
  String _selectedOption = "self";

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  BudgetInfo _toBudgetModel() {
    return BudgetInfo(
      selfFunding: _selectedOption == "self",
      homeLoan: _selectedOption == "loan",
      both: _selectedOption == "both",
      budgetAmount: double.tryParse(budgetController.text.trim()),
    );
  }

  Future<void> _saveOrNext(BuildContext context) async {
    try {
      // Read values synchronously so we don't use ref after async awaits
      final leadId =
          ref
              .read(leadMangementcontroller)
              .selectedLeadLocally
              ?.id
              ?.toString() ??
          "";

      final payload = LeadInfoModel(budgetInfo: _toBudgetModel()).toJson();

      final notifier = ref.read(leadMangementcontroller.notifier);

      final result = await notifier.updateLeadInfo(
        context: context,
        leadId: leadId,
        updatedData: payload,
      );

      if (!mounted) return;
      ref.read(snackbarServiceProvider).showSuccess(context, 'Budget saved');
      log('Budget saved: $result');
    } catch (e, st) {
      log('Budget save error: $e\n$st');
      if (!mounted) return;
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to save budget: $e');
    }
  }

  Widget _buildBudgetOption({
    required String value,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isSelected = _selectedOption == value;

    // Wrap tappable content with Material to avoid mouse-tracker hover issues
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!mounted) return;
          setState(() => _selectedOption = value);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? ColorConsts.primaryColor : Colors.grey.shade300,
              width: 1.3,
            ),
            color:
                isSelected ? ColorConsts.primaryColor.withOpacity(0.05) : null,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    isSelected
                        ? ColorConsts.primaryColor
                        : Colors.grey.shade300,
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
                    const SizedBox(height: 4),
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
                  if (!mounted) return;
                  setState(() => _selectedOption = val ?? _selectedOption);
                },
              ),
            ],
          ),
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
          _buildBudgetOption(
            value: "self",
            icon: Icons.savings,
            title: "Self Funding",
            description: "You will be funding your studies on your own.",
          ),
          _buildBudgetOption(
            value: "loan",
            icon: Icons.account_balance,
            title: "Loan",
            description: "You plan to take a student loan for your expenses.",
          ),
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
                onChanged: (_) {}, // keep stable reference
              ),
            ],
          ),
          height20,
          PreviousAndNextButtons(
            onSavePressed: () async => await _saveOrNext(context),
            onPrevPressed: () async {},
            onNextPressed: () async => await _saveOrNext(context),
          ),
        ],
      ),
    );
  }
}
