import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass_liquid_navbar/glass_liquid_navbar.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/plants/presentation/plants_screen.dart';
import 'features/locations/presentation/locations_screen.dart';
import 'features/settings/application/ai_chat_settings_notifier.dart';
import 'features/settings/application/language_notifier.dart';
import 'features/settings/application/theme_notifier.dart';
import 'core/theme/app_colors.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter/material.dart' show Scaffold;

class PlantCareApp extends ConsumerWidget {
  const PlantCareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);
    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final brightness = themeMode == AppThemeMode.system
        ? platformBrightness
        : themeMode == AppThemeMode.dark
            ? Brightness.dark
            : Brightness.light;

    return CupertinoApp(
      title: 'PlantCare',
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: brightness == Brightness.dark
            ? kAppBackground.darkColor
            : kAppBackground.color,
        barBackgroundColor: brightness == Brightness.dark
            ? const Color(0xFF1C1C1E)
            : CupertinoColors.systemBackground,
      ),
      home: const MainTabView(),
    );
  }
}

class MainTabView extends ConsumerStatefulWidget {
  const MainTabView({super.key});

  @override
  ConsumerState<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends ConsumerState<MainTabView> {
  int _currentIndex = 0;

  static const _baseScreens = <Widget>[
    HomeScreen(),
    PlantsScreen(),
    LocationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final themeMode = ref.watch(themeProvider);
    final aiChatEnabled =
        ref.watch(aiChatSettingsProvider).valueOrNull ?? true;
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final isDark = themeMode == AppThemeMode.dark ||
        (themeMode == AppThemeMode.system &&
            platformBrightness == Brightness.dark);

    final screens = [
      ..._baseScreens,
      if (aiChatEnabled) const ChatScreen(),
    ];

    // Clamp index so we never point past the last tab
    final safeIndex = _currentIndex.clamp(0, screens.length - 1);
    if (safeIndex != _currentIndex) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => _currentIndex = safeIndex));
    }

    final items = [
      LiquidNavItem(icon: CupertinoIcons.house_fill, label: l.tabHome),
      LiquidNavItem(
          icon: CupertinoIcons.leaf_arrow_circlepath, label: l.tabPlants),
      LiquidNavItem(icon: CupertinoIcons.map_fill, label: l.tabLocations),
      if (aiChatEnabled)
        LiquidNavItem(
            icon: CupertinoIcons.chat_bubble_2_fill, label: l.tabChat),
    ];

    return Scaffold(
      extendBody: true,
      body: screens[safeIndex],
      bottomNavigationBar: LiquidGlassNavbar(
        currentIndex: safeIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        theme: isDark
            ? LiquidGlassTheme.dark().copyWith(
                selectedColor: const Color(0xFF4CAF50),
                indicatorColor: const Color(0x334CAF50),
              )
            : LiquidGlassTheme.light().copyWith(
                selectedColor: const Color(0xFF4CAF50),
                indicatorColor: const Color(0x334CAF50),
              ),
        items: items,
      ),
    );
  }
}
