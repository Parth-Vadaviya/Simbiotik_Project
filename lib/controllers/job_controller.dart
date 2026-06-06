import 'package:get/get.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';

enum FeedStatus { idle, loading, success, error }

enum FeedFilter { all, bookmarked }

class JobController extends GetxController {
  final JobService _service = JobService();

  // Observable state
  final _status = FeedStatus.idle.obs;
  final _allJobs = <JobModel>[].obs;
  final _filteredJobs = <JobModel>[].obs;
  final _bookmarkedUrls = <String>{}.obs;
  final _searchQuery = ''.obs;
  final _activeFilter = FeedFilter.all.obs;
  String _errorMessage = '';

  // Getters
  FeedStatus get status => _status.value;
  List<JobModel> get jobs => _filteredJobs;
  String get errorMessage => _errorMessage;
  FeedFilter get activeFilter => _activeFilter.value;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
    ever(_searchQuery, (_) => _applyFilter());
    ever(_activeFilter, (_) => _applyFilter());
    // Re-apply filter when bookmarks change so bookmarked view stays fresh
    ever(_bookmarkedUrls, (_) => _applyFilter());
  }

  Future<void> fetchJobs() async {
    _status.value = FeedStatus.loading;
    _errorMessage = '';
    try {
      final jobs = await _service.fetchJobs();
      _allJobs.assignAll(jobs);
      _applyFilter();
      _status.value = FeedStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status.value = FeedStatus.error;
    }
  }

  void search(String query) {
    _searchQuery.value = query.trim().toLowerCase();
  }

  void setFilter(FeedFilter filter) {
    _activeFilter.value = filter;
  }

  void _applyFilter() {
    final q = _searchQuery.value;

    Iterable<JobModel> base = _allJobs;

    // Bookmarked filter
    if (_activeFilter.value == FeedFilter.bookmarked) {
      base = base.where((j) => _bookmarkedUrls.contains(j.url));
    }

    // Search filter
    if (q.isNotEmpty) {
      base = base.where(
        (j) =>
            j.title.toLowerCase().contains(q) ||
            j.companyName.toLowerCase().contains(q),
      );
    }

    _filteredJobs.assignAll(base);
  }

  void toggleBookmark(String url) {
    if (_bookmarkedUrls.contains(url)) {
      _bookmarkedUrls.remove(url);
    } else {
      _bookmarkedUrls.add(url);
    }
  }

  bool isBookmarked(String url) => _bookmarkedUrls.contains(url);
  int get bookmarkCount => _bookmarkedUrls.length;
  int get allJobCount => _allJobs.length;
}
