class UpdateInfo {
  final String version;
  final String downloadUrl;
  final List<String> added;
  final List<String> corrected;

  UpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.added,
    required this.corrected,
  });

  factory UpdateInfo.fromJson(json) => UpdateInfo(
        version: json['app_version'],
        downloadUrl: json['app_url'],
        added: List<String>.from(json['added']),
        corrected: List<String>.from(json['corrected']),
      );
}
