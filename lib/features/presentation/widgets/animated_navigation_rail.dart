import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/providers/theme_providers.dart';

class AnimatedNavRail extends ConsumerStatefulWidget {
  const AnimatedNavRail({super.key});

  @override
  ConsumerState<AnimatedNavRail> createState() => _AnimatedNavRailState();
}

class _AnimatedNavRailState extends ConsumerState<AnimatedNavRail> {
  final routerConsts = RouterConsts();

  bool _hover = false;
  bool _pinned = false;
  bool get _expanded => _hover || _pinned;

  int _selectedIndex(String loc) =>
      loc.startsWith(routerConsts.attendance.route)
          ? 1
          : loc.startsWith(routerConsts.freelancerMangement.route)
          ? 2
          : loc.startsWith(routerConsts.courses.route)
          ? 3
          : 0;

  void _onSelect(int i) {
    switch (i) {
      case 0:
        context.go(routerConsts.dashboard.route);
        break;
      case 1:
        context.go(routerConsts.attendance.route);
        break;

      case 2:
        context.go(routerConsts.freelancerMangement.route);
        break;
      case 3:
        context.go(routerConsts.courses.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final uri = GoRouterState.of(context).uri.toString();

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),

      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: _expanded ? 72 : 150,
          end: _expanded ? 150 : 72,
        ),
        duration: const Duration(milliseconds: 120),
        builder: (_, width, child) => child!,

        child: Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ClipRect(
                  child: NavigationRail(
                    selectedIconTheme: IconThemeData(color: Colors.white),
                    indicatorColor: ColorConsts.primaryColor,
                    extended: _expanded,
                    selectedIndex: _selectedIndex(uri),
                    onDestinationSelected: _onSelect,
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(Icons.home_outlined),
                        label: _animatedLabel(routerConsts.dashboard.name),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.schedule_outlined),
                        label: _animatedLabel(routerConsts.attendance.name),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.people_outline),
                        label: _animatedLabel(
                          routerConsts.freelancerMangement.name,
                        ),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.search),
                        label: _animatedLabel(routerConsts.courses.name),
                      ),
                    ],
                    trailing: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  themeMode == ThemeMode.dark
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                ),
                                tooltip: 'Toggle theme',
                                onPressed: () {
                                  ref.read(themeModeProvider.notifier).state =
                                      themeMode == ThemeMode.dark
                                          ? ThemeMode.light
                                          : ThemeMode.dark;
                                },
                              ),
                              const SizedBox(height: 5),
                              IconButton(
                                onPressed: () {},
                                icon: Row(
                                  children: [
                                    const Icon(Icons.logout),
                                    const SizedBox(width: 5),
                                    _animatedLabel('Logout'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 1,
              top: 10,
              child: IconButton(
                icon: Icon(
                  _pinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 20,
                ),
                onPressed: () => setState(() => _pinned = !_pinned),
                tooltip: _pinned ? 'Unpin' : 'Pin',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedLabel(String text) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder:
          (child, anim) => FadeTransition(opacity: anim, child: child),
      child:
          _expanded
              ? Text(text, key: const ValueKey('label'))
              : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}
