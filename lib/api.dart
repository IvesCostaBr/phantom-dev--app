import 'package:code_edit/dtos/repository.dart';
import 'package:dio/dio.dart';

final dio = Dio();
const baseUrl = "https://92ea-189-112-244-4.ngrok-free.app";

Future<List<Repository>> getRepos() async {
  try {
    final response = await dio.get("$baseUrl/repositorys");

    if (response.statusCode == 200) {
      List<Repository> repositories = [];
      for (var item in response.data) {
        repositories.add(Repository.fromJson(item));
      }
      return repositories;
    } else {
      throw Exception("error in get repos.");
    }
  } on Exception catch (e) {
    return [];
  }
}

Future<Map<String, dynamic>> getRepoTree(String repoName) async {
  try {
    final response = await dio.get("$baseUrl/repositorys/$repoName");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("error in get repos.");
    }
  } on Exception catch (e) {
    return Map();
  }
}

Future<List<dynamic>> getFileDetail(String fileDir) async {
  try {
    final response =
        await dio.get("$baseUrl/repositorys/file/detail?file_dir=$fileDir");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("error in get repos.");
    }
  } on Exception catch (e) {
    return [];
  }
}

Future<bool> updateFile(
    String repoName, String fileDir, List<String> file) async {
  try {
    final payload = {"file_dir": fileDir, "code": file, "end": 0, "start": 0};

    final response =
        await dio.put("$baseUrl/repositorys/$repoName", data: payload);

    if (response.statusCode == 200) {
      return response.data["detail"];
    } else {
      throw Exception("error in get repos.");
    }
  } on Exception catch (e) {
    return false;
  }
}

Future<bool> commitRepo(String repoName) async {
  try {
    final response = await dio.post("$baseUrl/repositorys/$repoName/push");

    if (response.statusCode == 200) {
      return response.data["detail"];
    } else {
      throw Exception("error in get repos.");
    }
  } on Exception catch (e) {
    return false;
  }
}

Future<bool> autoChange(
  String fileDir,
  String typeChange,
  String? problem,
) async {
  try {
    final payload = {
      "file_dir": fileDir,
      "type": typeChange,
      "problem": problem
    };

    final response =
        await dio.post("$baseUrl/repositorys/auto-change", data: payload);
    if (response.statusCode == 200) {
      return response.data["detail"];
    } else {
      throw Exception("error in auto change");
    }
  } on Exception catch (e) {
    return false;
  }
}

Future<bool> revertChanges(String repoName) async {
  try {
    final response = await dio.post("$baseUrl/repositorys/revert-changes",
        queryParameters: {"repo_name": repoName});
    if (response.statusCode == 200) {
      return response.data["detail"];
    } else {
      throw Exception("error in update repo");
    }
  } on Exception catch (e) {
    return false;
  }
}

Future<bool> createRepo(String repoName, String repoUrl, String repoBranch,
    List<String> key) async {
  try {
    final payload = {
      "name": repoName,
      "branch": repoBranch,
      "repo_url": repoUrl,
      "key": key
    };
    final response = await dio.post("$baseUrl/repositorys", data: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("error in update repo");
    }
  } on Exception catch (e) {
    return false;
  }
}
