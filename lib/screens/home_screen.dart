
import 'package:flutter/material.dart';

import '../theme.dart';
import 'map_screen.dart';
import 'community_screen.dart';
import 'reports_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DiscoverPage(),
    MapScreen(),
    ReportsScreen(),
    CommunityScreen(),
    AccountPage(),
  ];

  final List<NavigationDestination> destinations = const [
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore),
      label: 'استكشف',
    ),
    NavigationDestination(
      icon: Icon(Icons.map_outlined),
      selectedIcon: Icon(Icons.map),
      label: 'الخريطة',
    ),
    NavigationDestination(
      icon: Icon(Icons.campaign_outlined),
      selectedIcon: Icon(Icons.campaign),
      label: 'البلاغات',
    ),
    NavigationDestination(
      icon: Icon(Icons.groups_outlined),
      selectedIcon: Icon(Icons.groups),
      label: 'المجتمع',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'حسابي',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: destinations,
        backgroundColor: Colors.white,
        indicatorColor: WaynTheme.primary.withValues(alpha: 0.15),
        elevation: 3,
      ),
    );
  }
}

// ================= DISCOVER PAGE =================

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaynTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'WAYN',
          style: TextStyle(
            color: Color(0xFF328FE8),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'اكتشف الأماكن والفعاليات والتحديثات القريبة منك',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
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
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 34,
                ),
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
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              CategoryChip(
                icon: Icons.restaurant,
                label: 'مطاعم',
              ),
              CategoryChip(
                icon: Icons.coffee,
                label: 'مقاهي',
              ),
              CategoryChip(
                icon: Icons.park,
                label: 'متنزهات',
              ),
              CategoryChip(
                icon: Icons.event,
                label: 'فعاليات',
              ),
              CategoryChip(
                icon: Icons.menu_book,
                label: 'أماكن دراسة',
              ),
              CategoryChip(
                icon: Icons.local_offer,
                label: 'عروض',
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            'آخر التحديثات',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
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
      ),
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
      avatar: Icon(
        icon,
        color: const Color(0xFF328FE8),
        size: 19,
      ),
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 9,
      ),
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
          child: Icon(
            icon,
            color: const Color(0xFF328FE8),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
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

// ================= ACCOUNT PAGE =================

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaynTheme.background,
      appBar: AppBar(
        title: const Text('حسابي'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 42,
              child: Icon(
                Icons.person,
                size: 45,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'حساب WAYN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'صفحة الحساب قيد التطوير',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
