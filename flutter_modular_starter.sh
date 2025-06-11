#!/bin/bash

echo "Yeni Flutter proje adını giriniz:"
read project_name

# Flutter projesini oluştur
flutter create "$project_name"

# Proje klasörüne gir
cd "$project_name" || exit

# pubspec.yaml'ı güncelle
cat <<EOF > pubspec.yaml
name: $project_name
description: project $project_name

publish_to: 'none'

environment:
  sdk: "^3.7.2"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^9.1.0
  go_router: ^14.8.1
  flutter_screenutil: ^5.9.3
  equatable: ^2.0.7
  intl: ^0.20.2
  intl_utils: ^2.8.10
  flutter_svg: ^2.0.17
  http: ^1.3.0
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  build_runner: ^2.4.15
  flutter_gen_runner: ^5.10.0
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/

l10n:
  template-arb-file: intl_en.arb
  arb-dir: lib/l10n
  output-localization-file: app_localizations.dart
  synthetic-package: true
  preferred-supported-locales: ["en", "tr"]
EOF

# Gerekli klasörleri oluştur
mkdir -p assets/images
mkdir -p lib/data/classes
mkdir -p lib/data/constants
mkdir -p lib/data/models
mkdir -p lib/l10n
mkdir -p lib/core/router/app

# Feature-based presentation yapısı
for feature in home auth settings profile onboarding shared; do
  mkdir -p "lib/presentation/$feature/cubits"
  mkdir -p "lib/presentation/$feature/screens"
  mkdir -p "lib/presentation/$feature/widgets"
done

# Lokalizasyon dosyaları
cat <<EOF > lib/l10n/intl_en.arb
{
  "@@locale": "en",
  "appTitle": "$project_name",
  "homeScreenTitle": "Home",
  "welcomeMessage": "Welcome to the app!",
  "buttonLabel": "Click me",
  "settings": "Settings",
  "about": "About",
  "language": "Language",
  "logout": "Log out",
  "errorOccurred": "An error occurred. Please try again.",
  "loading": "Loading...",
  "noData": "No data available.",
  "retry": "Retry",
  "yes": "Yes",
  "no": "No"
}
EOF

cat <<EOF > lib/l10n/intl_tr.arb
{
  "@@locale": "tr",
  "appTitle": "$project_name",
  "homeScreenTitle": "Ana Sayfa",
  "welcomeMessage": "Uygulamaya hoş geldiniz!",
  "buttonLabel": "Beni tıkla",
  "settings": "Ayarlar",
  "about": "Hakkında",
  "language": "Dil",
  "logout": "Çıkış yap",
  "errorOccurred": "Bir hata oluştu. Lütfen tekrar deneyin.",
  "loading": "Yükleniyor...",
  "noData": "Veri mevcut değil.",
  "retry": "Tekrar dene",
  "yes": "Evet",
  "no": "Hayır"
}
EOF

# Router dosyası
cat <<EOF > lib/core/router/router.dart
import 'package:$project_name/data/constants/page_const.dart';
import 'package:go_router/go_router.dart';
import 'package:$project_name/presentation/home/screens/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: PageConst.home,
  routes: [
    GoRoute(
      path: PageConst.home,
      builder: (context, state) => HomeScreen(),
    ),
  ],
);
EOF

# Örnek home screen
cat <<EOF > lib/presentation/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$project_name/generated/l10n.dart';
import 'package:$project_name/presentation/shared/cubits/locale_cubit.dart';
import 'package:$project_name/presentation/shared/cubits/theme_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = S.of(context);
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.homeScreenTitle),
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: tema.colorScheme.surface,
        centerTitle: true,
        actions: [
          // Tema değiştirme ikonu
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          // Dil değiştirme ikonu
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final currentLocale = Localizations.localeOf(context);
              final newLocale =
                  currentLocale.languageCode == 'en' ? const Locale('tr') : const Locale('en');
              context.read<LocaleCubit>().changeLocale(newLocale);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(local.welcomeMessage),
      ),
    );
  }
}
EOF

# Locale cubit shared altında
cat <<EOF > lib/presentation/shared/cubits/locale_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('tr', 'TR'));

  void changeLocale(Locale locale) {
    emit(locale);
  }
}
EOF

