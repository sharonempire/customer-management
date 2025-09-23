import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/lead_filter_widget.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/current_follow_ups_view.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/drafts_view.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/new_enquiries_view.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/search_lead_widget.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart'
    show CommonAppbar;
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeadManagement extends ConsumerStatefulWidget {
  const LeadManagement({super.key});

  @override
  ConsumerState<LeadManagement> createState() => _LeadManagementState();
}

class _LeadManagementState extends ConsumerState<LeadManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: LeadTab.values.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final tab = LeadTab.values[_tabController.index];
      ref.read(leadTabProvider.notifier).state = tab;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(leadMangementcontroller.notifier)
          .fetchAllLeads(context: context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedTab = ref.watch(leadTabProvider);
    final targetIndex = LeadTab.values.indexOf(selectedTab);

    if (_tabController.index != targetIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _tabController.index != targetIndex) {
          _tabController.animateTo(targetIndex);
        }
      });
    }

    late final Widget tabContent;
    switch (selectedTab) {
      case LeadTab.currentFollowUps:
        tabContent = const CurrentFollowUpsView(
          key: ValueKey('current-follow-ups'),
        );
        break;
      case LeadTab.drafts:
        tabContent = const DraftsView(key: ValueKey('drafts'));
        break;
      case LeadTab.newEnquiries:
        tabContent = const NewEnquiriesView(key: ValueKey('new-enquiries'));
        break;
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppbar(title: "Lead Management"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ Whole page scrolls
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Row(
                  children: [
                    Text(
                      "Track and manage student enquiries and follow-ups",
                      style: myTextstyle(),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      onpressed: () {
                        ref
                            .read(leadMangementcontroller.notifier)
                            .setFromNewLead(true);
                        context.go(
                          '${RouterConsts().enquiries.route}/${RouterConsts().leadInfo.route}',
                        );
                      },
                      icon: Icons.add,
                      text: "New Lead",
                    ),
                  ],
                ),
                height30,
                const SearchLeadsWidget(),
                height20,
                const LeadFiltersWidget(),
                height10,

                height20,
                Center(
                  child: Container(
                    height: 50,
                    width: screenWidth * 0.6,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorConsts.backgroundColorScaffold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      onTap:
                          (index) =>
                              ref.read(leadTabProvider.notifier).state =
                                  LeadTab.values[index],
                      tabs: const [
                        Tab(text: "Current Follow ups"),
                        Tab(text: "Drafts"),
                        Tab(text: "New Enquiries"),
                      ],
                      indicator: BoxDecoration(
                        color: ColorConsts.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                height20,
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: tabContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
