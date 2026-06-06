class JobModel {
  final String title;
  final String companyName;
  final String location;
  final String description;
  final String url;

  const JobModel({
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.url,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      title: (json['title'] as String? ?? '').trim(),
      companyName: (json['company_name'] as String? ?? '').trim(),
      location: (json['location'] as String? ?? '').trim(),
      description: (json['description'] as String? ?? '').trim(),
      url: (json['url'] as String? ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'company_name': companyName,
        'location': location,
        'description': description,
        'url': url,
      };
}
