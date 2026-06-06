import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

class JobService {
  static const String _baseUrl = 'https://www.arbeitnow.com/api/job-board-api';

  Future<List<JobModel>> fetchJobs() async {
    final response = await http
        .get(Uri.parse(_baseUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List<dynamic> data = body['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load jobs: ${response.statusCode}');
    }
  }
}
