
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const WAYNApp());
}

class WAYNApp extends StatelessWidget {
  const WAYNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WAYN',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3298F5),
        ),
        fontFamily: 'Roboto',
      ),
      home: const IntroScreen(),
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
    Color(0xFF168BF0),
    Color(0xFF7564D9),
    Color(0xFF3198F5),
    Color(0xFF254D91),
    Color(0xFF168BF0),
    Color(0xFF45A9A0),
    Color(0xFF8065E9),
    Color(0xFF3198F5),
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      }
    });

    controller.forward();
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
    final angle = (index * math.pi / 4) +
        (progress * math.pi * 4);

    final gather = Curves.easeInOutCubic.transform(
      ((progress - 0.53) / 0.35).clamp(0.0, 1.0),
    );

    final currentRadius = radius * (1 - gather);

    final fade = 1 -
        Curves.easeIn.transform(
          ((progress - 0.78) / 0.18).clamp(0.0, 1.0),
        );

    final x = centerX +
        math.cos(angle) * currentRadius;

    final y = centerY +
        math.sin(angle) * currentRadius;

    return Positioned(
      left: x - 24,
      top: y - 24,
      child: Opacity(
        opacity: fade,
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

          final logoProgress = Curves.easeOutBack.transform(
            ((progress - 0.70) / 0.25).clamp(0.0, 1.0),
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
                    // Soft background glow
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

                    // Circular orbit
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

                    // Orbiting icons
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

                    // Final WAYN logo
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

// ================= HOME PAGE =================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<String> titles = [
    'اكتشف',
    'الخريطة',
    'المجتمع',
    'حسابي',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'WAYN',
            style: TextStyle(
              color: Color(0xFF268CE8),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: selectedIndex == 0
            ? buildDiscover()
            : Center(
                child: Text(
                  titles[selectedIndex],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'اكتشف',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'الخريطة',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'المجتمع',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDiscover() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'وين تروح اليوم؟',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'اكتشف الأماكن والفعاليات والتحديثات القريبة منك',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3498F5),
                Color(0xFF7969E8),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 34),
              SizedBox(height: 12),
              Text(
                'اكتشف ما حولك',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'أماكن جديدة، عروض، فعاليات وتحديثات محلية',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'استكشف حسب التصنيف',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            CategoryChip(icon: Icons.restaurant, label: 'مطاعم'),
            CategoryChip(icon: Icons.coffee, label: 'مقاهي'),
            CategoryChip(icon: Icons.park, label: 'متنزهات'),
            CategoryChip(icon: Icons.event, label: 'فعاليات'),
            CategoryChip(icon: Icons.menu_book, label: 'أماكن دراسة'),
            CategoryChip(icon: Icons.local_offer, label: 'عروض'),
          ],
        ),
        const SizedBox(height: 25),
        const Text(
          'آخر التحديثات',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const UpdateCard(
          icon: Icons.traffic,
          title: 'تحديثات الطرق',
          subtitle: 'تابع حالة الطرق والتنبيهات المحلية',
        ),
        const UpdateCard(
          icon: Icons.bolt,
          title: 'الخدمات المحلية',
          subtitle: 'شاهد البلاغات والتحديثات في منطقتك',
        ),
      ],
    );
  }
}

// ================= CATEGORY CHIP =================

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: const Color(0xFF328FE8), size: 19),
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
    );
  }
}

// ================= UPDATE CARD =================

class UpdateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const UpdateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F3FF),
          child: Icon(icon, color: const Color(0xFF328FE8)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_back_ios_new,
          size: 16,
        ),
      ),
    );
  }
}
