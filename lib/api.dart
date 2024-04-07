import 'package:code_edit/dtos/repository.dart';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';

final dio = Dio();
var baseUrl = "https://48e2-186-210-89-87.ngrok-free.app";

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
    developer.log(e as String);
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
    developer.log(e as String);
    return Map();
  }
}

Future<List<dynamic>> getFileDetail(String fileDir, String repoName) async {
  try {
    final response = await dio.get(
        "$baseUrl/repositorys/file/detail?file_dir=$fileDir&repo_name=$repoName");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("error in get repos.");
    }
  } on Exception catch (e) {
    developer.log(e as String);
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
    developer.log(e as String);
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
    developer.log(e as String);
    return false;
  }
}

Future<bool> autoChange(
  String fileDir,
  String typeChange,
  String? problem,
  String repoName,
) async {
  try {
    final payload = {
      "repo_name": repoName,
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
    developer.log(e as String);
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
    developer.log(e as String);
    return false;
  }
}

Future<bool> createRepo(
    String repoName, String repoUrl, String repoBranch) async {
  try {
    final payload = {
      "repo_name": repoName,
      "branch": repoBranch,
      "repo_url": repoUrl,
    };
    final response = await dio.post("$baseUrl/repositorys", data: payload);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("error in update repo");
    }
  } on Exception catch (e) {
    developer.log(e as String);
    return false;
  }
}

Future<String> getPublicKey() async {
  try {
    final response = await dio.get(
      "$baseUrl/repositorys/keys/default",
    );
    if (response.statusCode == 200) {
      return response.data["data"];
    } else {
      throw Exception("error in update repo");
    }
  } on Exception catch (e) {
    developer.log(e as String);
    return '';
  }
}
