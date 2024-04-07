class UrlFields {
  static const String tableName = 'urls';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT';
  static const String requiredTextType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String url = 'url';
  static const String apiKey = 'api_key';

  static const List<String> values = [
    id,
    url,
    apiKey,
  ];
}

class UrlModel {
  final int? id;
  final String url;
  final String? apiKey;
  UrlModel({
    this.id,
    required this.url,
    this.apiKey,
  });

  Map<String, Object?> toJson() => {
        UrlFields.id: id,
        UrlFields.url: url,
        UrlFields.apiKey: apiKey,
      };

  factory UrlModel.fromJson(Map<String, Object?> json) => UrlModel(
        id: json[UrlFields.id] as int?,
        url: json[UrlFields.url] as String,
        apiKey: json[UrlFields.apiKey] as String,
      );

  UrlModel copy({
    int? id,
    String? url,
    String? apiKey,
  }) =>
      UrlModel(
        id: id ?? this.id,
        url: url ?? this.url,
        apiKey: apiKey ?? this.apiKey,
      );
}
