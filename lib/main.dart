
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
      home: const HomePage(),
    );
  }
}

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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_back_ios_new, size: 16),
      ),
    );
  }
}
