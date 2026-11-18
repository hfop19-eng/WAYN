
import 'package:flutter/material.dart';
import '../theme.dart';
import 'map_screen.dart';
import 'community_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  late final List<Widget> pages = [
    const DiscoverPage(),
    const MapScreen(),
    const CommunityScreen(),
    const Center(child: Text('حسابي')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
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
    );
  }
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أهلاً بك في',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'WAYN',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: WaynTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                size: 28,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF42A5F5),
                Color(0xFF9575CD),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'وين تروح اليوم؟',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'اكتشف الأماكن والأحداث القريبة منك',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 15),
              Icon(
                Icons.travel_explore,
                color: Colors.white,
                size: 45,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'استكشف التصنيفات',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            CategoryChip(icon: Icons.restaurant, title: 'مطاعم'),
            CategoryChip(icon: Icons.local_cafe, title: 'مقاهي'),
            CategoryChip(icon: Icons.park, title: 'حدائق'),
            CategoryChip(icon: Icons.event, title: 'فعاليات'),
            CategoryChip(icon: Icons.school, title: 'دراسة'),
            CategoryChip(icon: Icons.shopping_bag, title: 'تسوق'),
          ],
        ),
        const SizedBox(height: 28),
        const Text(
          'آخر المستجدات',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const UpdateCard(
          icon: Icons.traffic,
          title: 'حالة الطرق',
          description: 'تابع تحديثات الطرق والازدحام في منطقتك',
        ),
        const UpdateCard(
          icon: Icons.campaign_outlined,
          title: 'بلاغات المجتمع',
          description: 'شاهد آخر البلاغات والمعلومات المحلية',
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: WaynTheme.primary),
      label: Text(title),
      backgroundColor: Colors.white,
      side: BorderSide.none,
      padding: const EdgeInsets.all(8),
    );
  }
}

class UpdateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const UpdateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: WaynTheme.primary.withOpacity(0.12),
          child: Icon(icon, color: WaynTheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
        ),
      ),
    );
  }
}
