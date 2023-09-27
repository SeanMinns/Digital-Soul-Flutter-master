import 'dart:convert';

import 'package:digital_soul/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Set with ChangeNotifier {
  final String? number;
  final List<String>? answers;
  final List<int>? timer;

  Set({
    @required this.number,
    @required this.answers,
    @required this.timer,
  });
}

class Sets with ChangeNotifier {
  List<Set> _sets = [];

  String? token;
  String? id;

  Sets(this.token, this.id, this._sets);

  List<Set> get sets {
    return [..._sets];
  }

  Future<void> addSet(
    int setNumber,
    List<String> questions,
    List<dynamic> answers,
    List<int> timer,
  ) async {
    try {
      var url = "https://digitalsoulmclean.com/api/users/sets/add/$setNumber";
      List<Map<String, String>> dataAnswer = [];
      for (int i = 0; i < answers.length; i++) {
        dataAnswer.add({
          "question": questions[i].toString(),
          "answer": "${answers[i].toString()}",
          "timeTaken": "${timer[i].toString()}",
        });
      }
      Map apiData = {
        "id": id,
        "setAnswers": dataAnswer,
      };
      print(apiData);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(apiData),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData['code'] == 0) {
        throw HttpException('Failed to add set $setNumber');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<int> setsProgress() async {
    try {
      const url = "https://digitalsoulmclean.com/api/users/checkSetsStatus";
      Map apiData = {
        "id": id,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(apiData),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData['code'] == 0) {
        throw '';
      }
      bool data1 = extractedData['initialQuestions'];
      List<int>? data2;
      if (data1) {
        data2 = List<int>.from(extractedData['setsCompleted']);
      }
      return data1 ? data2!.length : -1;
    } catch (error) {
      throw error;
    }
  }
}
