import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';

class LeadInfoPopup extends StatelessWidget {
  const LeadInfoPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CommonAppbar(title: "Lead Info"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
