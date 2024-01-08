
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../Models/repository.dart';

class RepositoryProvider with ChangeNotifier {


  Database? _database;

  RepositoryProvider() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'repositories_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE repositories(id INTEGER PRIMARY KEY, name TEXT,  image TEXT,  login TEXT)',
        );
      },
      version: 1,
    );
     initAPI();
  }

  Future<void> insertRepositories(List<Repository> repositories) async {
    final Batch batch = _database!.batch();
    batch.delete('repositories');
    for (Repository repository in repositories) {
      batch.insert('repositories', repository.toMap());
    }
    await batch.commit();
  }

  Future<List<Repository>> fetchRepositories() async {
    await Future.delayed(Duration(seconds: 5));
    final List<Map<String, dynamic>> maps = await _database!.query('repositories');

    return List.generate(maps.length, (i) {
      return Repository(
        id: maps[i]['id'],
        name: maps[i]['name'],
        image: maps[i]['image'],
        login: maps[i]['login'],

      );
    });
  }

  Future<void> refreshData(BuildContext context) async {
    final response = await http.get(Uri.parse('https://api.github.com/search/repositories?q=created:>${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))}&sort=stars&order=desc'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Repository> repositories = List.generate(data['items'].length, (i) {
        return Repository(
          id: data['items'][i]['id'],
          name: data['items'][i]['name'],
          image: data['items'][i]['owner']['avatar_url'],
          login: data['items'][i]['owner']['login'],

        );
      });

      await insertRepositories(repositories);
      notifyListeners();
      await Future.delayed(const Duration(seconds: 5));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data has been refreshed.'),
        ),
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> initAPI() async{
    final response = await http.get(Uri.parse('https://api.github.com/search/repositories?q=created:%3E2022-04-29&sort=stars&order=desc'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Repository> repositories = List.generate(data['items'].length, (i) {
        return Repository(
          id: data['items'][i]['id'],
          name: data['items'][i]['name'],
          image: data['items'][i]['owner']['avatar_url'],
          login: data['items'][i]['owner']['login'],

        );
      });

      await insertRepositories(repositories);
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }
}