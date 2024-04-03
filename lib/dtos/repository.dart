class Repository {
  final String name;
  final String? branch;
  final String dir;

  Repository({required this.name, this.branch, required this.dir});

  factory Repository.fromJson(Map<String, dynamic> json) => Repository(
      name: json["name"], branch: json["branch"], dir: json["repo_dir"]);
}
