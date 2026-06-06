import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

/// Animated shimmer skeleton that matches the exact layout of JobCard.
class JobCardSkeleton extends StatefulWidget {
  const JobCardSkeleton({super.key});

  @override
  State<JobCardSkeleton> createState() => _JobCardSkeletonState();
}

class _JobCardSkeletonState extends State<JobCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final shimmerColor = Color.lerp(
          AppTheme.surface,
          AppTheme.borderLight,
          _anim.value,
        )!;
        final dimColor = Color.lerp(
          AppTheme.surface,
          const Color(0xFF2A2E45),
          _anim.value,
        )!;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company badge placeholder
              _Bone(width: 44, height: 44, radius: 10, color: shimmerColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title line 1
                    _Bone(
                        width: double.infinity,
                        height: 14,
                        radius: 6,
                        color: shimmerColor),
                    const SizedBox(height: 6),
                    // Title line 2 — shorter
                    _Bone(width: 160, height: 14, radius: 6, color: shimmerColor),
                    const SizedBox(height: 10),
                    // Company name
                    _Bone(width: 110, height: 12, radius: 5, color: dimColor),
                    const SizedBox(height: 10),
                    // Location
                    Row(
                      children: [
                        _Bone(width: 12, height: 12, radius: 4, color: dimColor),
                        const SizedBox(width: 4),
                        _Bone(width: 90, height: 10, radius: 4, color: dimColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Bookmark icon placeholder
              _Bone(width: 20, height: 20, radius: 4, color: dimColor),
            ],
          ),
        );
      },
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color color;

  const _Bone({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Renders N skeleton cards in a scrollable list.
class SkeletonList extends StatelessWidget {
  final int count;
  const SkeletonList({super.key, this.count = 7});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (_, __) => const JobCardSkeleton(),
    );
  }
}
