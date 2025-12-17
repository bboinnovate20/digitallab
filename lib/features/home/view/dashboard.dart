import 'package:digitallab/features/home/view/image_optimizer.dart';
import 'package:digitallab/features/remove_background/view/remove_bg.dart';
import 'package:flutter/material.dart';
import 'package:digitallab/features/home/view/photo_edit_lab.dart';
import 'package:digitallab/features/home/view/passport_lab.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                // _FeatureCard(
                //   icon: Icons.photo_camera_back_outlined,
                //   title: 'Photo Editing Lab',
                //   subtitle: 'Edit photos, remove background',
                //   onTap: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(builder: (_) => const PhotoEditLab()),
                //     );
                //   },
                // ),
                // _FeatureCard(
                //   icon: Icons.credit_card,
                //   title: 'Passport Photo Lab',
                //   subtitle: 'Crop & size for passport prints',
                //   onTap: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(builder: (_) => const PassportLab()),
                //     );
                //   },
                // ),
                _FeatureCard(
                  icon: Icons.credit_card,
                  title: 'Image Optimizer',
                  subtitle: 'Reduce your Image',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const LoaderOverlay(child: ImageOptimizer()),
                      ),
                    );
                  },
                ),
                _FeatureCard(
                  icon: Icons.credit_card,
                  title: 'Remove Background',
                  subtitle: 'Reduce your Image',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const LoaderOverlay(child: RemoveBackground()),
                      ),
                    );
                  },
                ),
                // Add more feature cards here as the app grows
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
