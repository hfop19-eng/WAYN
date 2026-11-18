
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'services.dart';
import 'theme.dart';
import 'language_service.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/home_screen.dart';

final LanguageService languageService = LanguageService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  await languageService.loadLanguage();

  runApp(const WAYNApp());
}

class WAYNApp extends StatelessWidget {
  const WAYNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: languageService,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WAYN',
          theme: WaynTheme.light,
          locale: languageService.locale,
          supportedLocales: const [
            Locale('ar'),
            Locale('ku'),
            Locale('en'),
          ],
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/consent': (context) => const ConsentScreen(),
            '/home': (context) => const HomeScreen(),
          },
          home: const IntroScreen(),
        );
      },
    );
  }
}

// ================= INTRO ANIMATION =================

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  bool isNavigating = false;

  final List<IconData> icons = [
    Icons.location_on_rounded,
    Icons.local_cafe_rounded,
    Icons.storefront_rounded,
    Icons.camera_alt_rounded,
    Icons.directions_car_rounded,
    Icons.park_rounded,
    Icons.local_activity_rounded,
    Icons.map_rounded,
  ];

  final List<Color> iconColors = [
    const Color(0xFF168BF0),
    const Color(0xFF7564D9),
    const Color(0xFF3198F5),
    const Color(0xFF254D91),
    const Color(0xFF168BF0),
    const Color(0xFF45A9A0),
    const Color(0xFF8065E9),
    const Color(0xFF3198F5),
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        openNextScreen();
      }
    });

    controller.forward();
  }

  Future<void> openNextScreen() async {
    if (isNavigating || !mounted) return;

    isNavigating = true;

    Widget nextScreen;

    if (AppServices.currentUser == null) {
      nextScreen = const LoginScreen();
    } else {
      try {
        final accepted =
            await AppServices.hasAcceptedCurrentTerms();

        nextScreen = accepted
            ? const HomeScreen()
            : const ConsentScreen();
      } catch (e) {
        nextScreen = const ConsentScreen();
      }
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => nextScreen,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildFloatingIcon(
    int index,
    double centerX,
    double centerY,
    double radius,
    double progress,
  ) {
    final angle =
        (index * math.pi / 4) + (progress * math.pi * 4);

    final gather = Curves.easeInOutCubic.transform(
      ((progress - 0.53) / 0.35)
          .clamp(0.0, 1.0)
          .toDouble(),
    );

    final currentRadius = radius * (1 - gather);

    final fade = 1 -
        Curves.easeIn.transform(
          ((progress - 0.78) / 0.18)
              .clamp(0.0, 1.0)
              .toDouble(),
        );

    final x = centerX + math.cos(angle) * currentRadius;
    final y = centerY + math.sin(angle) * currentRadius;

    return Positioned(
      left: x - 24,
      top: y - 24,
      child: Opacity(
        opacity: fade.clamp(0.0, 1.0).toDouble(),
        child: Transform.rotate(
          angle: angle * -0.3,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFDCEEFF),
              ),
              boxShadow: [
                BoxShadow(
                  color: iconColors[index].withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              icons[index],
              color: iconColors[index],
              size: 27,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final progress = controller.value;

          final logoProgress =
              Curves.easeOutBack.transform(
            ((progress - 0.70) / 0.25)
                .clamp(0.0, 1.0)
                .toDouble(),
          );

          return LayoutBuilder(
            builder: (context, constraints) {
              final centerX = constraints.maxWidth / 2;
              final centerY = constraints.maxHeight / 2;

              final radius = math.min(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  ) *
                  0.31;

              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.05),
                    radius: 0.95,
                    colors: [
                      Colors.white,
                      Color(0xFFF5FAFF),
                      Color(0xFFE8F4FF),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF56B8FF)
                                .withOpacity(0.10),
                            blurRadius: 90,
                            spreadRadius: 30,
                          ),
                        ],
                      ),
                    ),

                    Transform.scale(
                      scale: 0.92 + (progress * 0.08),
                      child: Container(
                        width: radius * 2.25,
                        height: radius * 2.25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF91D1FF)
                                .withOpacity(0.35),
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),

                    ...List.generate(
                      icons.length,
                      (index) => buildFloatingIcon(
                        index,
                        centerX,
                        centerY,
                        radius,
                        progress,
                      ),
                    ),

                    Opacity(
                      opacity: logoProgress,
                      child: Transform.scale(
                        scale: 0.75 + (logoProgress * 0.25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF64C7FF),
                                    Color(0xFF0875E8),
                                    Color(0xFF1453BD),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(34),
                                  topRight: Radius.circular(34),
                                  bottomLeft: Radius.circular(34),
                                  bottomRight: Radius.circular(7),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1687E9)
                                        .withOpacity(0.25),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: Colors.white,
                                size: 43,
                              ),
                            ),
                            const SizedBox(height: 17),
                            const Text(
                              'WAYN',
                              style: TextStyle(
                                fontSize: 55,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                height: 1,
                                color: Color(0xFF12346F),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'وين أروح؟',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2868B4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
