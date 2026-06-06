import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';
import '../../app/widgets/hirehub_logo.dart';
import '../dashboard/job_dashboard_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );

    _scaleAnim = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _taglineFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _ctrl.forward();

    // Navigate after animation settles
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Get.off(
          () => const JobDashboardView(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      body: Stack(
        children: [
          // Soft radial glow behind logo
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _fadeAnim,
              builder: (_, __) => Opacity(
                opacity: _fadeAnim.value * 0.22,
                child: Center(
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.accent,
                          AppTheme.scaffold.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo with scale + fade
                AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.scale(
                      scale: _scaleAnim.value,
                      child: const HireHubLogo(size: 88),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // App name
                AnimatedBuilder(
                  animation: _fadeAnim,
                  builder: (_, __) => Opacity(
                    opacity: _fadeAnim.value,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hire',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'Hub',
                            style: TextStyle(
                              color: AppTheme.accent,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline fades in slightly after logo
                AnimatedBuilder(
                  animation: _taglineFade,
                  builder: (_, __) => Opacity(
                    opacity: _taglineFade.value,
                    child: const Text(
                      'Find your next role',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom version tag
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _taglineFade,
              builder: (_, __) => Opacity(
                opacity: _taglineFade.value * 0.5,
                child: const Text(
                  'v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