# Theme cubit shared altında
cat <<EOF > lib/presentation/shared/cubits/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void changeTheme(ThemeMode themeMode) {
    emit(themeMode);
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else {emit(ThemeMode.light);}
  }
}

EOF

# Renk sabitleri
cat <<EOF > lib/data/constants/color_const.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF001f54);
  static const Color secondary = Color(0xFF1E4D92);
  static const Color accent = Color(0xFFFF6F00);
  static const Color background = Color(0xFFF5F5F5);
  static const Color black = Color(0xFF121212);
  static const Color white = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}
EOF

# Page sabitleri
cat <<EOF > lib/data/constants/page_const.dart
class PageConst {
  static const String home = "/home";
  static const String settings = "/settings";
  static const String onboarding = "/onboarding";
  static const String profile = "/profile";
}
EOF

# Tema dosyası
cat <<EOF > lib/data/classes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:$project_name/data/constants/color_const.dart';

class AppTheme {
  static TextTheme _buildTextTheme({
    required Color primaryText,
    required Color secondaryText,
    required Color titleText,
  }) {
    return TextTheme(
      bodyLarge: TextStyle(
        color: primaryText,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: secondaryText,
        fontSize: 14,
      ),
      titleLarge: TextStyle(
        color: titleText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return AppBarTheme(
      centerTitle: true,
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: iconColor),
      elevation: 0,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  static IconButtonThemeData _buildIconButtonTheme({
    required Color iconColor,
  }) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: iconColor,
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.textPrimary,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.white,
      
      // AppBar
      appBarTheme: _buildAppBarTheme(
        backgroundColor: AppColors.background,
        iconColor: AppColors.black,
      ),
      
      // Text Theme
      textTheme: _buildTextTheme(
        primaryText: AppColors.textPrimary,
        secondaryText: AppColors.textSecondary,
        titleText: AppColors.secondary,
      ),
      
      // Button Themes
      elevatedButtonTheme: _buildElevatedButtonTheme(
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.secondary,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.black,
        size: 24,
      ),

      iconButtonTheme: _buildIconButtonTheme(
        iconColor: AppColors.black,
      ),
      
      // Input Decoration
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: AppColors.background,
        borderColor: AppColors.textSecondary,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        surface: AppColors.black,
        onSurface: AppColors.white,
        background: AppColors.black,
        onBackground: AppColors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.black,
      
      // AppBar
      appBarTheme: _buildAppBarTheme(
        backgroundColor: AppColors.black,
        iconColor: AppColors.white,
      ),

      iconButtonTheme: _buildIconButtonTheme(
        iconColor: AppColors.white,
      ),
      
      // Text Theme
      textTheme: _buildTextTheme(
        primaryText: AppColors.white,
        secondaryText: AppColors.white.withOpacity(0.7),
        titleText: AppColors.secondary,
      ),
      
      // Button Themes
      elevatedButtonTheme: _buildElevatedButtonTheme(
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.secondary,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.white,
        size: 24,
      ),
      
      // Input Decoration
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: AppColors.black.withOpacity(0.3),
        borderColor: AppColors.white.withOpacity(0.3),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.black.withOpacity(0.8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
EOF

# main.dart
cat <<EOF > lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$project_name/core/router/router.dart';
import 'package:$project_name/data/classes/app_theme.dart';
import 'package:$project_name/presentation/shared/cubits/locale_cubit.dart';
import 'package:$project_name/presentation/shared/cubits/theme_cubit.dart';
import 'package:$project_name/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: router,
                    title: '$project_name',
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                    locale: locale,
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('en', 'US'),
                      Locale('tr', 'TR'),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
EOF

# Git başlat
git init
cat <<EOF > .gitignore
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
pubspec.lock
build/
ios/Flutter/Flutter.framework
ios/Flutter/Flutter.podspec
EOF
git add .
git commit -m "Initial commit for $project_name with modular architecture"

# Pub işlemleri
echo "🔄 Bağımlılıklar yükleniyor..."
flutter pub get

echo "🔄 Lokalizasyon dosyaları oluşturuluyor..."
flutter pub run intl_utils:generate

echo "✅ $project_name adlı Flutter projesi, modüler yapısıyla başarıyla oluşturuldu!"
