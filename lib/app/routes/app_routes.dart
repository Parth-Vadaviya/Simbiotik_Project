import 'package:get/get.dart';
import '../../views/dashboard/job_dashboard_view.dart';
import '../../views/detail/job_detail_view.dart';
import '../../views/splash/splash_view.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const dashboard = '/dashboard';
  static const detail = '/detail';
}

final List<GetPage> appPages = [
  GetPage(name: AppRoutes.splash, page: () => const SplashView()),
  GetPage(name: AppRoutes.dashboard, page: () => const JobDashboardView()),
  GetPage(name: AppRoutes.detail, page: () => const JobDetailView()),
];
