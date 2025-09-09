import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/authentification/controller/auth_controller.dart';
import 'package:management_software/features/presentation/widgets/h1_widget.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/providers/theme_providers.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class CommonAppbar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String title;
  const CommonAppbar({super.key, required this.title});

  @override
  ConsumerState<CommonAppbar> createState() => _CommonAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonAppbarState extends ConsumerState<CommonAppbar>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _controller.reverse();
      Future.delayed(const Duration(milliseconds: 300), () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
      _isOpen = false;
    } else {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      _controller.forward();
      _isOpen = true;
    }
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder:
          (context) => Positioned(
            top: kToolbarHeight,
            right: 30,
            child: Material(
              color: Colors.transparent,
              child: SizeTransition(
                sizeFactor: _animation,
                axisAlignment: -1.0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .14,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: CircleAvatar(radius: 16, child: Text("Jh")),
                          title: Text("John deo"),
                          onTap: () {
                            _toggleOverlay();
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text("Logout"),
                          onTap: () {
                            ref
                                .read(authControllerProvider.notifier)
                                .logout(context);
                            _toggleOverlay();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: H1Widget(title: widget.title),
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
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
        ),
        width10,
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleOverlay,
            child: Row(
              children: [
                CircleAvatar(radius: 18, child: Text("Jh")),
                const SizedBox(width: 8),
                Text("John deo", style: myTextstyle(color: Colors.black)),
                width30,
              ],
            ),
          ),
        ),
        width30,
      ],
    );
  }
}
