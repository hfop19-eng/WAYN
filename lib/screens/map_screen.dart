import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool loading = false;
  String locationMessage = 'اضغط لمعرفة موقعك الحالي';

  Future<void> getLocation() async {
    setState(() {
      loading = true;
      locationMessage = 'جارٍ تحديد موقعك...';
    });

    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        throw Exception('يرجى تشغيل خدمة الموقع في الهاتف');
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('لم يتم منح إذن الموقع');
      }

      Position position = await Geolocator.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        locationMessage =
            'خط العرض: ${position.latitude.toStringAsFixed(5)}\n'
            'خط الطول: ${position.longitude.toStringAsFixed(5)}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        locationMessage = 'تعذر تحديد الموقع. تحقق من إعدادات الهاتف.';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخريطة'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 85,
                color: Color(0xFF42A5F5),
              ),
              const SizedBox(height: 20),
              const Text(
                'اكتشف موقعك',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                locationMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: loading ? null : getLocation,
                icon: const Icon(Icons.my_location),
                label: Text(
                  loading ? 'جارٍ التحديد...' : 'تحديد موقعي',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
