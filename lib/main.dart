import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/routes/app_router.dart';
import 'package:management_software/shared/providers/theme_providers.dart';
import 'package:management_software/shared/supabase/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:just_audio_web/just_audio_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Supabase
  await Supabase.initialize(url: SUPABASEURL, anonKey: SUPABASEKEY);
  if (kIsWeb) {
    JustAudioPlatform.instance = JustAudioPlugin();
  }
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(SharedPrefsHelper(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Empire Management Software',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: router,
    );
  }
}
