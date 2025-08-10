import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/presentation/widgets/h1_widget.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/providers/theme_providers.dart';

/// {@template common_appbar}
/// CommonAppbar widget.
/// {@endtemplate}
class CommonAppbar extends ConsumerWidget {
  final String title;
  const CommonAppbar({super.key, required this.title, });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final themeMode = ref.watch(themeModeProvider);
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: H1Widget(title: title),
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(
            themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            size: 14,
          ),
          tooltip: 'Toggle theme',
          onPressed: () {
            ref.read(themeModeProvider.notifier).state =
                themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
          },
        ),
        width20,
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
        width10,
        CircleAvatar(radius: 18),
        width5,
        Text("John Doe"),
        width30,
      ],
    );
  }
}
